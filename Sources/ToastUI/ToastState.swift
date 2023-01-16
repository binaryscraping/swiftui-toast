import _SwiftUINavigationState
import CasePaths
import SwiftUI
import SwiftUINavigation

public struct ToastState: Identifiable {
  public let id = UUID()

  let style: ToastView.Style
  let icon: ImageState?
  let title: TextState
  let subtitle: TextState?

  public init(
    style: ToastView.Style = .regular,
    icon: ImageState? = nil,
    title: TextState,
    subtitle: TextState? = nil
  ) {
    self.style = style
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
  }
}

extension ToastState: Equatable {
  public static func == (lhs: ToastState, rhs: ToastState) -> Bool {
    lhs.style == rhs.style &&
    lhs.icon == rhs.icon &&
    lhs.title == rhs.title &&
    lhs.subtitle == rhs.subtitle
  }
}

extension ToastState: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(style)
    hasher.combine(icon)
    hasher.combine(title)
    hasher.combine(subtitle)
  }
}

extension View {
  public func toast(
    unwrapping value: Binding<ToastState?>,
    position: ToastPosition = ToastDefaults.position,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offsetY: CGFloat = ToastDefaults.offsetY,
    onDismiss: (() -> Void)? = nil
  ) -> some View {
    toast(
      unwrapping: value,
      position: position,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offsetY: offsetY,
      onDismiss: onDismiss
    ) { $state in
      ToastView(state)
    }
  }
}
