#!/bin/bash
set -o errexit

function runTest(){
  echo $1
  tests/$1
}

runTest greetingsTest.sh
runTest mathTests.sh
