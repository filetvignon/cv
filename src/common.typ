#import "@preview/datify:1.0.0": custom-date-format
#import "@preview/to-stuff:0.5.1" as to

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


#let translations-file = "../i18n/" + lang + ".yaml"
#let translations = yaml(translations-file)


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

#let headers = translate("headers")

#let data-dir = "../data/"
#let lang-data = yaml(data-dir + lang + ".yaml")
#let common-data = yaml(data-dir + "common.yaml")
#let cv-data = (:..common-data, ..lang-data)

#set text(lang: lang)
#set document(
  title: cv-data.profile.at("first-name", default: "") + " " + cv-data.profile.at("last-name", default: ""),
  description: "Curriculum Vitae of "
    + cv-data.profile.at("first-name", default: "")
    + " "
    + cv-data.profile.at("last-name", default: ""),
)


#let to-datetime(date) = {
  if type(date) == datetime {
    return date
  }

  if type(date) == dictionary {
    let year = to.int(date.at("year", default: none))
    if (year == none) {
      return panic("Missing 'year' in date dictionary: " + date)
    }
    let month = to.int(date.at("month", default: 1))
    let day = to.int(date.at("day", default: 1))
    return datetime(year: year, month: month, day: day)
  }

  if type(date) == str {
    let parts = date.split("-")
    if parts.len() != 3 {
      return panic("Invalid date format: " + date + ". Expected format: YYYY-MM-DD")
    }
    let year = to.int(parts.at(0, default: none))
    let month = to.int(parts.at(1, default: "1"))
    let day = to.int(parts.at(2, default: "1"))
    return datetime(year: year, month: month, day: day)
  }

  panic("Invalid date type: " + type(date) + ". Expected types: datetime, dictionary, or string")
}
