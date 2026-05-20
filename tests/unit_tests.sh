#!/bin/bash
# Unit Test Suite

PASS=0
FAIL=0
TESTS=()

run_test() {
    local name="$1"
    local result="$2"
    if [ "$result" -eq 0 ]; then
        echo "  ✅ PASS: ${name}"
        ((PASS++))
    else
        echo "  ❌ FAIL: ${name}"
        ((FAIL++))
    fi
}

echo "==============================="
echo "  Running Unit Tests"
echo "==============================="

# Test 1: App file exists
test -f src/app.sh
run_test "App file exists" $?

# Test 2: App is executable
test -x src/app.sh
run_test "App is executable" $?

# Test 3: Version string present
grep -q "APP_VERSION" src/app.sh
run_test "Version string present" $?

# Test 4: App runs without error
bash src/app.sh > /dev/null 2>&1
run_test "App runs successfully" $?

# Test 5: Config exists
test -f config/app.conf
run_test "Config file exists" $?

echo "==============================="
echo "  Results: ${PASS} passed, ${FAIL} failed"
echo "==============================="

# Fail the build if any test fails
[ "$FAIL" -eq 0 ] || exit 1
