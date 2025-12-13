// Public small helpers.

#let cols(..items) = grid(
  columns: items.pos().map(_ => 1fr),
  ..items,
)
