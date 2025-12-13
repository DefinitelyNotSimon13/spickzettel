// Card collection + rendering.

#let _cards = state("sixpages-cards", ())

#let card(
  cols: 1,
  rows: 1,
  body,
) = {
  _cards.update(old => (..old, (colspan: cols, rowspan: rows, body: body)))
}

#let reset-cards() = _cards.update(_ => ())

#let _display-card(card, inset: 3pt, stroke: 0.8pt, fill: luma(245)) = grid.cell(
  colspan: card.colspan,
  rowspan: card.rowspan,
  breakable: false,
  inset: inset,
  stroke: stroke,
  fill: fill,
)[
  #show heading.where(level: 1): it => {
    text(
      weight: "bold",
      fill: orange.darken(20%),
      size: 12pt,
    )[#it.body \ ]
  }
  #show heading.where(level: 2): it => {
    text(
      weight: "bold",
      fill: blue.darken(30%),
      size: 10pt,
    )[#it.body \ ]
  }

  #card.body
]

#let _pack-cards(cards, cols) = {
  let cells = ()
  let curr = 0

  for card in cards {
    if card.colspan > cols {
      panic(
        "Card colspan " + str(card.colspan) + " exceeds total columns " + str(cols),
      )
    }

    if curr + card.colspan > cols {
      let remaining = cols - curr
      if remaining != 0 {
        cells.push(grid.cell(colspan: remaining)[])
      }
      curr = 0
    }

    cells.push(_display-card(card))
    curr += card.colspan
  }

  cells
}

#let render-cards(
  columns: 4,
  column-gutter: 1,
  row-gutter: 1,
) = context {
  grid(
    columns: (..range(columns).map(_ => 1fr),),
    column-gutter: column-gutter,
    row-gutter: row-gutter,
    .._pack-cards(_cards.final(), columns),
  )
}
