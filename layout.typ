#import "./cards.typ": render-cards, reset-cards

#let spickzettel(
  columns: 4,
  margin: (
    bottom: 8mm,
    rest: 2mm,
  ),
  font: "Carlito",
  font-size: 9pt,
  footer-left: [9553391],
  body,
) = {
  reset-cards()

  let footer = block[
    #grid(columns: 2)[
      #footer-left
      #h(1fr)
      S.#context here().page()
    ]
  ]

  set page(
    paper: "a4",
    margin: margin,
    footer: footer,
  )

  set text(
    font: font,
    size: font-size,
  )

  set list(marker: ("–", "·"))

  show heading: set block(below: 0pt, above: 0pt)
  show grid: set block(below: 8pt, above: 8pt)

  body
  render-cards(columns: columns)
}
