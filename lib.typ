#import "./components.typ": cols
#import "./cards.typ": card, grid-pagebreak
#import "./layout.typ": spickzettel
#import "./algorithms.typ": algorithm_part

#let formula(eq) = {
  set text(size: 12pt)
  align(center, pad(left: 5pt, right: 5pt, top: 4pt, bottom: 4pt)[#eq])
}

#let argmin = math.op("argmin", limits: true)
#let argmax = math.op("argmax", limits: true)

// Public API.
// - `six_pages`: show rule / wrapper for your sheet
// - `card`: register a card (rendered at the end)
// - `grid-pagebreak`: start a new card grid on the next page
// - `cols`: convenience 1fr grid for side-by-side content inside cards

