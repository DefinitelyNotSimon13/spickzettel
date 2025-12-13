// Spickzettel template: a full page of study cards.
//
// If you installed this package locally:
//   typst init @local/sixpages:0.1.0 my-sheet
//
// If you are using a published version later:
//   typst init @preview/sixpages:0.1.0 my-sheet

#import "CHANGE_ME": *

#show: six_pages.with(
  columns: 4,
  footer-left: [STUDENT NUMBER/ID)],
)

// Tip: Put any header content here (title, course, date).
#align(center)[
  = Study Sheet
  #text(size: 10pt, fill: luma(80))[Course · Topic · Date]
]

#v(6pt)

// A full page worth of cards.
#for i in range(1, 17) {
  card[
    = Card #i
    #cols(
      [
        == Key idea
        - #lorem(12)
        - #lorem(8)
      ],
      [
        == Example
        #lorem(22)
      ],
    )
  ]
}
