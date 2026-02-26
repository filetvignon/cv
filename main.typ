#import "./package.typ": *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/to-stuff:0.5.1" as to

#let headers = translate("headers")

#let data-file = "data/" + lang + ".yaml"
#let cv-data = yaml(data-file)

#let profile = cv-data.profile

#set document(
  title: profile.at("first-name", default: "") + " " + profile.at("last-name", default: ""),
  description: "Curriculum Vitae of "
    + profile.at("first-name", default: "")
    + " "
    + profile.at("last-name", default: ""),
)

#set text(lang: lang)

// To learn about theming, see https://github.com/tsnobip/typst-typographic-resume?tab=readme-ov-file#theme
// make sure you have installed the fonts you want to use
#show: resume.with(
  theme: (
    // margin: 26pt,
    // font: "Libre Baskerville",
    // font-size: 8pt,
    // font-secondary: "Roboto",
    // font-tertiary: "Montserrat",
    // text-color: rgb("#3f454d"),
    // gutter-size: 4em,
    // main-width: 6fr,
    // aside-width: 3fr,
    // profile-picture-width: 55%,
  ),
  first-name: profile.at("first-name", default: ""),
  last-name: profile.at("last-name", default: ""),
  titles: profile.at("titles", default: ()),
  bio: profile.at("bio", default: ""),
  profile-picture: image(profile.at("pfp", default: "./images/pfp.jpeg")), // provide a profile picture here
  aside: {
    section(
      headers.contact,
      for contact in profile.contact {
        let icon-args = contact.at("icon-args", default: (:))
        if "size" in icon-args {
          icon-args.size = to.length(icon-args.size)
        }
        contact-entry(
          fa-icon(
            contact.at("icon", default: "link"),
            ..icon-args,
          ),
          link(contact.link, contact.display),
          icon-padding: if "icon-padding" in contact { to.length(contact.icon-padding) } else { 2pt },
        )
      },
    )

    if "tech-stack" in cv-data {
      section(
        headers.tech-stack,
        for tech in cv-data.tech-stack {
          tech-entry(tech.name, tech.rating)
        },
      )
    }

    if "languages" in cv-data {
      section(
        headers.languages,
        for language in cv-data.languages {
          language-entry(language.name, language.level)
        },
      )
    }

    if "interests" in cv-data {
      section(
        headers.interests,
        {
          set text(size: 7pt)
          stack(
            spacing: 8pt,
            ..cv-data.interests,
          )
        },
      )
    }
  },
)

#section(
  theme: (
    space-above: 0pt,
  ),
  headers.work-experiences,
  {
    let i = 0
    for work in cv-data.work-experiences {
      i = i + 1
      let theme = if i == 1 {
        (
          space-above: 0pt,
        )
      } else {
        ()
      }
      work-entry(
        theme: theme,
        ..work,
      )
    }
  },
)

#section(
  headers.education,
  grid(
    columns: 2,
    column-gutter: default-theme.margin,
    ..cv-data.education.map(edu => {
      education-entry(
        ..edu,
      )
    }),
  ),
)
