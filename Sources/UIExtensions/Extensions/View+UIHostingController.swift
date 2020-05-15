//
//  File.swift
//  
//
//  Created by Luis Reisewitz on 15.05.20.
//

#if canImport(UIKit)
extension View {
    /// Returns an `UIHostingController` with this view set as rootView.
    public var hosted: UIHostingController<Self> {
        return UIHostingController(rootView: self)
    }
}
#endif

