//
//  AttributedText.swift
//  UIExtensions
//
//  Created by Luiz Barbosa on 25.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

public struct AttributedText: UIViewRepresentable {
    private let attributedString: NSAttributedString
    private let onTapLink: (URL) -> Void

    public init(_ string: String, attributes: [NSAttributedString.Key: Any]? = nil, onTapLink: @escaping (URL) -> Void) {
        self.attributedString = .init(string: string, attributes: attributes)
        self.onTapLink = onTapLink
    }

    public init(attributed: NSAttributedString, onTapLink: @escaping (URL) -> Void) {
        self.attributedString = attributed
        self.onTapLink = onTapLink
    }

    public func makeUIView(context: UIViewRepresentableContext<AttributedText>) -> UIAttributedLabel {
        UIAttributedLabel(onTapLink: onTapLink)
    }

    public func updateUIView(_ uiView: UIAttributedLabel, context: UIViewRepresentableContext<AttributedText>) {
        uiView.text = attributedString
    }
}

public class UIAttributedLabel: UIView {
    private let label: UILabel
    private let onTapLink: (URL) -> Void

    init(onTapLink: @escaping (URL) -> Void) {
        label = .init(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        self.onTapLink = onTapLink

        super.init(frame: .zero)

        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        label.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
            let url = label.url(at: sender.location(in: label)) else { return }

        onTapLink(url)
    }

    var text: NSAttributedString? {
        get {
            label.attributedText
        }
        set {
            label.attributedText = newValue
        }
    }
}

extension UILabel {

    private var alignmentOffset: CGFloat {
        switch textAlignment {
        case .left, .natural, .justified:
            return 0.0
        case .center:
            return 0.5
        case .right:
            return 1.0
        @unknown default:
            fatalError()
        }
    }

    func url(at point: CGPoint) -> URL? {
        guard let attributedText = self.attributedText, let font = self.font else {
            assert(self.attributedText != nil, "This method is developed for attributed string")
            return nil
        }

        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedText.length))
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        layoutManager.addTextContainer(textContainer)

        // get the tapped character location
        let locationOfTouchInLabel = point
        // account for text alignment and insets
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let xOffset = ((bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)

        // figure out which character was tapped
        let characterTapped = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                           in: textContainer,
                                                           fractionOfDistanceBetweenInsertionPoints: nil)

        // figure out how many characters are in the string up to and including the line tapped
        let lineTapped = Int(ceil(locationOfTouchInLabel.y / font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: bounds.size.width, y: font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped,
                                                             in: textContainer,
                                                             fractionOfDistanceBetweenInsertionPoints: nil)

        // ignore taps past the end of the current line
        if characterTapped < charsInLineTapped {
            return attributedText
                .attributes(at: characterTapped, effectiveRange: nil)
                .first { key, _ in
                    key == NSAttributedString.Key.link || key == NSAttributedString.Key.attachment
                }
                .flatMap { _, value in
                    (value as? String).flatMap(URL.init(string:)) ?? value as? URL
                }
        } else {
            return nil
        }
    }
}
#endif
