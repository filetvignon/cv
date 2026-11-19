# CV in Typst

## Git Hooks

This repository tracks hooks in `.githooks/`.

After cloning, run:

```bash
git config core.hooksPath .githooks
```

The `pre-push` hook compiles all templates in english and portuguese, stages compiled files, and amends the latest commit if any files have changed.

## Previews

### Clean (recommended)

Custom single-column, one-page template built for ATS parsing. Uses the bundled Inter font in `fonts/`
(passed by `compile.sh` via `--font-path fonts`), so it renders identically on any machine.

![CV - Clean](./build/clean/svg/cv-en-clean-1.svg)

### Modernpro

<https://github.com/jxpeng98/Typst-CV-Resume>

![CV - Modernpro](./build/modernpro/svg/cv-en-modernpro-1.svg)
![CV - Modernpro](./build/modernpro/svg/cv-en-modernpro-2.svg)

### StephenXu

<https://github.com/stuxf/basic-typst-resume-template>

![CV - StephenXu](./build/stephenxu/svg/cv-en-stephenxu-1.svg)
![CV - StephenXu](./build/stephenxu/svg/cv-en-stephenxu-2.svg)

### Technical

<https://github.com/steadyfall/simple-technical-resume-template>

![CV - Technical](./build/technical/svg/cv-en-technical-1.svg)
![CV - Technical](./build/technical/svg/cv-en-technical-2.svg)

### Typographic

<https://github.com/tsnobip/typst-typographic-resume>

![CV - Typographic](./build/typographic/svg/cv-en-typographic-1.svg)

## Other templates

- <https://github.com/roaldarbol/academicv>
