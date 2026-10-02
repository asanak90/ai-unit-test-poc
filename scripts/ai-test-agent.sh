#!/bin/bash

set -u

MAX_ATTEMPTS=3

GENERATED_TEST="ai/generated/PaymentServiceTests.Generated.cs"
PROJECT_TEST_FILE="PaymentService.Tests/PaymentServiceTests.Generated.cs"
VALIDATION_OUTPUT="ai/output/validation-output.txt"

echo "======================================"
echo " AI Unit Test Agent"
echo "======================================"

echo ""
echo "--------------------------------------"
echo " Step 1: Generate unit tests"
echo "--------------------------------------"

python3 scripts/generate-tests.py

for ATTEMPT in $(seq 1 $MAX_ATTEMPTS)
do
    echo ""
    echo "======================================"
    echo " Validation Attempt $ATTEMPT / $MAX_ATTEMPTS"
    echo "======================================"

    echo ""
    echo "Copying generated tests..."

    cp "$GENERATED_TEST" "$PROJECT_TEST_FILE"

    set +e

    dotnet build AiUnitTestPoc.slnx > "$VALIDATION_OUTPUT" 2>&1
    BUILD_STATUS=$?

    if [ $BUILD_STATUS -eq 0 ]; then
        dotnet test AiUnitTestPoc.slnx --no-build >> "$VALIDATION_OUTPUT" 2>&1
        TEST_STATUS=$?
    else
        TEST_STATUS=1
    fi

    set -e

    cat "$VALIDATION_OUTPUT"

    if [ $BUILD_STATUS -eq 0 ] && [ $TEST_STATUS -eq 0 ]; then

        echo ""
        echo "======================================"
        echo " AI Unit Test Agent SUCCESS"
        echo "======================================"

        echo ""
        echo "Generated tests:"
        grep -c "\[Fact\]" "$GENERATED_TEST"

        echo ""
        echo "Validation attempt: $ATTEMPT"

        exit 0
    fi

    echo ""
    echo "======================================"
    echo " Validation FAILED"
    echo "======================================"

    if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then

        echo ""
        echo "Maximum correction attempts reached."

        exit 1
    fi

    echo ""
    echo "--------------------------------------"
    echo " Sending failure feedback to AI"
    echo "--------------------------------------"

    python3 scripts/fix-generated-tests.py

done