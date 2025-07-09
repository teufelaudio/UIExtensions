// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

#if os(iOS)
import SnapshotTesting
import UIKit

extension ViewImageConfig {
    public static let iPhoneSE3rdGen = ViewImageConfig.iPhoneSE3rdGen(.portrait)

    public static func iPhoneSE3rdGen(_ orientation: Orientation) -> ViewImageConfig {
      .iPhone8(orientation)
    }

    public static let iPhone16ProMax = ViewImageConfig.iPhone16ProMax(.portrait)

    public static func iPhone16ProMax(_ orientation: Orientation) -> ViewImageConfig {
      let safeArea: UIEdgeInsets
      let size: CGSize
        switch orientation {
        case .landscape:
            safeArea = .init(top: 0, left: 62, bottom: 21, right: 62)
            size = .init(width: 956, height: 440)
        case .portrait:
            safeArea = .init(top: 62, left: 0, bottom: 34, right: 0)
            size = .init(width: 440, height: 956)
        }
      return .init(safeArea: safeArea, size: size, traits: .iPhone16ProMax(orientation))
    }

    public static let iPadMini6thGen = ViewImageConfig.iPadMini6thGen(.landscape)

    public static func iPadMini6thGen(_ orientation: Orientation) -> ViewImageConfig {
      switch orientation {
      case .landscape:
        return ViewImageConfig.iPadMini6thGen(.landscape(splitView: .full))
      case .portrait:
        return ViewImageConfig.iPadMini6thGen(.portrait(splitView: .full))
      }
    }

    public static func iPadMini6thGen(_ orientation: TabletOrientation) -> ViewImageConfig {
      let size: CGSize
      let traits: UITraitCollection
      switch orientation {
      case .landscape(let splitView):
        switch splitView {
        case .oneThird:
          size = .init(width: 320, height: 744)
          traits = .iPadMini6thGenCompactSplitView
        case .oneHalf:
          size = .init(width: 566, height: 744)
          traits = .iPadMini6thGenCompactSplitView
        case .twoThirds:
          size = .init(width: 755, height: 744)
          traits = .iPadMini6thGen
        case .full:
          size = .init(width: 1133, height: 744)
          traits = .iPadMini6thGen
        }
      case .portrait(let splitView):
        switch splitView {
        case .oneThird:
          size = .init(width: 320, height: 1133)
          traits = .iPadMini6thGenCompactSplitView
        case .twoThirds:
          size = .init(width: 496, height: 1133)
          traits = .iPadMini6thGenCompactSplitView
        case .full:
          size = .init(width: 744, height: 1133)
          traits = .iPadMini6thGen
        }
      }
      return .init(
        safeArea: .init(top: 24, left: 0, bottom: 20, right: 0), size: size, traits: traits)
    }
}
#endif
