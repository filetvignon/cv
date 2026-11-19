#!/bin/sh
# Usage: ./compile.sh [models] [formats] [languages] [papers]
#   Comma-separated lists; "-" or empty means the default.
#   models:    clean,typographic,technical,modernpro,stephenxu (default: all)
#   formats:   pdf,svg (default: both)
#   languages: en,pt (default: both)
#   papers:    a4,us-letter (default: each language's default, US Letter for en, A4 for pt)
# Examples:
#   ./compile.sh clean pdf en          -> build/clean/pdf/Felipe-Vignon-Resume.pdf (US Letter)
#   ./compile.sh clean pdf en a4       -> build/clean/pdf/a4/Felipe-Vignon-Resume.pdf

build_dir="build"

if [ -n "$1" ] && [ "$1" != "-" ]; then
  models=$(echo "$1" | tr ',' ' ')
else
  models="clean typographic technical modernpro stephenxu"
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

if [ -n "$4" ] && [ "$4" != "-" ]; then
  papers=$(echo "$4" | tr ',' ' ')
else
  papers="default"
fi

upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}



doc_name() {
  case "$1" in
    pt) echo "Felipe-Vignon-Curriculo" ;;
    *) echo "Felipe-Vignon-Resume" ;;
  esac
}

compile() {
  model="$1"
  format="$2"
  lang="$3"
  paper="$4"

  # Default paper goes to build/<model>/<format>/; an explicit paper gets its own subfolder
  out_dir="$build_dir/$model/$format"
  paper_arg=""
  if [ "$paper" != "default" ]; then
    out_dir="$out_dir/$paper"
    paper_arg="--input paper=$paper"
  fi
  mkdir -p "$out_dir"

  # Recruiters see the file name, so name it after the person, not the template.
  # Each template still has its own folder: build/<model>/<format>/
  base="$(doc_name "$lang")"
  filename="$base.$format"

  if [ "$format" = "svg" ] || [ "$format" = "png" ]; then
    filename="$base-{0p}.$format"
  fi
  
  echo "Compiling $(upper "$model $format $lang $paper") to $out_dir/$filename"
  # shellcheck disable=SC2086 # paper_arg is intentionally unquoted (empty or one flag)
  typst compile --font-path fonts --input lang="$lang" $paper_arg --format "$format" --root ../../ "src/$model/$model.typ" "$out_dir/$filename"
}

for model in $models; do
  for format in $output_formats; do
    for lang in $languages; do
      for paper in $papers; do
        compile "$model" "$format" "$lang" "$paper"
      done
    done
  done
done