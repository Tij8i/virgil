#!/bin/bash
# Virgil soft-test v1
# Verify path (c) is operationally sound after a few days of normal use.
#
# Run anytime: bash ~/Documents/GitHub/virgil/scripts/soft-test.sh
#
# Pass criterion: 4/5 checks pass after a full week of use.
# If <3 pass after a week, diagnose the gap with Architect.

set +e  # don't abort on non-zero — we report each check

VIRGIL_DIR="$HOME/Documents/GitHub/virgil"
ROUTING_LOG="$VIRGIL_DIR/config/routing-decisions.log"
CORRECTIONS_LOG="$VIRGIL_DIR/config/corrections.log"
DAILY_NOTES_DIR=""  # configurable — see check 5; resolved from user.md if needed

# Pull vault path from user.md if accessible (best effort, optional)
USER_MD="$VIRGIL_DIR/config/user.md"
if [ -f "$USER_MD" ]; then
    VAULT_GUESS=$(grep -i "vault" "$USER_MD" 2>/dev/null | grep -oE '"[^"]*"' | head -1 | tr -d '"')
    if [ -n "$VAULT_GUESS" ] && [ -d "$VAULT_GUESS" ]; then
        DAILY_NOTES_DIR="$VAULT_GUESS/Daily Notes"
    fi
fi

PASS=0
FAIL=0
SKIP=0

print_header() {
    echo ""
    echo "=================================================================="
    echo "  Virgil soft-test v1  |  $(date '+%Y-%m-%d %H:%M')"
    echo "=================================================================="
    echo ""
}

print_summary() {
    echo ""
    echo "------------------------------------------------------------------"
    echo "  Summary"
    echo "------------------------------------------------------------------"
    echo "  Auto-checks: PASS=$PASS  FAIL=$FAIL  SKIP=$SKIP"
    echo "  Manual checks (3, 4, 5): see instructions above."
    echo ""
    echo "  Pass criterion: 4/5 of all 5 checks pass after a week of use."
    echo "  If <3 pass: surface to Architect for diagnosis."
    echo "=================================================================="
}

print_header

# ----------------------------------------------------------------------------
# CHECK 1 — Routing log fills up during normal use
# ----------------------------------------------------------------------------
echo "[1/5] Routing log fills up during normal use"
if [ -f "$ROUTING_LOG" ]; then
    LINES=$(wc -l < "$ROUTING_LOG" | tr -d ' ')
    if [ "$LINES" -gt 0 ]; then
        echo "  PASS — $LINES entries in $ROUTING_LOG"
        PASS=$((PASS+1))
    else
        echo "  FAIL — file exists but empty. Routing-log directive isn't firing."
        echo "         Check virgil/CLAUDE.md § Listening Mode → Routing-decision logging."
        FAIL=$((FAIL+1))
    fi
else
    echo "  FAIL — $ROUTING_LOG missing."
    echo "         Either Virgil hasn't routed anything yet (use it for a day first)"
    echo "         or the directive in CLAUDE.md isn't being honored."
    FAIL=$((FAIL+1))
fi
echo ""

# ----------------------------------------------------------------------------
# CHECK 2 — Item ID format
# ----------------------------------------------------------------------------
echo "[2/5] Item ID format check"
if [ -f "$ROUTING_LOG" ] && [ "$LINES" -gt 0 ] 2>/dev/null; then
    LAST_ID=$(tail -1 "$ROUTING_LOG" | python3 -c "import sys, json
try:
    obj = json.loads(sys.stdin.read())
    print(obj.get('item_id', ''))
except Exception:
    print('PARSE_ERROR')" 2>/dev/null)
    if [[ "$LAST_ID" =~ ^[0-9]+-[0-9a-fA-F]{8}$ ]]; then
        echo "  PASS — last entry item_id matches <ts>-<8-char-hex>: $LAST_ID"
        PASS=$((PASS+1))
    elif [ "$LAST_ID" = "PARSE_ERROR" ]; then
        echo "  FAIL — last log line is not valid JSON. Inspect with: tail -1 $ROUTING_LOG"
        FAIL=$((FAIL+1))
    else
        echo "  FAIL — item_id format off. Last entry: '$LAST_ID'"
        echo "         Expected format: <unix-ts>-<8-char-hex-hash>"
        FAIL=$((FAIL+1))
    fi
else
    echo "  SKIP — no log entries to check yet"
    SKIP=$((SKIP+1))
fi
echo ""

# ----------------------------------------------------------------------------
# CHECK 3 — Low-confidence handling (manual test)
# ----------------------------------------------------------------------------
echo "[3/5] Low-confidence handling — MANUAL TEST"
echo "  → Open Virgil. Send a deliberately ambiguous item, e.g.:"
echo "       'look into the pipeline for the next big project'"
echo "  → After Virgil acknowledges, check the latest log entry:"
echo "       tail -1 $ROUTING_LOG | python3 -m json.tool | grep size"
echo "  → PASS if 'size' is empty/null (Virgil left it blank — didn't guess)."
echo "  → FAIL if 'size' is Errand/Sub-task/Project (silently guessed)."
echo "  → Reference: virgil/CONTRACT.md § 5 (low-confidence rule)"
echo ""

# ----------------------------------------------------------------------------
# CHECK 4 — /correct writes corrections.log (manual test)
# ----------------------------------------------------------------------------
echo "[4/5] /correct writes corrections.log — MANUAL TEST"
echo "  → In Virgil, fire /correct on a recent routed item."
echo "  → Then verify:"
if [ -f "$CORRECTIONS_LOG" ]; then
    CL=$(wc -l < "$CORRECTIONS_LOG" | tr -d ' ')
    echo "       Current state: $CORRECTIONS_LOG has $CL line(s)."
    echo "       After firing /correct, line count should increase by 1."
else
    echo "       Current state: $CORRECTIONS_LOG does not exist yet."
    echo "       After firing /correct, the file should be created with 1 entry."
fi
echo "  → PASS if a new JSON line is appended to corrections.log."
echo "  → FAIL if no file write or skill not recognized."
echo ""

# ----------------------------------------------------------------------------
# CHECK 5 — Sunday /wrap-up writes Cycle Recap (time-bound)
# ----------------------------------------------------------------------------
echo "[5/5] Sunday /wrap-up writes Cycle Recap — TIME-BOUND"
TODAY_DOW=$(date +%u)  # 1=Mon, 7=Sun
TODAY_NAME=$(date +%A)
if [ "$TODAY_DOW" -eq 7 ]; then
    echo "  → Today is Sunday."
    echo "  → After running /wrap-up in Virgil, check today's daily note for:"
    echo "       grep '## Cycle Recap' \"\$DAILY_NOTES_DIR/$(date +%Y-%m-%d).md\""
    echo "  → PASS if the section exists with V value + trend (or 'baseline')."
    echo "  → FAIL if no Cycle Recap section after /wrap-up."
else
    DAYS_UNTIL_SUN=$((7 - TODAY_DOW))
    if [ "$DAYS_UNTIL_SUN" -eq 0 ]; then DAYS_UNTIL_SUN=7; fi
    echo "  → Today is $TODAY_NAME (DOW=$TODAY_DOW). Cycle ends Sunday."
    echo "  → Re-run this test after next Sunday's /wrap-up ($DAYS_UNTIL_SUN days)."
fi
echo ""

print_summary
