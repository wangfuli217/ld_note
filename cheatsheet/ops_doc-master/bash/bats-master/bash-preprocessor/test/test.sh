#!/bin/bash

# Set project root as the working directory
cd "$(dirname "$0")"

# Set up example files
rm -rf target
cp -r examples target

# Run tests
lib/bats-core/bin/bats test.bats

