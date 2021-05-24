import UIKit

public enum Slant: CGFloat {
    case none = 0.0
    case italic = 1.0
}

public class Textile {
    public var fontFamily: String?
    public var fontFace: String?
    public var fontSize: CGFloat?
    public var fontWeight: UIFont.Weight?
    public var fontSlant: Slant?
    public var fontWidth: CGFloat?

    public var scalingStyle: UIFontTextStyle?

    public var backgroundColor: UIColor?

    public var baselineOffset: CGFloat?

    public var foregroundColor: UIColor?

    public var kern: CGFloat?

    public var ligature: Ligature?

    public var shadowOffset: CGSize?
    public var shadowBlurRadius: CGFloat?
    public var shadowColor: UIColor?

    public var strikethroughColor: UIColor?
    public var strikethroughStyle: NSUnderlineStyle?

    public var strokeColor: UIColor?
    public var strokeWidth: CGFloat?

    public var textEffect: NSAttributedString.TextEffectStyle?

    public var underlineStyle: NSUnderlineStyle?
    public var underlineColor: UIColor?

    public init(_ configure: (Textile) -> Void) {
        configure(self)
    }

    private var paragraphStyle: NSMutableParagraphStyle?
    public func paragraph(_ paragraphConfig: (NSMutableParagraphStyle) -> Void) {
        paragraphStyle = paragraphStyle ?? NSMutableParagraphStyle()
        paragraphConfig(paragraphStyle!)
    }

    public func attributes(
        compatibleWith traitCollection: UITraitCollection = UIScreen.main.traitCollection
    ) -> [NSAttributedStringKey: Any] {
        var fontAttributes: [UIFontDescriptor.AttributeName: Any] = [:]
        fontAttributes[.family] = fontFamily
        fontAttributes[.face] = fontFace
        fontAttributes[.size] = fontSize

        var fontTraits: [UIFontDescriptor.TraitKey: Any] = [:]
        fontTraits[.weight] = fontWeight
        fontTraits[.slant] = fontSlant?.rawValue
        fontTraits[.width] = fontWidth

        fontAttributes[.traits] = fontTraits
        let descriptor = UIFontDescriptor(fontAttributes: fontAttributes)

        let font: UIFont = {
            let baseFont = UIFont(descriptor: descriptor, size: fontSize ?? UIFont.systemFontSize)
            guard let scalingStyle = scalingStyle else {
                return baseFont
            }

            return scalingStyle.metrics.scaledFont(for: baseFont, compatibleWith: traitCollection)
        }()

        var finalAttributes: [NSAttributedStringKey: Any] = [.font: font]

        if let backgroundColor = backgroundColor {
            finalAttributes[.backgroundColor] = backgroundColor
        }

        if let baselineOffset = baselineOffset {
            finalAttributes[.baselineOffset] = baselineOffset
        }

        if let foregroundColor = foregroundColor {
            finalAttributes[.foregroundColor] = foregroundColor
        }

        if let kern = kern {
            finalAttributes[.kern] = kern
        }

        if let lig = ligature {
            finalAttributes[.ligature] = lig.rawValue
        }

        if let shadow = buildShadow() {
            finalAttributes[.shadow] = shadow
        }

        if let strikethroughColor = strikethroughColor {
            finalAttributes[.strikethroughColor] = strikethroughColor
        }

        if let strikethroughStyle = strikethroughStyle {
            finalAttributes[.strikethroughStyle] = strikethroughStyle
        }

        if let strokeColor = strokeColor {
            finalAttributes[.strokeColor] = strokeColor
        }

        if let strokeWidth = strokeWidth {
            finalAttributes[.strokeWidth] = strokeWidth
        }

        if let textEffect = textEffect {
            finalAttributes[.textEffect] = textEffect
        }

        if let underlineColor = underlineColor {
            finalAttributes[.underlineColor] = underlineColor
        }

        if let underlineStyle = underlineStyle {
            finalAttributes[.underlineStyle] = underlineStyle
        }

        if let paragraphStyle = paragraphStyle {
            finalAttributes[.paragraphStyle] = paragraphStyle
        }

        return finalAttributes
    }

    private func buildShadow() -> NSShadow? {
        var shadow: NSShadow?
        if let shadowOffset = shadowOffset {
            shadow = shadow ?? NSShadow()
            shadow?.shadowOffset = shadowOffset
        }

        if let shadowColor = shadowColor {
            shadow = shadow ?? NSShadow()
            shadow?.shadowColor = shadowColor
        }

        if let shadowBlurRadius = shadowBlurRadius {
            shadow = shadow ?? NSShadow()
            shadow?.shadowBlurRadius = shadowBlurRadius
        }

        return shadow
    }
}

extension Textile {
    private static var styles: [String: Textile] = [:]

    public static func define(_ identifier: String, config: (Textile) -> ()) {
        let textile = Textile(config)
        styles[identifier] = textile
    }

    public static func get(_ identifier: String) -> Textile? {
        return styles[identifier]
    }

    public static func clear() {
        styles = [:]
    }
}

public func style(
    _ string: String, as identifier: String
) -> NSAttributedString {
    let textile = Textile.get(identifier)
    let attributes = textile?.attributes() ?? [:]

    return NSAttributedString(string: string, attributes: attributes)
}
