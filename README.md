# Spickzettel

A small Typst package + template to generate compact study sheets with a grid of cards.

## Public API

- `six_pages(..)` - page setup + renders collected cards at the end
- `card(..)[..]` - register a card
- `grid-pagebreak()` - start a new card grid on the next page
- `cols(..)` - 1fr columns helper for content inside a card

## Multi-page card grids

If you want to split your cards across multiple pages, insert `grid-pagebreak()`.

```typst
#import "spickzettel/lib.typ": *

#show: spickzettel

#card(cols: 2, rows: 1)[First page]

#grid-pagebreak()

#card(cols: 2, rows: 1)[Second page]
```
