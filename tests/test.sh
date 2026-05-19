#!/bin/bash
echo "=== Running Tests ==="

# Test 1
if [ -f app/app.sh ]; then
    echo "✅ Test 1 Passed: app.sh exists"
else
    echo "❌ Test 1 Failed: app.sh missing"
    exit 1
fi

# Test 2
if grep -q "Version" app/app.sh; then
    echo "✅ Test 2 Passed: Version string found"
else
    echo "❌ Test 2 Failed: Version string missing"
    exit 1
fi

echo "All tests passed ✅"
