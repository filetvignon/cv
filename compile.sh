#!/bin/sh

pdf_dir="build/pdf"
svg_dir="build/svg"

compile() {
  echo "Compiling Typst CV in $1"
  echo "Compiling PDF"
  typst compile --input lang="$1" main.typ "$pdf_dir/cv-$1.pdf"
  echo "Compiling SVG"
  typst compile --input lang="$1" --format svg main.typ "$svg_dir/cv-$1.svg"
}

compile en
compile pt