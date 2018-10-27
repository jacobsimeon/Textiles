# Textiles

Define your application's text styles in a single place, then re-use them
throughout.

# Usage

## Define some styles

```swift
// TextStyles.swift
class TextStyles {
  static func defineStyles() {

    Textile.define("Header") { style in
      style.fontSize = 32
      style.fontFamily = "Helvetica"
    }

    Textile.define("Body") { style in
      style.fontSize = 17
      style.fontFamily = "Georgia"
    }

  }
}

// AppDelegate.swift
func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  TextStyles.defineStyles()
  // ...
}
```

## Use the styles

```swift
// SomeViewController.swift
func addContent() {
  myHeaderLabel.attributedText = style("Lorem ipsum", as: "Header")
  myBodyLabel.attributedText = style("Dolor sit amet", as: "Body")
}
```

# Installation

Add this to your Cartfile:

```
github "jacobsimeon/Textiles"
```

Then run:
```
$ carthage update Textiles
```

