#!/usr/bin/env python

import numpy as np
import subprocess
import sys
import os
import sys

inputOptions = sys.argv[1:]

#usage: file1


def main():


	input_file = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]

	print_line=bool(0)
	for line in input_file:
		
		if line[0:1]==">":
			print_line=bool(0)
		if line.find("16S ribosomal RNA")!=-1:
			print_line=bool(1)
		if print_line==bool(1):
			print line
		

main()
