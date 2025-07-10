// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

#if os(iOS)
import SnapshotTesting
import UIKit

extension UITraitCollection {
    public static func iPhone16ProMax(_ orientation: ViewImageConfig.Orientation) -> UITraitCollection { iPhone13ProMax(orientation)
    }

    public static let iPadMini6thGen = iPadMini
    public static let iPadMini6thGenCompactSplitView = iPadMini_Compact_SplitView
}
#endif
