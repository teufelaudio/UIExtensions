// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI
import SwiftUINavigation

extension View {
    /// Returns an `AnyView` wrapping this view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Small Helper Extensions
extension View {
    public func squared(length: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: length, height: length, alignment: alignment)
    }

    /// Dumps the content (using `Swift.dump()` of `t` when evaluating this View.
    /// Especially useful for monitoring animated values during transitions.
    ///
    /// - Parameter t: Value to dump. Can be a variable, or a binding, or anything.
    /// - Returns: The unmodified receiving view.
    public func dump<T>(_ t: @autoclosure () -> T) -> Self {
        Swift.dump(t())
        return self
    }
}

// MARK: - If
extension View {
    /// Conditionally applies a transformation to the receiving view.
    /// - Parameters:
    ///   - condition: Condition to evaluate. It's evaluated lazily. If condition evaluates to `true`, `transform` is applied.
    ///   - transform: Transformation to apply to the `View`. This can be used ot apply ViewModifiers or similar.
    /// - Returns: The same view, either unchanged or with transformation applied.
    ///
    /// Inspiration taken from <https://fivestars.blog/swiftui/conditional-modifiers.html>
    @ViewBuilder
    public func `if`<Transform: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Transform) -> some View {
        if (condition()) {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - If Let
extension View {
    /// Conditionally applies a transformation to the receiving view.
    /// - Parameters:
    ///   - condition: Condition to evaluate. It's evaluated lazily. If condition evaluates to `true`, `transform` is applied.
    ///   - transform: Transformation to apply to the `View`. This can be used ot apply ViewModifiers or similar.
    /// - Returns: The same view, either unchanged or with transformation applied.
    ///
    /// Inspiration taken from <https://fivestars.blog/swiftui/conditional-modifiers.html>
    @ViewBuilder
    public func `ifLet`<Transform: View, T>(_ optional: @autoclosure () -> T?, transform: (Self, T) -> Transform) -> some View {
        if let value = optional() {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK: - Navigation
extension View {
    @available(iOS, introduced: 15)
    @available(macOS, introduced: 12)
    @ViewBuilder
    /// Associates a destination view with a binding that can be used to push the view onto an `UIExtensions.NavigationStack`.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether destination is currently presented.
    ///   - onNavigate: A closure that executes when the link becomes active or inactive with a
    ///     boolean that describes if the link was activated or not.
    ///   - destination: A view to present.
    public func navigationDestination<WrappedDestination: View>(
        isPresented: Binding<Bool>,
        // Don't provide default value to distinguish it from SwiftUI's native modifier.
        onNavigate: @escaping (_ isActive: Bool) -> Void,
        @ViewBuilder destination: @escaping () -> WrappedDestination
    ) -> some View {
        if #available(iOS 16, macOS 13, *) {
            self.modifier(
                _NavigationDestination(
                    isPresented: isPresented,
                    onNavigate: onNavigate,
                    destination: destination()
                )
            )
        } else {
            self.modifier(
                _ProgrammaticNavigationLink(
                    unwrapping: Binding(get: { return isPresented.wrappedValue ? true : nil },
                                        set: {
                                            guard $0 != nil else {
                                                isPresented.wrappedValue = false
                                                return
                                            }
                                            isPresented.wrappedValue = true
                                        }),
                    onNavigate: onNavigate,
                    destination: { _ in destination() }
                )
            )
        }
    }

    /// Pushes a view onto an `UIExtensions.NavigationStack` using a binding as a data source for the
    /// destination's content.
    ///
    /// This is a version of SwiftUI's `navigationDestination(isPresented:)` modifier, but powered
    /// by a binding to optional state instead of a binding to a boolean. When state becomes
    /// non-`nil`, a _binding_ to the unwrapped value is passed to the destination closure.
    ///
    /// ```swift
    /// struct TimelineView: View {
    ///   @State var draft: Post?
    ///
    ///   var body: Body {
    ///     Button("Compose") {
    ///       self.draft = Post()
    ///     }
    ///     .navigationDestination(unwrapping: self.$draft) { $draft in
    ///       ComposeView(post: $draft, onSubmit: { ... })
    ///     }
    ///   }
    /// }
    ///
    /// struct ComposeView: View {
    ///   @Binding var post: Post
    ///   var body: some View { ... }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: A binding to an optional source of truth for the destination. When `value` is
    ///     non-`nil`, a non-optional binding to the value is passed to the `destination` closure.
    ///     You use this binding to produce content that the system pushes to the user in a
    ///     navigation stack. Changes made to the destination's binding will be reflected back in
    ///     the source of truth. Likewise, changes to `value` are instantly reflected in the
    ///     destination. If `value` becomes `nil`, the destination is popped.
    ///   - onNavigate: A closure that executes when the link becomes active or inactive with a
    ///     boolean that describes if the link was activated or not. Use this closure to populate the
    ///     source of truth when it is passed a value of `true`. When passed `false`, the system will
    ///     automatically write `nil` to `value`.
    ///   - destination: A closure returning the content of the destination.
    @available(iOS, introduced: 15)
    @available(macOS, introduced: 12)
    @ViewBuilder
    public func navigationDestination<Value, WrappedDestination: View>(
        unwrapping value: Binding<Value?>,
        onNavigate: @escaping (_ isActive: Bool) -> Void = { _ in },
        @ViewBuilder destination: @escaping (Binding<Value>) -> WrappedDestination
    ) -> some View {
        if #available(iOS 16, macOS 13, *) {
            self.modifier(
                _NavigationDestination(
                    isPresented: value.isPresent(),
                    onNavigate: onNavigate,
                    destination: Binding(unwrapping: value).map(destination)
                )
            )
        } else {
            self.modifier(
                _ProgrammaticNavigationLink(
                    unwrapping: value,
                    onNavigate: onNavigate,
                    destination: destination
                )
            )
        }
    }

    /// Pushes a view onto an `UIExtensions.NavigationStack` using a binding and case path as a data source for
    /// the destination's content.
    ///
    /// A version of `View.navigationDestination(unwrapping:)` that works with enum state.
    ///
    /// - Parameters:
    ///   - enum: A binding to an optional enum that holds the source of truth for the destination
    ///     at a particular case. When `enum` is non-`nil`, and `casePath` successfully extracts a
    ///     value, a non-optional binding to the value is passed to the `content` closure. You use
    ///     this binding to produce content that the system pushes to the user in a navigation
    ///     stack. Changes made to the destination's binding will be reflected back in the source of
    ///     truth. Likewise, changes to `enum` at the given case are instantly reflected in the
    ///     destination. If `enum` becomes `nil`, or becomes a case other than the one identified by
    ///     `casePath`, the destination is popped.
    ///   - casePath: A case path that identifies a case of `enum` that holds a source of truth for
    ///     the destination.
    ///   - onNavigate: A closure that executes when the link becomes active or inactive with a
    ///     boolean that describes if the link was activated or not. Use this closure to populate the
    ///     source of truth when it is passed a value of `true`. When passed `false`, the system will
    ///     automatically write `nil` to `enum`.
    ///   - destination: A closure returning the content of the destination.
    @available(iOS, introduced: 15)
    @available(macOS, introduced: 12)
    public func navigationDestination<Enum, Case, WrappedDestination: View>(
        unwrapping enum: Binding<Enum?>,
        case casePath: CasePath<Enum, Case>,
        onNavigate: @escaping (Bool) -> Void = { _ in },
        @ViewBuilder destination: @escaping (Binding<Case>) -> WrappedDestination
    ) -> some View {
        self.navigationDestination(
            unwrapping: `enum`.case(casePath),
            onNavigate: onNavigate,
            destination: destination
        )
    }
}

// MARK: View Modifier
@available(iOS, introduced: 15, deprecated: 16)
@available(macOS, introduced: 12, deprecated: 13)
fileprivate struct _ProgrammaticNavigationLink<Value, WrappedDestination: View>: ViewModifier {
    private let value: Binding<Value?>
    private let onNavigate: (Bool) -> Void
    private let destination: (Binding<Value>) -> WrappedDestination
    @State private var isActive: Bool

    init(unwrapping value: Binding<Value?>,
         onNavigate: @escaping (Bool) -> Void,
         @ViewBuilder destination: @escaping (Binding<Value>) -> WrappedDestination) {
        self.value = value
        self.onNavigate = onNavigate
        self.destination = destination
        self._isActive = .init(initialValue: value.wrappedValue != nil)
    }

    func body(content: Content) -> some View {
        content
            .background {
                // NavigationLink `isActive` is not working properly for the
                // programmatic navigation. https://github.com/pointfreeco/swiftui-navigation/issues/72
                NavigationLink(destination: Binding(unwrapping: value).map(destination),
                               isActive: $isActive,
                               label: {})
                #if os(iOS)
                .isDetailLink(false)
                #endif
                .disabled(true)
                .buttonStyle(PlainButtonStyle())
                .hidden()
                .accessibilityHidden(true)
            }
            // `.onChange` modifiers used to sync `isActive`, `value`, `onNavigate`.
            .onChange(of: value.wrappedValue == nil ? false : true) { value in
                isActive = value
            }
            .onChange(of: isActive) { newState in
                if !newState { value.wrappedValue = nil }
                onNavigate(newState)
            }
    }
}

@available(iOS 16, macOS 13, *)
fileprivate struct _NavigationDestination<Destination: View>: ViewModifier {
    @Binding var isPresented: Bool
    let onNavigate: (Bool) -> Void
    let destination: Destination
    @State private var isPresentedState = false

    func body(content: Content) -> some View {
        content
            .navigationDestination(isPresented: self.$isPresentedState) { self.destination }
            .bind(self.$isPresented, to: self.$isPresentedState)
            .onChange(of: isPresentedState, perform: onNavigate)
    }
}
