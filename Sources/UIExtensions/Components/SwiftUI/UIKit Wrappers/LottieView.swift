//
//  LottieView.swift
//  UIExtensions
//
//  Created by Luiz Barbosa on 15.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Lottie) && canImport(UIKit)
import Foundation
import Lottie
import SwiftUI

public struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()
    let filename: String
    let bundle: Bundle
    let loopMode: LottieLoopMode
    let completion: LottieCompletionBlock?

    public init(filename: String, bundle: Bundle, loopMode: LottieLoopMode = .playOnce, completion: LottieCompletionBlock? = nil) {
        self.filename = filename
        self.bundle = bundle
        self.loopMode = loopMode
        self.completion = completion
    }

    public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animation = Animation.named(filename, bundle: bundle)
        animationView.animation = animation
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        if context.environment.disableAnimations {
            animationView.currentProgress = 0.5
        } else {
            animationView.play(completion: completion)
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }

    public func updateUIView(_ uiView: LottieView.UIViewType, context: UIViewRepresentableContext<LottieView>) {
    }
}
#endif
