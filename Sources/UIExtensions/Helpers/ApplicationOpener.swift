//
//  ApplicationOpener.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 06.12.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

public protocol ApplicationOpener {
    static var openSettingsURLString: String { get }
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)
}

extension ApplicationOpener {
    public var openSettingsURLString: String {
        return Self.openSettingsURLString
    }
}

extension UIApplication: ApplicationOpener {
}
#endif
