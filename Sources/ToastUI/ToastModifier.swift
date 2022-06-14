import SwiftUI
import SwiftUINavigation

public enum ToastPosition {
  case top, bottom
}

struct ToastModifier<Toast: View>: ViewModifier {
  @Binding var isPresented: Bool
  let duration: TimeInterval
  let tapToDismiss: Bool
  let position: ToastPosition
  var offsetY: CGFloat
  @ViewBuilder var toast: Toast
  let completion: (() -> Void)?

  func body(content: Content) -> some View {
    ZStack {
      content

      main
        .offset(y: offsetY)
        .animation(.spring(), value: isPresented)
    }
  }

  @ViewBuilder
  private var main: some View {
    if isPresented {
      VStack(spacing: 0) {
        if position == .bottom {
          Spacer()
        }
        toast
        if position == .top {
          Spacer()
        }
      }
      .task { @MainActor in
        try? await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(duration))
        withAnimation(.spring()) {
          isPresented = false
        }
      }
      .onDisappear { completion?() }
      .transition(
        .move(edge: position == .top ? .top : .bottom)
          .combined(with: .opacity)
      )
    }
  }
}

extension View {
  public func toast<Toast: View>(
    isPresented: Binding<Bool>,
    position: ToastPosition = ToastDefaults.position,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offsetY: CGFloat = ToastDefaults.offsetY,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: () -> Toast
  ) -> some View {
    modifier(
      ToastModifier(
        isPresented: isPresented,
        duration: duration,
        tapToDismiss: tapToDismiss,
        position: position,
        offsetY: offsetY,
        toast: content,
        completion: onDismiss
      )
    )
  }

  public func toast<Item, Toast: View>(
    item: Binding<Item?>,
    position: ToastPosition = ToastDefaults.position,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offsetY: CGFloat = ToastDefaults.offsetY,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: (Item) -> Toast
  ) -> some View {
    self.toast(
      isPresented: item.isPresent(),
      position: position,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offsetY: offsetY,
      onDismiss: onDismiss
    ) {
      item.wrappedValue.map(content)
    }
  }

  public func toast<Value, Toast: View>(
    unwrapping value: Binding<Value?>,
    position: ToastPosition = ToastDefaults.position,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offsetY: CGFloat = ToastDefaults.offsetY,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: (Binding<Value>) -> Toast
  ) -> some View {
    self.toast(
      isPresented: value.isPresent(),
      position: position,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offsetY: offsetY,
      onDismiss: onDismiss
    ) {
      Binding(unwrapping: value).map(content)
    }
  }

  public func toast<Enum, Case, Toast: View>(
    unwrapping enum: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    position: ToastPosition = ToastDefaults.position,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offsetY: CGFloat = ToastDefaults.offsetY,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: (Binding<Case>) -> Toast
  ) -> some View {
    self.toast(
      unwrapping: `enum`.case(casePath),
      position: position,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offsetY: offsetY,
      onDismiss: onDismiss,
      content: content
    )
  }
}
