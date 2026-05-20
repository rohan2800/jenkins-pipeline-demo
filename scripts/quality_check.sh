#!/bin/bash
# Code Quality Checks

echo "================================"
echo "  Code Quality Analysis"
echo "================================"

ISSUES=0

# Check 1: No hardcoded passwords
if grep -r "password=" src/ 2>/dev/null | grep -v "^Binary"; then
    echo "❌ Hardcoded passwords found"
    ((ISSUES++))
else
    echo "✅ No hardcoded passwords"
fi

# Check 2: No TODO left in code
TODO_COUNT=$(grep -r "TODO\|FIXME\|HACK" src/ 2>/dev/null | wc -l)
if [ "$TODO_COUNT" -gt 0 ]; then
    echo "⚠️  Found ${TODO_COUNT} TODO/FIXME items (warning only)"
else
    echo "✅ No TODO/FIXME items"
fi

# Check 3: All scripts are executable
find src/ -name "*.sh" | while read f; do
    if [ ! -x "$f" ]; then
        echo "❌ Not executable: $f"
        ((ISSUES++))
    else
        echo "✅ Executable: $f"
    fi
done

# Check 4: Config file has required keys
REQUIRED_KEYS=("APP_NAME" "APP_VERSION" "APP_PORT")
for key in "${REQUIRED_KEYS[@]}"; do
    if grep -q "^${key}=" config/app.conf; then
        echo "✅ Config key found: ${key}"
    else
        echo "❌ Missing config key: ${key}"
        ((ISSUES++))
    fi
done

echo "================================"
echo "  Quality Issues Found: ${ISSUES}"
echo "================================"

[ "$ISSUES" -eq 0 ] || exit 1
