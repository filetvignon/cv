// #import "@preview/basic-resume:0.2.9": *
#import "package.typ": *
#import "../common.typ": *


// Put your personal information here, replacing mine
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


#show: resume.with(
  author: profile.first-name + " " + profile.last-name,
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
  location: [#profile.location.city, #profile.location.country],
  email: contact.email.display,
  github: contact.github.display,
  linkedin: contact.linkedin.display,
  phone: contact.phone.display,
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

// PDF metadata (defined in common.typ). Applied after resume.with(),
// which sets its own document title.
#set document(..doc-meta)
#set text(lang: lang)

/*
 * Lines that start with == are formatted into section headings
 * You can use the specific formatting functions if needed
 * The following formatting functions are listed below
 * #edu(dates: "", degree: "", gpa: "", institution: "", location: "", consistent: false)
 * #work(company: "", dates: "", location: "", title: "")
 * #project(dates: "", name: "", role: "", url: "")
 * certificates(name: "", issuer: "", url: "", date: "")
 * #extracurriculars(activity: "", dates: "")
 * There are also the following generic functions that don't apply any formatting
 * #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
 * #generic-one-by-two(left: "", right: "")
 */

== #headers.bio
#profile.bio


== #headers.work-experiences

#for exp in cv-data.work-experiences {
  block(breakable: false)[
    #work(
      title: exp.at("title", default: ""), // title
      company: exp.at("organization", default: ""), // company
      location: exp.at("location", default: ""), // location
      dates: display-timeframe(
        start-date: exp.at("start-date", default: none),
        end-date: exp.at("end-date", default: none),
        pattern: "MMM yyyy",
      ),
    )
    #eval(exp.description, mode: "markup")
  ]
}

#block(breakable: false)[
  == #headers.education

  #for education in cv-data.education {
    edu(
      institution: education.at("institution", default: ""), // institution
      location: education.at("location", default: ""), // location
      degree: education.at("title", default: ""), // degree
      dates: dates-helper(
        start-date: display-datetime(education.at("start-date", default: ""), pattern: "MMM yyyy"),
        end-date: display-datetime(education.at("end-date", default: ""), pattern: "MMM yyyy"),
      ),
    )
    eval(education.description, mode: "markup")
  }
]


#if cv-data.at("certifications", default: ()).len() > 0 [
== #headers.certifications
]

#for cert in cv-data.certifications {
  block(breakable: false)[
    #edu(
      institution: cert.at("institution", default: ""), // institution
      location: cert.at("location", default: ""), // location
      degree: cert.at("title", default: ""), // degree
      dates: dates-helper(
        start-date: display-datetime(cert.at("start-date", default: ""), pattern: "MMM yyyy"),
        end-date: display-datetime(cert.at("end-date", default: ""), pattern: "MMM yyyy"),
      ),
    )
    #eval(cert.description, mode: "markup")
  ]
}


== #headers.skills

#for (skill-tag, skills) in cv-data.skills {
  let skill = skills_translations.at(skill-tag, default: skill-tag)
  let values = skills.join(", ")
  [
    - *#skill*: #values
  ]
  v(1em, weak: true)
}

== #headers.languages

#for language in cv-data.languages {
  [
    - *#language.name*: #language.level
  ]
  v(1em, weak: true)
}
