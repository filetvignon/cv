// #import "@preview/modernpro-cv:2.0.0": *
#import "package.typ": *
#import "../common.typ": *

#let profile = cv-data.profile
#let contact = (
  cv-data
    .contact
    .map(x => {
      let (type, ..rest) = x
      return (type, rest)
    })
    .to-dict()
)

#show heading: set block(breakable: false)
#let skills_translations = translate("skills")
#set page(header: none, footer: none)
#show regex("\$?C\s*\/\s*C\+\+\$?"): "C / C++"
#show regex("\$?HTML\s*\/\s*CSS\$?"): "HTML / CSS"
#show regex("\$?CI\s*\/\s*CD\$?"): "CI / CD"
#let layout = (
  preset: "relaxed",
  continue-header: false,
  list-spacing: 1em,
  // section-gap: 1.5em,
  section-content-gap: 1em,
  // entry-row-gap: 0.7em,
  // description-gap: 0.8em,
  header-content-gap: 1.4em,
  item-gap: 1.5em,
)

#show: cv.with(
  profile: (
    name: profile.first-name + " " + profile.last-name,
    role: profile.titles.join(", "),
    address: [#profile.location.city, #profile.location.country],
    contacts: (
      (text: contact.phone.display),
      (text: contact.email.display, link: contact.email.link),
      (text: contact.linkedin.display, link: contact.linkedin.link),
      (text: contact.github.display, link: contact.github.link),
    ),
  ),
  layout: layout,
  options: (
    last-updated: false,
    page-count: false,
    date: false,
  ),
)

#let sections = (
  section-block("about", title: headers.bio, separator: true, overrides: (rule-stroke: 0pt))[
    #summary[#profile.bio]
    #item-gap
  ],

  section-block("experience", title: headers.work-experiences)[
    // #block(breakable: false)[
    #for work in cv-data.work-experiences {
      block(breakable: false)[
        #experience(
          title: work.at("title", default: ""), // title
          organization: work.at("organization", default: ""), // company
          location: work.at("location", default: ""), // location
          date: work.timeframe,
          description: eval(work.description, mode: "markup"),
        )
      ]
    }
    // ]
  ],
  section-block("education", title: headers.education)[
    // #block(breakable: false)[
    #for item in cv-data.education {
      education(
        institution: item.at("institution", default: ""), // institution
        location: item.at("location", default: ""), // location
        major: item.at("title", default: ""), // degree
        date: item.timeframe,
        description: eval(item.description, mode: "markup"),
      )
    }
    // ]
  ],

  section-block("certifications", title: headers.certifications)[
    #for item in cv-data.certifications {
      education(
        institution: item.at("institution", default: ""), // institution
        location: item.at("location", default: ""), // location
        major: item.at("title", default: ""), // degree
        date: item.timeframe,
        description: eval(item.description, mode: "markup"),
      )
    }
  ],

  section-block("skills", title: headers.skills)[
    #for (key, value) in cv-data.skills {
      let skill = skills_translations.at(key, default: key)
      detail-line(
        title: skill,
        content: value.join(", "),
      )
    }
    #item-gap
  ],

  section-block("languages", title: headers.languages)[
    #for language in cv-data.languages {
      detail-line(
        title: language.name,
        content: language.level,
      )
    }
    #item-gap
  ],
)

#let section-order = ("about", "experience", "education", "certifications", "skills", "languages")

#render-sections(sections: sections, order: section-order)
