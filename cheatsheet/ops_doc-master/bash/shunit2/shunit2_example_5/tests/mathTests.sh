#!/bin/bash

testOnePlusOneIsTwo(){
  assertEquals "1+1 should equal 2" 2 $((1 + 1)) 
}


#load shunit2
. ../shunit2
