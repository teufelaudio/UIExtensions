// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import SwiftUI
import UIKit

extension View {
    /// Returns an `UIHostingController` with this view set as rootView.
    public var hosted: UIHostingController<Self> {
        return UIHostingController(rootView: self)
    }
}
#endif

