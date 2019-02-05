#!/bin/bash

rm -f All.v
cat *.v > All.v
sed -i -e 's/^`include.*//g' -e 's/.*__.*//g' ./All.v

