#!/bin/sh

build_dir="build"

main_dir="$build_dir/main"
basic_dir="$build_dir/basic"
modernpro_dir="$build_dir/modernpro"

pdf_dir_suffix="pdf"
svg_dir_suffix="svg"

mkdir -p "$main_dir/$pdf_dir_suffix"
mkdir -p "$main_dir/$svg_dir_suffix"
mkdir -p "$basic_dir/$pdf_dir_suffix"
mkdir -p "$basic_dir/$svg_dir_suffix"
mkdir -p "$modernpro_dir/$pdf_dir_suffix"
mkdir -p "$modernpro_dir/$svg_dir_suffix"

compile() {
  echo "Compiling Typst CV in $1"
  echo "Compiling PDF"
  typst compile --input lang="$1" --root ../../ src/main/main.typ "$main_dir/$pdf_dir_suffix/cv-$1.pdf"
  typst compile --input lang="$1" --root ../../ src/basic/basic.typ "$basic_dir/$pdf_dir_suffix/cv-$1.pdf"
  typst compile --input lang="$1" --root ../../ src/modernpro/modernpro.typ "$modernpro_dir/$pdf_dir_suffix/cv-$1.pdf"
  echo "Compiling SVG"
  typst compile --input lang="$1" --format svg --root ../../ src/main/main.typ "$main_dir/$svg_dir_suffix/cv-$1-{0p}.svg"
  typst compile --input lang="$1" --format svg --root ../../ src/basic/basic.typ "$basic_dir/$svg_dir_suffix/cv-$1-{0p}.svg"
  typst compile --input lang="$1" --format svg --root ../../ src/modernpro/modernpro.typ "$modernpro_dir/$svg_dir_suffix/cv-$1-{0p}.svg"
}

compile en
compile pt