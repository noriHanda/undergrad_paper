#let titleL = 1.8em
#let titleM = 1.6em
#let titleS = 1.2em
#let university = "北海道大学"
#let fontSerif = ("Noto Serif", "Noto Serif CJK JP")
#let fontSan = ("Noto Sans", "Noto Sans CJK JP")
#let bibliographyTitleJa = "参考文献"

#let project(title: "", englishTitle: "", author: "", university: university, affiliation: "", lab: "", grade: "", supervisor: none, year: none, body) = {
  set document(author: author, title: title)

  // Font
  set text(font: fontSerif, lang: "ja", size: 12pt)

  // Heading
  set heading(numbering: (..nums) => {
    if nums.pos().len() > 1 {
      nums.pos().map(str).join(".") + " "
    } else {
      text(cjk-latin-spacing: none)[第 #str(nums.pos().first()) 章]
      h(1em)
    }
  })
  show heading: set text(font: fontSan, weight: "medium", lang: "ja")
  show heading.where(level: 1): it => {
    pagebreak()
    set text(size: 1.4em)
    pad(top: 3em, bottom: 2.5em)[
      #it
    ]
  }
  show heading.where(level: 2): it => pad(top: 1em, bottom: 0.6em, it)

  // Figure
  show figure: it => pad(y: 1em, it)
  show figure.caption: it => pad(top: 0.6em, it)

  // Outline
  show outline.entry: set text(font: fontSan, lang: "ja")
  show outline.entry.where(
    level: 1
  ): it => {
    v(0.2em)
    set text(weight: "semibold")
    it
  }

  align(center)[
    #v(6em)
    
    #block(text(titleS)[#year 年度 卒業論文])
    #v(8em)
    #block(text(titleL, title))
    #v(2em)
    #pad(x: 4em, block(text(titleS, englishTitle)))

    #v(8em)

    // Author information.
    #block(text(titleS)[#university])
    #block(text(titleS)[#affiliation])
    #block(text(titleS)[#lab  #grade])
    #v(2em)
    #block(text(titleS)[#author])
    #if supervisor != none [
      #v(0.6em)
      #block(text(titleS)[指導教員 #supervisor])
    ]
  ]

  pagebreak(weak: true)

  set par(justify: true, first-line-indent: 1pt, leading: 1em)
  body
}

#let abstract(body) = {
  v(180pt)
  
  align(center)[
    #text(font: fontSan, size: titleM, tracking: 2em, weight: "medium")[要旨]
  ]

  v(2em)

  set par(first-line-indent: 1em)
  body
  pagebreak(weak: true)
}