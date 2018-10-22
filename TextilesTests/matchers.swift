//
// Created by Jacob Morris on 3/18/18.
// Copyright (c) 2018 Jacob Morris. All rights reserved.
//

import UIKit
import Nimble
import Textiles

func haveBackgroundColor(_ expectedColor: UIColor) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expectedColor, forKey: .backgroundColor) { $0.attributes() }
}

func haveBaselineOffset(_ expected: CGFloat) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .baselineOffset) { $0.attributes() }
}

public func haveFont(_ expected: UIFont) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .font) { $0.attributes() }
}

public func haveFont(_ expected: UIFont, compatibleWith traitCollection: UITraitCollection) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .font) { $0.attributes(compatibleWith: traitCollection) }
}

public func haveForegroundColor(_ expected: UIColor) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .foregroundColor) { $0.attributes() }
}

public func haveKern(_ expected: CGFloat) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .kern) { $0.attributes() }
}

public func haveLigature(_ expected: Int) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .ligature) { $0.attributes() }
}

public func haveShadow(_ expected: NSShadow) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .shadow) { $0.attributes() }
}

public func haveStrikethroughColor(_ expected: UIColor) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .strikethroughColor) { $0.attributes() }
}

public func haveStrikethroughStyle(_ expected: NSUnderlineStyle) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .strikethroughStyle) { $0.attributes() }
}

public func haveStrokeColor(_ expected: UIColor) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .strokeColor) { $0.attributes() }
}

public func haveStrokeWidth(_ expected: CGFloat) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .strokeWidth) { $0.attributes() }
}

public func haveTextEffect(_ expected: NSAttributedString.TextEffectStyle) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .textEffect) { $0.attributes() }
}

public func haveUnderlineColor(_ expected: UIColor) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .underlineColor) { $0.attributes() }
}

public func haveUnderlineStyle(_ expected: NSUnderlineStyle) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .underlineStyle) { $0.attributes() }
}

public func haveParagraphStyle(_ expected: NSMutableParagraphStyle) -> Predicate<Textile> {
  return predicateToAssertTextile(has: expected, forKey: .paragraphStyle) { $0.attributes() }
}

func predicateToAssertTextile<T: Equatable>(
  has expectedAttributeValue: T,
  forKey attributeKey: NSAttributedStringKey,
  gettingAttributesVia getAttributes: @escaping (Textile) -> [NSAttributedStringKey: Any]
) -> Predicate<Textile> {
  return Predicate { textileExpression in
    guard let textile = try textileExpression.evaluate() else {
      return PredicateResult(status: .fail, message: ExpectationMessage.fail("Expected a textile but got nil"))
    }

    let attributes = getAttributes(textile)

    guard let maybeActualValue = attributes[attributeKey] else {
      return PredicateResult(
        status: .fail,
        message: ExpectationMessage.fail(
          "Expected \(textile) to have \(attributeKey.rawValue) \(expectedAttributeValue) but got nil instead"
        )
      )
    }

    guard let actualValue = maybeActualValue as? T else {
      return PredicateResult(
        status: .fail,
        message: ExpectationMessage.fail(
          "Expected \(textile) to have \(attributeKey.rawValue) \(expectedAttributeValue) but it wasn't a \(T.self)"
        )
      )
    }

    if actualValue == expectedAttributeValue {
      return PredicateResult(
        status: .matches,
        message: ExpectationMessage.fail("Expected \(textile) to not have \(attributeKey.rawValue) \(actualValue)")
      )
    }
    else {
      return PredicateResult(
        status: .doesNotMatch,
        message: ExpectationMessage.fail(
          "Expected \(textile) to have \(attributeKey.rawValue) \(expectedAttributeValue) but got \(actualValue)"
        )
      )
    }
  }
}
