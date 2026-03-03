#import "@preview/to-stuff:0.5.1" as to
#import "@preview/cmarker:0.1.8"

#let inputs = sys.inputs
#let valid-langs = ("en", "pt")

#let lang = if inputs != none and "lang" in inputs and inputs.lang != none {
  inputs.lang
} else {
  "en"
}

#if lang not in valid-langs {
  panic("Invalid language: " + lang + ". Supported languages are: " + valid-langs.join(","))
}

#let translations-file = "i18n/" + lang + ".yaml"
#let translations = yaml(translations-file)

#let default-theme = (
  margin: 26pt,
  font: "Libre Baskerville",
  font-size: 8pt,
  dot-size: 6pt,
  font-secondary: "Roboto",
  font-tertiary: "Montserrat",
  text-color: rgb("#3f454d"),
  gutter-size: 4em,
  main-width: 2fr,
  aside-width: 1fr,
  profile-picture-width: 70%,
)

#let translate(key, table: translations) = {
  if key == none {
    return panic("Must provide a key to translate")
  }
  let found-key = table.at(key, default: none)

  if found-key != none {
    return found-key
  }

  let split-keys = key.split(".")
  let first-key = split-keys.first(default: none)

  if first-key == none {
    return panic("Translation key '" + key + "' not found in translations table")
  }

  found-key = table.at(first-key, default: none)
  if found-key == none {
    return panic("Translation key '" + key + "' not found in translations table")
  }

  if type(found-key) != dictionary {
    return found-key
  }

  let new-key = split-keys.slice(1).join(".")

  return translate(new-key, table: found-key)
}


#let resume(
  first-name: "",
  last-name: "",
  titles: (),
  bio: "",
  profile-picture: none,
  theme: (),
  aside: [],
  main,
) = {
  // Function to pick a key from the theme, or a default if not provided.
  let th(key, default: none) = {
    return if key in theme and theme.at(key) != none {
      theme.at(key)
    } else if default != none and default in theme and theme.at(default) != none {
      theme.at(default)
    } else if default != none {
      default-theme.at(default)
    } else {
      default-theme.at(key)
    }
  }

  set page(
    margin: (
      top: th("margin"),
      bottom: th("margin"),
      left: th("margin"),
      right: th("margin"),
    ),
  )

  // Fix for https://github.com/typst/typst/discussions/2919
  show heading.where(level: 1): set text(size: th("font-size"))
  show heading.where(level: 2): set text(size: th("font-size"))
  show heading.where(level: 3): set text(size: th("font-size"))

  show heading.where(level: 1): set text(font: th("font-tertiary"), weight: "light")

  set text(font: th("font"), size: th("font-size"), fill: th("text-color"))

  set block(above: 10pt, below: 8pt, spacing: 10pt)

  set grid(columns: (th("gutter-size"), 1fr))

  grid(
    columns: (th("aside-width"), th("margin"), th("main-width")),

    // Aside.
    {
      {
        {
          show heading: set block(above: 0pt, below: 0pt)
          show heading: set text(size: 12pt, weight: "regular", font: th("font"), fill: th("text-color"))
          heading(level: 2, first-name)
        }
        {
          show heading: set block(above: 3pt, below: 0pt)
          show heading: set text(size: 26pt, weight: "regular", font: th("font"), fill: th("text-color"))

          heading(level: 1, last-name)
        }
        {
          show heading: set block(above: 10pt, below: 0pt)
          show heading: set text(weight: "light", font: th("font-tertiary"))
          for title in titles {
            heading(level: 3, upper(title))
          }
        }

        if profile-picture != none {
          set block(radius: 100%, clip: true, above: 1fr, below: 1fr)
          set align(center)
          set image(width: th("profile-picture-width"))
          profile-picture
        } else {
          v(1fr)
        }


        set text(weight: "light", style: "italic", hyphenate: true)
        set par(leading: 1.0em)
        cmarker.render(bio)
      }

      aside
    },

    // Empty space.
    {},

    // Content.
    main,
  )
}


#let section(
  theme: (),
  title,
  body,
) = {
  show heading.where(level: 1): set align(theme.start) if "align-title" in theme
  show heading.where(level: 1): set align(start) if not "align-title" in theme

  if "space-above" not in theme {
    v(1fr)
  } else {
    v(theme.space-above)
  }


  heading(level: 1, upper(title))
  {
    set block(above: 2pt, below: 14pt)
    line(stroke: 1pt, length: 100%)
  }
  body
}

