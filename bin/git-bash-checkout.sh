#!/bin/bash

echo -ne "\033]0;$1\a"

cd "$1"

checkout

exec bash



