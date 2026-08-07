#import "./package.typ": *
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

// Put your personal information here
#let name = profile.at("first-name", default: "") + " " + profile.at("last-name", default: "")
#let phone = contact.phone.at("handle", default: "")
#let email = contact.email.at("handle", default: "")
#let github = contact.github.at("handle", default: "")
#let linkedin = contact.linkedin.at("handle", default: "")
#let personal-site = contact.at("personal-site", default: ("handle": "")).at("handle", default: "")

// Since the following arguments are within the `with` block,
// you can remove/comment any argument to fallback to the preset value and/or
// remove it.
#show: resume.with(
  top-margin: 0.45in,
  font: "New Computer Modern",
  personal-info-font-size: 9.2pt,
  author-position: center,
  personal-info-position: center,
  author-name: name,
  phone: phone,
  email: email,
  website: personal-site,
  linkedin-user-id: linkedin,
  github-username: github,
  lang: lang,
)

// Use custom-title function instead of first-level headings to customize the
// size between two sections by specifying the `spacingBetween` argument.
// https://typst.app/docs/reference/layout/length/

#custom-title(headers.education)[
  #for education in cv-data.education {
    education-heading(
      education.at("institution", default: ""), // institution
      education.at("location", default: ""), // location
      education.at("title", default: ""), // degree
      none,
      to-datetime(education.at("start-date", default: none)), // start-date
      if "end-date" in education {
        to-datetime(education.at("end-date"))
      } else {
        translate("tags.present")
      }, // end-date
      cmarker.render(education.description),
    )
  }

]

#custom-title(headers.work-experiences)[
  #for work in cv-data.work-experiences {
    work-heading(
      work.at("title", default: ""), // title
      work.at("organization", default: ""), // company
      work.at("location", default: ""), // location
      to-datetime(work.at("start-date", default: "")), // start-date
      if "end-date" in work {
        to-datetime(work.at("end-date"))
      } else {
        translate("tags.present")
      }, // end-date
      cmarker.render(work.description),
    )
  }
  // #work-heading(
  //   "Regional Manager", // title
  //   "Dunder Mifflin", // company
  //   "Scranton, PA", // location
  //   datetime(year: 2013, month: 5, day: 1), // start-date
  //   "Present", // end-date
  // )[
  //   - Led a team of 10+ employees, boosting office productivity and morale
  //   - Maintained the highest sales average, outperforming competitors despite market challenges
  //   - Implemented innovative security measures to protect the office from threats, including criminal activity and wildlife intrusions
  //   - Successfully negotiated client contracts, increasing annual revenue by 20%
  // ]
  // More experiences ...
]

// #custom-title("Projects")[
//   #project-heading(
//     "Schrute Farms (Bed and Breakfast)", // name
//     // "Next.js, TailwindCSS, Postgres",      // stack
//     // "schrutefarms.com"                     // project_url
//   )[
//     - Established and managed a family-run agro-tourism business offering unique activities such as table-making workshops, beet farming tours, and hay rides
//     - Increased guest bookings by 50% through effective online marketing and guest engagement
//     - Maintained a 4.9/5 guest satisfaction rating on travel review platforms
//   ]
//   // More projects ...
// ]

// Use `skills` function to create list with custom rules surrounding indentation and alignment.
// It is specifically for lists directly inside the custom-title section.
#let skills_translations = translate("skills")
#custom-title(headers.skills)[
  #skills(for (key, value) in cv-data.skills {
    let skill = skills_translations.at(key, default: key)
    [*#skill*] + ": " + [#value.join(", ")]
    linebreak()
  })
]

#custom-title(headers.languages)[
  #skills(for language in cv-data.languages {
    [*#language.name*] + ": " + [#language.level]
    linebreak()
  })
]
