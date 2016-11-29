#!/bin/bash

# Runs the JSON parser over a suite of selected JSON test files

SHOULDPASS=testfiles/shouldpass/*
SHOULDFAIL=testfiles/shouldfail/*
TESTCOUNT=0
TESTSPASSED=0

echo "The following files should pass JSON testing:"
echo ""

for testfile in $SHOULDPASS
do
  ((TESTCOUNT++))
  java -jar jar/Compiler.jar $testfile &> /dev/null # Discard output
  if [ $? -eq 0 ] # Success exit code
    then
      ((TESTSPASSED++))
      echo "[✓] $testfile passed as expected"
    else
      echo "[x] ERROR: $testfile should pass"
  fi
done

echo ""
echo "The following files are not valid JSON:"
echo ""

for testfile in $SHOULDFAIL
do
  ((TESTCOUNT++))
  java -jar jar/Compiler.jar $testfile &> /dev/null # Discard output
  if [ $? -eq 1 ] # Error exit code
    then
      ((TESTSPASSED++))
      echo "[✓] $testfile failed as expected"
    else
      echo "[x] ERROR: $testfile should fail"
  fi
done

echo ""

echo $TESTSPASSED of $TESTCOUNT tests passed
