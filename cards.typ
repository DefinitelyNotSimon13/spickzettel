// Card collection + rendering.

#let _cards = state("sixpages-cards", ())

#let card(
  cols: 1,
  rows: 1,
  body,
) = {
  _cards.update(old => (
    ..old,
    (
      kind: "card",
      colspan: cols,
      rowspan: rows,
      body: body,
    ),
  ))
}

#let grid-pagebreak() = {
  _cards.update(old => (..old, (kind: "break")))
}

#let reset-cards() = _cards.update(_ => ())

#let _debug-subcells(colspan: 1, rowspan: 1, stroke: 0.35pt + luma(170), size) = [
  #let debug-lines(colspan, rowspan, stroke: purple.opacify(50%) + .8pt) = {
    let cells = (..range(colspan * rowspan).map(_ => []),)

    let vlines = range(1, colspan).map(x => grid.vline(x: x, start: 0, end: rowspan, stroke: stroke))

    let hlines = range(1, rowspan).map(y => grid.hline(y: y, start: 0, end: colspan, stroke: stroke))

    grid(
      columns: (..range(colspan).map(_ => 1fr),),
      rows: (..range(rowspan).map(_ => 1fr),),
      gutter: 0pt,
      inset: 0pt,
      stroke: none, // important: we’ll draw lines explicitly
      ..cells,
      ..vlines,
      ..hlines,
    )
  }

  #place(top, clearance: 0pt, block(stroke: red + 0pt)[
    #debug-lines(colspan, rowspan)
  ])
]

#let _display-card(
  card,
  x: none,
  y: none,
  inset: 3pt,
  stroke: 0.8pt + luma(200),
  fill: luma(245),
) = grid.cell(
  ..(if x == none { () } else { (x: x) }),
  ..(if y == none { () } else { (y: y) }),
  colspan: card.colspan,
  rowspan: card.rowspan,
  breakable: false,
  inset: 0pt,
  stroke: stroke,
  fill: fill,
)[
  #show heading.where(level: 1): it => {
    text(
      weight: "bold",
      fill: orange.darken(20%),
      size: 10pt,
    )[#it.body \ ]
  }
  #show heading.where(level: 2): it => {
    text(
      weight: "bold",
      fill: blue.darken(30%),
      size: 8pt,
    )[#it.body \ ]
  }
  #show heading.where(level: 3): it => {
    text(
      weight: "semibold",
      fill: black.lighten(30%),
      size: 8pt,
    )[#it.body \ ]
  }

  #block(inset: inset, card.body)
]

#let _pack-cards(cards, cols, debug) = {
  let cells = ()
  let occupied = ()

  let new-row = () => (..range(cols).map(_ => false),)

  for card in cards {
    if card.colspan > cols {
      panic(
        "Card colspan " + str(card.colspan) + " exceeds total columns " + str(cols),
      )
    }

    let placed = false
    let y = 0

    while not placed {
      while occupied.len() < y + card.rowspan {
        occupied.push(new-row())
      }

      for x in range(0, cols - card.colspan + 1) {
        let free = true

        for yy in range(y, y + card.rowspan) {
          for xx in range(x, x + card.colspan) {
            if occupied.at(yy).at(xx) {
              free = false
              break
            }
          }
          if not free { break }
        }

        if free {
          for yy in range(y, y + card.rowspan) {
            for xx in range(x, x + card.colspan) {
              occupied.at(yy).at(xx) = true
            }
          }

          cells.push(_display-card(card, x: x, y: y))
          placed = true
          break
        }
      }

      if not placed { y += 1 }
    }
  }

  if debug {
    let debug_cells = ()
    for cell in cells {
      let colspan = cell.colspan
      let rowspan = cell.rowspan

      let size = measure(cell)

      let width_per_col = size.width / colspan
      let height_per_col = size.height / rowspan
      // panic("Width/col: " + repr(width_per_col) + " - Height/col: " + repr(height_per_col))
      //

      let new_cell = grid.cell(
        fill: cell.fill,
        x: cell.x,
        y: cell.y,
        colspan: cell.colspan,
        rowspan: cell.rowspan,
        inset: 0% + 0pt,
        stroke: 1pt + red.darken(30%),
        breakable: false,
        {
          cell.body
          _debug-subcells(colspan: cell.colspan, rowspan: cell.rowspan, measure(cell))
        },
      )
      debug_cells.push(new_cell)
    }
    return debug_cells
  }

  cells
}

#let render-cards(
  columns: 4,
  column-gutter: 1,
  row-gutter: 1,
  debug: false,
) = context {
  let pages = ()
  let current = ()

  for item in _cards.final() {
    if item.kind == "break" {
      if current.len() > 0 {
        pages.push(current)
        current = ()
      }
    } else {
      current.push(item)
    }
  }


  if current.len() > 0 {
    pages.push(current)
  }

  if pages.len() == 0 {
    return none
  }

  let render-page = cards => {
    grid(
      columns: (..range(columns).map(_ => 1fr),),
      column-gutter: column-gutter,
      row-gutter: row-gutter,
      .._pack-cards(cards, columns, debug)
    )
  }

  let out = ()
  for i in range(pages.len()) {
    if i != 0 { out.push(pagebreak()) }
    out.push(render-page(pages.at(i)))
  }

  for page in out {
    page
  }
}
