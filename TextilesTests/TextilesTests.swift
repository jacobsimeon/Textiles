//
//  TextilesTests.swift
//  TextilesTests
//
//  Created by Jacob Morris on 3/11/18.
//  Copyright © 2018 Jacob Morris. All rights reserved.
//

import Textiles
import Quick
import Nimble
import UIKit

class TextilesSpec: QuickSpec {
  override func spec() {
    beforeEach {
      Textile.clear()
    }

    describe("Defining a style") {
      it("supports font family") {
        let textile = Textile { style in
          style.fontFamily = "Avenir"
        }

        let avenir = UIFont(name: "Avenir", size: UIFont.systemFontSize)!

        expect(textile).to(haveFont(avenir))
      }

      it("supports font face") {
        let textile = Textile { style in
          style.fontFamily = "Avenir"
          style.fontFace = "Black"
        }

        let avenir = UIFont(name: "Avenir-Black", size: UIFont.systemFontSize)!

        expect(textile).to(haveFont(avenir))
      }

      it("supports font weight and slant") {
        let textile = Textile { style in
          style.fontFamily = "Avenir"
          style.fontWeight = .black
          style.fontSlant = .italic
        }

        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: UIFont.Weight.black, .slant: 1.0]
        let avenir = UIFont(
          descriptor: UIFontDescriptor(fontAttributes: [.family: "Avenir", .traits: traits]),
          size: UIFont.systemFontSize
        )

        expect(textile).to(haveFont(avenir))
      }

      it("supports font width") {
        let textile = Textile { style in
          style.fontFamily = "American Typewriter"
          style.fontWidth = -1.0
        }

        let typewriterCondensed = UIFont(name: "AmericanTypewriter-Condensed", size: UIFont.systemFontSize)!

        expect(textile).to(haveFont(typewriterCondensed))
      }

      it("supports font size") {
        let textile = Textile { style in
          style.fontFamily = "Avenir"
          style.fontSize = 17.0
        }

        let avenir = UIFont(name: "Avenir", size: 17.0)!

        expect(textile).to(haveFont(avenir))
      }

      it("supports scaling a font") {
        let textile = Textile { style in
          style.fontSize = 17.0
          style.fontFamily = "Avenir"
          style.scalingStyle = .headline
        }

        // A headline scaled from 17p to "extraExtraExtraLarge" will be 22p
        let avenir = UIFont(name: "Avenir", size: 22.0)!

        let extraExtraExtraLarge = UITraitCollection(preferredContentSizeCategory: .extraExtraExtraLarge)
        expect(textile).to(haveFont(avenir, compatibleWith: extraExtraExtraLarge))
      }

      it("supports background color") {
        let textile = Textile { style in
          style.backgroundColor = UIColor.red
        }

        expect(textile).to(haveBackgroundColor(UIColor.red))
      }

      it("supports baseline offset") {
        let textile = Textile { style in
          style.baselineOffset = 17.0
        }

        expect(textile).to(haveBaselineOffset(17.0))
      }

      it("supports foregroundColor") {
        let textile = Textile { style in
          style.foregroundColor = .blue
        }

        expect(textile).to(haveForegroundColor(.blue))
      }

      it("supports kern") {
        let textile = Textile { style in
          style.kern = 1.75
        }

        expect(textile).to(haveKern(1.75))
      }

      it("supports ligature") {
        let textile = Textile { style in
          style.ligature = .noLigature
        }

        expect(textile).to(haveLigature(0))
      }

      it("supports shadow") {
        let textile = Textile { style in
          style.shadowOffset = CGSize(width: 1.1, height: 1.1)
          style.shadowBlurRadius = 1.25
          style.shadowColor = .black
        }

        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 1.1, height: 1.1)
        shadow.shadowBlurRadius = 1.25
        shadow.shadowColor = UIColor.black
        expect(textile).to(haveShadow(shadow))
      }

      it("supports strikethrough color & style") {
        let textile = Textile { style in
          style.strikethroughColor = .red
          style.strikethroughStyle = .patternSolid
        }

        expect(textile).to(haveStrikethroughColor(.red))
        expect(textile).to(haveStrikethroughStyle(.patternSolid))
      }

      it("supports stroke color & width") {
        let textile = Textile { style in
          style.strokeColor = .purple
          style.strokeWidth = 7.25
        }

        expect(textile).to(haveStrokeColor(.purple))
        expect(textile).to(haveStrokeWidth(7.25))
      }

      it("supports textEffect") {
        let textile = Textile { style in
          style.textEffect = .letterpressStyle
        }

        expect(textile).to(haveTextEffect(.letterpressStyle))
      }

      it("supports underline color & style") {
        let textile = Textile { style in
          style.underlineStyle = .patternSolid
          style.underlineColor = .green
        }

        expect(textile).to(haveUnderlineStyle(.patternSolid))
        expect(textile).to(haveUnderlineColor(.green))
      }

      it("supports firstLineHeadIndent of the paragraph style") {
        let textile = Textile { style in
          style.paragraph() { p in
            p.alignment = .center
            p.firstLineHeadIndent = 5.1
            p.headIndent = 6.1
          }

          style.paragraph() { p in
            p.headIndent = 7.1
          }
        }

        let pstyle = NSMutableParagraphStyle()
        pstyle.firstLineHeadIndent = 5.1
        pstyle.headIndent = 7.1
        pstyle.alignment = .center

        expect(textile).to(haveParagraphStyle(pstyle))
      }
    }

    describe("Fetching a style") {
      it("can be fetched by identifier") {
        Textile.define("Header 1") { style in
          style.fontSize = 32.0
          style.fontFamily = "Avenir"
        }

        Textile.define("Header 2") { style in
          style.fontSize = 24.0
          style.fontFamily = "Avenir"
        }

        let expectedFont = UIFont(name: "Avenir", size: 32.0)!
        expect(Textile.get("Header 1")).to(haveFont(expectedFont))
      }
    }

    describe("Using a style for a string") {
      it("applies the identified style to the given string") {
        Textile.define("Header 1") { style in
          style.fontSize = 32.0
          style.fontFamily = "Avenir"
        }

        let attributedGreeting = style("hello world", as: "Header 1")
        let attributes = attributedGreeting.attributes(at: 0, effectiveRange: nil)
        let actualFont = attributes[.font] as? UIFont

        let expectedFont = UIFont(name: "Avenir", size: 32.0)
        expect(actualFont).to(equal(expectedFont))
      }
    }
  }
}
