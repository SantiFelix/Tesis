#!/bin/bash
# rm *.out
# rm *.bcf
# rm *.dvi
# rm *.lof
# rm *.log
# rm *.aux
# rm *.lot
# rm *.out.ps
# rm *.run.xml
# rm *.gz
# rm *.toc
pdflatex -interaction=nonstopmode thesis-example.tex
pdflatex -interaction=nonstopmode thesis-example.tex
open thesis-example.pdf