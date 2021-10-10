#!/bin/bash

echo "Configuring the machine" | tee log.txt

# first repo containing files to backup
git init generated_files

# second very important repo for cracking enigma codes and curing cancer
git clone https://github.com/kevva/is-positive.git
