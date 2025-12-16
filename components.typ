// Public small helpers.

// Public small helpers.

#let cols(sep: false, ..items, columns: none) = {
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
          stroke: (left: 1pt + gray),
          it,
        )
      }
    })

  grid(
    gutter: 5pt,
    columns: if columns == none { items.pos().map(_ => 1fr) } else { columns },
    ..cols,
  )
}
