#import "@preview/modernpro-cv:1.3.0": *
#import "@preview/fontawesome:0.6.0": *
#import "../common.typ": *
#import "@preview/cmarker:0.1.8"

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

#show: cv-single.with(
  font-type: "PT Serif",
  continue-header: "false",
  margin: (left: 1.75cm, right: 1.75cm, top: 2cm, bottom: 2cm),
  name: profile.first-name + " " + profile.last-name,
  address: [#profile.location.city, #profile.location.country],
  lastupdated: "false",
  pagecount: "true",
  // date: "2024-07-03",
  contacts: (
    (text: [#contact.phone.display]),
    (text: [#contact.email.display], link: contact.email.link),
    (text: [#contact.linkedin.display], link: contact.linkedin.link),
    (text: [#contact.github.display], link: contact.github.link),
  ),
)

#let sections = (
  section-block("about", title: headers.bio)[
    #descript[#profile.bio]
  ],
  section-block("experience", title: headers.work-experiences)[
    #for work in cv-data.work-experiences {
      block(breakable: false)[
        #job(
          position: work.at("title", default: ""), // title
          institution: work.at("organization", default: ""), // company
          location: work.at("location", default: ""), // location
          date: work.timeframe,
          description: cmarker.render(work.description),
        )]
    }
  ],
  section-block("education", title: headers.education)[
    #for item in cv-data.education {
      education(
        institution: item.at("institution", default: ""), // institution
        location: item.at("location", default: ""), // location
        major: item.at("title", default: ""), // degree
        date: item.timeframe,
        description: cmarker.render(item.description),
      )
    }
  ],

  section-block("skills", title: headers.skills)[
    #for (key, value) in cv-data.skills {
      let skill = skills_translations.at(key, default: key)
      oneline-title-item(
        title: skill,
        content: value.join(", "),
      )
    }
  ],

  section-block("languages", title: headers.languages)[
    #for language in cv-data.languages {
      oneline-title-item(
        title: language.name,
        content: language.level,
      )
    }
  ],
)

#let section-order = ("about", "experience", "education", "skills", "languages")

#render-sections(sections: sections, order: section-order)
