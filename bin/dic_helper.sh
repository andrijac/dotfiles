#!/usr/bin/env bash

# Asks for a word to define and launches 'dict'
echo -n 'Word to define: ' && read text && (dict $text | less)
