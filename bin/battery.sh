#!/usr/bin/env bash

source $HOME/.bash_functions
require_machine fightclub.local && echo "| `pmset -g ps | sed 's/;/ /g' | tail -n 1 | awk '{print $2 " ("$4")"}'` | "
