// "clean" template: single column, ATS-friendly, one page.
// Reads everything from data/*.yaml through common.typ, like the other templates.
//
// ATS notes:
// - single column, no tables/icons/images, real text in reading order
// - keyword spellings are kept exactly as written in the YAML (no "CI / CD" rewriting)
// - hyphenated terms like "third-party" never break across lines (a break makes parsers read "thirdparty")
// - fonts are bundled in /fonts (passed by compile.sh) so the layout is identical on every machine

#import "../common.typ": *

#let accent = rgb("#1f3a5f")
#let muted = rgb("#5f6b7a")

#let profile = cv-data.profile
#let tags = translate("tags")

// PDF metadata (defined in common.typ)
#set document(..doc-meta)
#set text(lang: lang)

#set page(paper: paper, margin: (x: 1.3cm, top: 1cm, bottom: 0.9cm))
#set text(font: ("Inter", "Verdana", "DejaVu Sans"), size: 10pt)
#set par(leading: 0.45em, justify: false)
// Lines inside a bullet sit closer together than separate bullets
#set list(indent: 0.6em, body-indent: 0.5em, spacing: 0.65em)
#show "third-party": it => box(it)

#let section(title) = {
  v(0.5em)
  text(size: 10.5pt, weight: "bold", fill: accent, tracking: 0.08em, upper(title))
  v(-0.55em)
  line(length: 100%, stroke: 0.6pt + accent.lighten(60%))
  v(0.15em)
}

#let dated-line(left, dates) = grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  left, text(fill: muted, size: 9pt, dates),
)

#let timeframe(item) = display-timeframe(
  start-date: item.at("start-date", default: none),
  end-date: item.at("end-date", default: none),
  pattern: "MMM yyyy",
)

#let markup(s) = if s == none or s.trim() == "" { none } else { eval(s, mode: "markup") }

// ---------- Header ----------
#text(size: 20pt, weight: "bold", fill: accent)[#profile.first-name #profile.last-name]
#v(-0.6em)
#text(size: 11pt, weight: "bold", profile.at("headline", default: profile.titles.join(", ")))
#v(-0.4em)
#{
  let preferred = ("phone", "email", "linkedin", "github", "personal-site")
  let contacts = cv-data
    .contact
    .filter(c => not c.at("hidden", default: false))
    .sorted(key: c => {
      let i = preferred.position(t => t == c.type)
      if i == none { preferred.len() } else { i }
    })
  let loc = profile.location
  let parts = (text(fill: muted)[#loc.city, #loc.country],)
  parts += contacts.map(c => link(c.link, c.display))
  parts.join(" | ")
}

// ---------- Summary ----------
#section(headers.bio)
#profile.bio

// ---------- Experience ----------
#section(headers.work-experiences)
#for item in cv-data.work-experiences {
  v(0.3em)
  dated-line(text(weight: "bold", item.title), timeframe(item))
  v(-0.35em)
  let org = item.organization
  if "client" in item { org += " (" + tags.client + ": " + item.client + ")" }
  let place = item.at("location", default: "")
  if item.at("remote", default: false) { place += " (" + lower(tags.remote) + ")" }
  [#org#text(fill: muted)[, #place]]
  v(-0.2em)
  markup(item.at("description", default: ""))
}

// ---------- Skills ----------
#section(headers.skills)
#{
  set par(leading: 0.5em)
  let lines = ()
  for (key, values) in cv-data.skills {
    lines.push([*#skills_translations.at(key, default: key):* #values.join(", ")])
  }
  if "languages" in cv-data {
    let spoken = cv-data.languages.map(l => l.name + " (" + lower(l.level) + ")").join(", ")
    lines.push([*#skills_translations.at("spoken-languages"):* #spoken])
  }
  lines.join(linebreak())
}

// ---------- Education ----------
#section(headers.education)
// Compact entries, with a little more room between schools than within one
#{
  set block(spacing: 0.65em)
  v(0.3em)
  for (i, item) in cv-data.education.enumerate() {
    if i > 0 { v(0.3em) }
    dated-line([*#item.institution* – #item.title], timeframe(item))
    markup(item.at("description", default: ""))
  }
}

// ---------- Certifications (only if any) ----------
#if cv-data.at("certifications", default: ()).len() > 0 {
  section(headers.certifications)
  for item in cv-data.certifications {
    dated-line([*#item.institution* – #item.title], timeframe(item))
  }
}
