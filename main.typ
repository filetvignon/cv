#import "./package.typ": *
#import "@preview/fontawesome:0.6.0": *

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
  first-name: "Felipe",
  last-name: "Vignon",
  profession: "Software Engineer",
  bio: [
    Experienced software engineer with a passion for developing innovative programs that expedite the efficiency and effectiveness of organizational success.],
  profile-picture: image("./images/profile_pic_example.jpg"), // provide a profile picture here
  aside: {
    section(
      "Contact",
      {
        set image(width: 8pt)
        contact-entry(
          fa-icon("github"),
          link("https://github.com/filetvignon/", "filetvignon"),
        )
        // line(stroke: 0.1pt, length: 100%)
        contact-entry(
          fa-icon("phone"),
          link("tel:+5511971354176", "+55 11 971354176"),
        )
        // line(stroke: 0.1pt, length: 100%)
        contact-entry(
          fa-icon("envelope", solid: true),
          link("mailto:felipe.vignon@example.com", "felipe.vignon@example.com"),
        )
      },
    )


    section(
      "Tech Stack",
      {
        tech-entry("Node.js/Javascript", 5)
        tech-entry("Python", 3)
        tech-entry("React", 3)
        tech-entry("ReScript", 5)
        tech-entry("ReScript", 5)
        tech-entry("ReScript", 5)
        tech-entry("ReScript", 5)
      },
    )

    section(
      "Languages",
      {
        language-entry("Portuguese", "Native")
        language-entry("English", "Fluent")
        language-entry("Spanish", "Intermediate")
        language-entry("French", "Basic")
      },
    )

    section(
      "Interests",
      {
        set text(size: 7pt)
        stack(
          spacing: 8pt,
          "Open Source Contributions",
          "Road biking",
          "Traveling",
        )
      },
    )
  },
)


#section(
  theme: (
    space-above: 0pt,
  ),
  "Work Experiences",
  {
    work-entry(
      theme: (
        space-above: 0pt,
      ),
      timeframe: "Jan 2024 - Today",
      title: "Senior Software Engineer",
      organization: "Tech Innovators Inc.",
      location: "Lyon, FR",
      [
        Led a team of developers to design and implement scalable web applications.
        Improved system performance by 30% through code optimization.
        Mentored junior developers, fostering a culture of continuous learning.
        Spearheaded the migration of legacy systems to modern cloud-based infrastructure.
      ],
    )
    work-entry(
      timeframe: "Oct 2020 - December 2023",
      title: "Software Engineer",
      organization: "CodeCraft Solutions",
      location: "San Francisco, USA",
      [
        Developed and maintained RESTful APIs for client applications.
        Collaborated with cross-functional teams to deliver high-quality software.
        Implemented CI/CD pipelines, reducing deployment times by 40%.
        Conducted code reviews to ensure adherence to best practices and coding standards.
      ],
    )
    work-entry(
      timeframe: "Jul 2019 - Oct 2020",
      title: "Junior Software Engineer",
      organization: "NextGen Tech",
      location: "Tbilisi, GE",
      [
        Assisted in the development of e-commerce platforms.
        Wrote unit tests to ensure code reliability and maintainability.
        Participated in agile ceremonies, contributing to sprint planning and retrospectives.
        Researched and implemented new tools to improve development workflows.
      ],
    )
    work-entry(
      timeframe: "Nov 2018 - Jun 2019",
      title: "Intern",
      organization: "Startup Hub",
      location: "Paris, FR",
      [
        Supported the development team in debugging and testing applications.
        Gained hands-on experience with modern web technologies.
        Created technical documentation for internal tools and processes.
        Assisted in the deployment of a new customer-facing web application.
      ],
    )
    work-entry(
      timeframe: "Jun 2017 - Oct 2018",
      title: "Freelance Developer",
      organization: "Self-Employed",
      location: "Remote",
      [
        Designed and developed custom websites for small businesses.
        Provided technical support and maintenance for client projects.
        Built responsive and user-friendly interfaces using modern web technologies.
        Managed multiple projects simultaneously, ensuring timely delivery.
      ],
    )
    work-entry(
      timeframe: "Jan 2016 - May 2017",
      title: "Research Assistant",
      organization: "École des Mines de St-Étienne",
      location: "St-Étienne, France",
      [
        Conducted research on algorithms for optimizing large-scale systems.
        Published findings in peer-reviewed journals and presented at conferences.
        Developed prototypes to validate research concepts.
        Collaborated with a multidisciplinary team to achieve project goals.
      ],
    )
  },
)

#section(
  "Education",
  grid(
    columns: 2,
    column-gutter: default-theme.margin,
    education-entry(
      title: "MSc in Computer Science",
      institution: "École des Mines de St-Étienne, FR",
      timeframe: "2014 - 2017",
      [Focused on software engineering, algorithms, and data structures.],
    ),
    education-entry(
      title: "PhD in Artificial Intelligence",
      institution: "Seoul National University, KR",
      timeframe: "2017 - 2021",
      [Specialized in machine learning and natural language processing.],
    ),
  ),
)
