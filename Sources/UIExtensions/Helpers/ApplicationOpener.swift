// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import Foundation
import UIKit

@MainActor
public protocol ApplicationOpener {
    nonisolated var openSettingsURL: String { get }
    nonisolated func canOpenURL(_ url: URL) -> Bool
    @available(iOSApplicationExtension, unavailable)
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?)
    @available(iOSApplicationExtension, unavailable)
    @discardableResult
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool
}

@available(iOSApplicationExtension, unavailable)
extension UIApplication: ApplicationOpener {
    nonisolated public var openSettingsURL: String {
        Self.openSettingsURLString
    }
}
#endif
