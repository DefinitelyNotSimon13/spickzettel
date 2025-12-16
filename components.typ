// Public small helpers.

// Public small helpers.

#let cols(sep: false, ..items) = {
  let cols = items
    .pos()
    .enumerate()
    .map(((i, it)) => {
      if sep == false or i == 0 {
        it
      } else {
        block(
          inset: (left: 2mm),
          width: 100%,
          height: 1fr,
          stroke: (left: 1pt + gray),
          align(top + left, it),
        )
      }
    })

  grid(
    gutter: 5pt,
    columns: items.pos().map(_ => 1fr),
    ..cols,
  )
}
