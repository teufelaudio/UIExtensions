// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import Foundation
import UIKit

@objc
public protocol ApplicationOpener {
    var openSettingsURL: String { get }
    func canOpenURL(_ url: URL) -> Bool
    @available(iOSApplicationExtension, unavailable)
    @objc(openURL:options:completionHandler:)
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)
}

@available(iOSApplicationExtension, unavailable)
extension UIApplication: ApplicationOpener {
    public var openSettingsURL: String {
        Self.openSettingsURLString
    }
}
#endif
