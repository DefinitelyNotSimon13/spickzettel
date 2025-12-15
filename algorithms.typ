#let lined(body) = block(
  above: 5.2pt,
  below: 5.2pt,
  inset: (left: 2mm),
  stroke: (left: 1pt + gray),
)[
  #body
]

#let lined_n(body, level: 1) = {
  if level <= 1 {
    lined(body)
  } else {
    lined(lined_n(body, level: level - 1))
  }
}

#let normalize_item(it) = {
  if type(it) == dictionary {
    (
      content: it.content,
      level: if "level" in it { it.level } else { 1 },
      kind: if "kind" in it { it.kind } else { "default" },
    )
  } else {
    (content: it, level: 1, kind: "default")
  }
}

#let items_at_level(items, level) = items.filter(it => it.level == level)

#let max_level(items) = {
  let max = 1
  for item in items {
    if item.level > max { max = item.level }
  }
  return max
}

#let render_item(it) = {
  if it.kind == "heading" { [*#it.content*] } else { [#it.content] }
}


#let render_ordered(items) = {
  let xs = items.map(normalize_item)

  let rec(i, level) = {
    if i >= xs.len() { (out: [], i: i) } else {
      let it = xs.at(i)

      if it.level < level {
        (out: [], i: i)
      } else if it.level == level {
        let next = rec(i + 1, level)
        (out: [#render_item(it) \ #next.out], i: next.i)
      } else {
        let inner = rec(i, level + 1)
        let after = rec(inner.i, level)
        (out: [#lined[ #inner.out ] #after.out], i: after.i)
      }
    }
  }

  lined[ #rec(0, 1).out ]
}

#let algorithm_part(
  part: "title",
  items: ([Item One], (content: [Item Two], level: 2)),
  numbered: false,
) = {
  let norm_items = items.map(normalize_item)
  set grid(align: (x, y) => {
    if x == 0 {
      right
    } else {
      auto
    }
  })
  grid(
    inset: 1pt,
    columns: (10pt, auto),
    [
      \
      #if numbered {
        let offset = 0
        for (i, item) in norm_items.enumerate() {
          if item.kind == "heading" or item.kind == "second_line" {
            offset += 1
            [ \ ]
          } else {
            [#(i + 1 - offset) \ ]
          }
        }
      }
    ],
    [
      *#part:*
      #render_ordered(norm_items)
    ],
  )
}