#let contact-entry(
  theme: (),
  icon-padding: none,
  gutter,
  right,
) = {
  set grid(columns: (theme.gutter-size, 1fr)) if "gutter-size" in theme
  set text(font: theme.font-secondary) if "font-secondary" in theme
  set text(font: default-theme.font-secondary) if "font-secondary" not in theme
  set text(size: theme.font-size) if "font-size" in theme

  grid(
    // stroke: 0.1pt,
    rows: 10pt,
    columns: (auto, auto),
    gutter: 5%,
    {
      set align(center + horizon)
      gutter
      if icon-padding != none {
        v(icon-padding)
      }
    },
    {
      set align(start + horizon)
      right
    },
  )
}

#let language-entry(
  theme: (),
  language,
  level,
) = {
  set text(font: theme.font) if "font-secondary" in theme
  set text(font: default-theme.font-secondary) if "font-secondary" not in theme
  set text(size: theme.font-size) if "font-size" in theme

  stack(
    dir: ltr,
    language,
    {
      set align(end)
      level
    },
  )
}

#let work-entry(
  theme: (),
  timeframe: "",
  title: "",
  organization: "",
  location: "",
  description: "",
  remote: false,
) = {
  set text(size: theme.font-size) if "font-size" in theme

  if "space-above" not in theme {
    v(1fr)
  } else {
    v(theme.space-above)
  }
  {
    set text(font: theme.font-secondary) if "font-secondary" in theme
    set text(font: default-theme.font-secondary) if "font-secondary" not in theme
    set block(above: 0pt, below: 0pt)
    stack(
      dir: ttb,
      spacing: 5pt,
      stack(
        dir: ltr,
        spacing: 1fr,
        context {
          set text(weight: "light", fill: text.fill.lighten(30%))
          timeframe
        },
        context {
          set align(horizon)
          set text(weight: "light", fill: text.fill.lighten(30%))
          location
        },
      ),
      stack(
        dir: ltr,
        spacing: 1fr,
        {
          {
            set text(weight: "bold")
            upper(title)
          }
          " – "
          organization
        },
        context {
          set align(horizon)
          set text(weight: "light", style: "italic", fill: text.fill.lighten(30%))
          if remote { lower(translate("tags.remote")) } else { "" }
        },
      ),
      // {
      //   {
      //     set text(weight: "bold")
      //     upper(title)
      //   }
      //   " – "
      //   organization
      // },
    )
  }
  {
    set block(above: 6pt, below: 8pt)
    line(stroke: 0.1pt, length: 100%)
  }
  context {
    set text(fill: text.fill.lighten(30%))
    set par(leading: 1em)
    cmarker.render(description)
  }
}

#let education-entry(
  theme: (),
  timeframe: "",
  title: "",
  institution: "",
  location: "",
  description: "",
) = {
  set text(size: theme.font-size) if "font-size" in theme

  {
    set text(font: theme.font-secondary) if "font-secondary" in theme
    set text(font: default-theme.font-secondary) if "font-secondary" not in theme
    stack(
      spacing: 5pt,
      {
        set text(weight: "bold")
        upper(title)
      },
      stack(
        dir: ltr,
        spacing: 1fr,
        institution,
        context {
          set align(start)
          set text(weight: "light", fill: text.fill.lighten(30%))
          timeframe
        },
      ),
    )

    {
      set block(above: 6pt, below: 8pt)
      line(stroke: 0.1pt, length: 100%)
      // v(1pt)
    }
  }


  context {
    set text(font: theme.font) if "font" in theme
    description
  }
}

/// Create a dot rating component.
/// -> content
#let dot-ratings(
  /// Number of active dots to show
  /// -> int
  selected,
  /// Number of dots in total
  /// -> int
  total,
  /// Size of each dot (diameter)
  /// -> length
  size: 5pt,
  /// Spacing between dots
  /// -> length
  spacing: 6pt,
  /// Color of active dots
  /// -> color
  color-active: default-theme.text-color,
  /// Color of inactive dots
  /// -> color
  color-inactive: default-theme.text-color.lighten(75%),
  align: (left, right),
) = {
  let dots = ()

  for value in range(total) {
    let color = if value < selected { color-active } else { color-inactive }
    dots += (
      box(
        circle(
          radius: size / 2,
          fill: color,
        ),
      ),
    )
  }

  grid(
    columns: total,
    column-gutter: spacing,
    ..dots,
  )
}

#let tech-entry(
  theme: (),
  tech,
  rating,
  max-rating: 5,
) = {
  set text(font: theme.font) if "font-secondary" in theme
  set text(font: default-theme.font-secondary) if "font-secondary" not in theme
  set text(size: theme.font-size) if "font-size" in theme

  if max-rating == none {
    max-rating = 5
  }

  stack(
    dir: ltr,
    tech,
    {
      set align(end)
      dot-ratings(rating, max-rating)
    },
  )
}

#let sort-by-rating(input) = {
  return input.sorted(by: (a, b) => {
    if (a.rating == b.rating) {
      return a.name <= b.name
    }
    return a.rating >= b.rating
  })
}
