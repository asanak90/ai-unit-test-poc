#!/bin/bash

set -e

echo "======================================"
echo " AI Unit Test - Validation"
echo "======================================"

GENERATED_TEST="ai/generated/PaymentServiceTests.Generated.cs"
PROJECT_TEST_FILE="PaymentService.Tests/PaymentServiceTests.Generated.cs"
VALIDATION_OUTPUT="ai/output/validation-output.txt"

if [ ! -f "$GENERATED_TEST" ]; then
    echo "ERROR: Generated test file not found:"
    echo "$GENERATED_TEST"
    exit 1
fi

echo ""
echo "Generated test found:"
echo "$GENERATED_TEST"

echo ""
echo "--------------------------------------"
echo "Copying generated tests"
echo "--------------------------------------"

cp "$GENERATED_TEST" "$PROJECT_TEST_FILE"

echo "Copied to:"
echo "$PROJECT_TEST_FILE"

echo ""
echo "--------------------------------------"
echo "Building solution"
echo "--------------------------------------"

set +e

dotnet build AiUnitTestPoc.slnx > "$VALIDATION_OUTPUT" 2>&1
BUILD_STATUS=$?

set -e

cat "$VALIDATION_OUTPUT"

if [ $BUILD_STATUS -ne 0 ]; then
    echo ""
    echo "AI-generated tests failed compilation."
    echo "Validation output saved to:"
    echo "$VALIDATION_OUTPUT"
    exit 1
fi

echo ""
echo "--------------------------------------"
echo "Running unit tests"
echo "--------------------------------------"

set +e

dotnet test AiUnitTestPoc.slnx --no-build >> "$VALIDATION_OUTPUT" 2>&1
TEST_STATUS=$?

set -e

cat "$VALIDATION_OUTPUT"

if [ $TEST_STATUS -ne 0 ]; then
    echo ""
    echo "AI-generated tests failed."
    echo "Validation output saved to:"
    echo "$VALIDATION_OUTPUT"
    exit 1
fi

echo ""
echo "======================================"
echo " AI-generated tests passed"
echo "======================================"