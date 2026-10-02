#!/bin/bash

set -e

echo "======================================"
echo " AI Unit Test - Code Analysis"
echo "======================================"

BASE_SHA="${BASE_SHA}"
HEAD_SHA="${HEAD_SHA}"

echo ""
echo "Changed C# files:"
echo "--------------------------------------"

CHANGED_FILES=$(git diff --name-only "$BASE_SHA" "$HEAD_SHA" -- '*.cs')

if [ -z "$CHANGED_FILES" ]; then
    echo "No C# files changed."
    exit 0
fi

echo "$CHANGED_FILES"

echo ""
echo "======================================"
echo " Source Code Analysis"
echo "======================================"

for FILE in $CHANGED_FILES
do
    echo ""
    echo "--------------------------------------"
    echo "File: $FILE"
    echo "--------------------------------------"

    echo ""
    echo "Classes:"
    grep -E "class [A-Za-z0-9_]+" "$FILE" || true

    echo ""
    echo "Methods:"
    grep -E "public |private |protected |internal " "$FILE" | grep -E "\(" || true

    echo ""
    echo "Conditional statements:"
    grep -E "if \(" "$FILE" || true
done

echo ""
echo "======================================"
echo " Existing Test Files"
echo "======================================"

find . -name "*Tests.cs" -o -name "*Test.cs"

echo ""
echo "======================================"
echo " Analysis Complete"
echo "======================================"