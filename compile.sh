#!/bin/sh

build_dir="build"

if [ -n "$1" ] && [ "$1" != "-" ]; then
  models=$(echo "$1" | tr ',' ' ')
else
  models="main basic modernpro stephenxu"
fi

if [ -n "$2" ] && [ "$2" != "-" ]; then
  output_formats=$(echo "$2" | tr ',' ' ')
else
  output_formats="pdf svg"
fi

if [ -n "$3" ] && [ "$3" != "-" ]; then
  languages=$(echo "$3" | tr ',' ' ')
else
  languages="en pt"
fi

for model in $models; do
  for format in $output_formats; do
    # rm -rf "${build_dir:?}/${model:?}/${format:?}"
    mkdir -p "$build_dir/$model/$format"
  done
done

upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}



compile() {
  model="$1"
  format="$2"
  lang="$3"

  filename="cv-$lang-$model.$format"

  if [ "$format" = "svg" ] || [ "$format" = "png" ]; then
    filename="cv-$lang-$model-{0p}.$format"
  fi
  
  echo "Compiling $(upper "$model $format $lang") to $build_dir/$model/$format/$filename"
  typst compile --input lang="$lang" --format "$format" --root ../../ "src/$model/$model.typ" "$build_dir/$model/$format/$filename"
}

for model in $models; do
  for format in $output_formats; do
    for lang in $languages; do
      compile "$model" "$format" "$lang"
    done
  done
done