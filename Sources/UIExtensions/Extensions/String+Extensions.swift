// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import UIKit
extension String {
    /**
     The extension provides a convenient way to calculate the width of a given string when rendered with a specific font. This is particularly useful for dynamically sizing UI elements such as labels or text fields based on their content.

     To use this extension, simply call the `width(for:)` method on any string instance and pass in the desired font as an argument. The method will return the calculated width of the string as a `CGFloat` value.

     Example Usage:

         let myString = "Hello, World!"
         let myFont = UIFont.systemFont(ofSize: 18)
         let stringWidth = myString.width(for: myFont)
         print(stringWidth)

     This will output the calculated width of the string "Hello, World!" when rendered with the system font at size 18.

      - Parameter font: The font to be used for rendering the string.
      - Returns: The width of the string when rendered with the given font.
     */
   public func width(for font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

#elseif canImport(AppKit)
import AppKit

extension String {
    /**
     The extension provides a convenient way to calculate the width of a given string when rendered with a specific font. This is particularly useful for dynamically sizing UI elements such as labels or text fields based on their content.

     To use this extension, simply call the `width(for:)` method on any string instance and pass in the desired font as an argument. The method will return the calculated width of the string as a `CGFloat` value.

     Example Usage:

         let myString = "Hello, World!"
         let myFont = NSFont.systemFont(ofSize: 18)
         let stringWidth = myString.width(for: myFont)
         print(stringWidth)

     This will output the calculated width of the string "Hello, World!" when rendered with the system font at size 18.

      - Parameter font: The font to be used for rendering the string.
      - Returns: The width of the string when rendered with the given font.
     */
   public func width(for font: NSFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
#endif
