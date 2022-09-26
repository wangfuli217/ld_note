#!/bin/bash

function greet() {
  echo "Hello World"
}

function writeGreeting() {
  echo $(greet) >> $1
}
