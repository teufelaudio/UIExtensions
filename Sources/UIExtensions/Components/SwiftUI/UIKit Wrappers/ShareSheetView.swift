//
//  ShareSheetView.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 08.12.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

public struct ShareSheetView: UIViewControllerRepresentable {
    public let activityItems: [Any]
    public let applicationActivities: [UIActivity]?
    @Environment(\.presentationMode) var presentationMode

    public init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheetView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.presentationMode.wrappedValue.dismiss()
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheetView>) {
    }
}

extension View {
    public func shareSheet(
        isPresented: Binding<Bool>,
        activityItems: [Any] = [],
        applicationActivities: [UIActivity]? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        sheet(isPresented: isPresented, onDismiss: onDismiss) {
            ShareSheetView(activityItems: activityItems, applicationActivities: applicationActivities)
        }
    }

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func sharePopover(
        isPresented: Binding<Bool>,
        activityItems: [Any] = [],
        applicationActivities: [UIActivity]? = nil,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top
    ) -> some View {
        popover(isPresented: isPresented, attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge) {
            ShareSheetView(activityItems: activityItems, applicationActivities: applicationActivities)
        }
    }
}
#endif
