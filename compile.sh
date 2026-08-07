#!/bin/sh

build_dir="build"
pdf_dir_suffix="pdf"
svg_dir_suffix="svg"

models="main basic modernpro stephenxu"
languages="en pt"

mkdir -p "$build_dir"
rm -rf "${build_dir:?}"/*

for model in $models; do
  mkdir -p "$build_dir/$model/$pdf_dir_suffix"
  mkdir -p "$build_dir/$model/$svg_dir_suffix"
done

compile() {
  lang="$1"
  echo "Compiling Typst CV in $lang"
  
  for model in $models; do
    echo "Compiling $model PDF"
    typst compile --input lang="$lang" --root ../../ src/$model/$model.typ "$build_dir/$model/$pdf_dir_suffix/cv-$lang-$model.pdf"
    
    echo "Compiling $model SVG"
    typst compile --input lang="$lang" --format svg --root ../../ src/$model/$model.typ "$build_dir/$model/$svg_dir_suffix/cv-$lang-$model-{0p}.svg"
  done
}

for lang in $languages; do
  compile "$lang"
done