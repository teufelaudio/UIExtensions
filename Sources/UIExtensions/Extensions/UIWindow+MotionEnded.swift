// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import UIKit

extension NSNotification.Name {
    public static let didShakeDevice = NSNotification.Name("DidShakeDeviceNotification")
}

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        switch event?.subtype {
        case .motionShake:
            NotificationCenter.default.post(name: .didShakeDevice, object: event)
        default: break
        }
    }
}
#endif
