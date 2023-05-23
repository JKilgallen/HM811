#!/bin/bash
mkdir -p ../reports/plots
echo "Generating plots."
octave rays.m
octave circles.m
octave gratings.m
echo "Done."
cd ../reports
echo "Compiling document."
latexmk -pdf mackay_effect.tex
echo "Done."