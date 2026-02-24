# CV in Typst

<https://github.com/tsnobip/typst-typographic-resume>
<https://github.com/roaldarbol/academicv>

## Git Hooks

This repository tracks hooks in `.githooks/`.

After cloning, run:

```bash
git config core.hooksPath .githooks
```

The `pre-push` hook compiles `main.typ`, stages compiled files, and amends the latest commit if the files have changed.

## Previews

### English

![CV - English](./build/svg/cv-en.svg)

### Portuguese

![CV - Portuguese](./build/svg/cv-pt.svg)
