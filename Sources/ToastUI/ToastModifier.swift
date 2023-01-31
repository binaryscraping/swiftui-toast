import SwiftUI
import SwiftUINavigation

struct ToastModifier<Toast: View>: ViewModifier {
  @Binding var isPresented: Bool

  let duration: TimeInterval
  let tapToDismiss: Bool
  let alignment: Alignment
  let additionalOffset: CGSize

  @State private var offset: CGSize = .zero
  @State private var delta: CGFloat = 0

  private let maxDelta: CGFloat = 20

  @ViewBuilder var toast: Toast

  let onDismiss: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(main, alignment: alignment)
  }

  @ViewBuilder
  private var main: some View {
    Group {
      if isPresented {
        toast
          .transition(
            AnyTransition.move(edge: edge).combined(with: .opacity)
          )
          .animation(.spring().speed(1.5))
          .zIndex(1)
          .onTapGesture(perform: dismiss)
          .offset(offset)
      }
    }
    .task(id: isPresented) {
      if isPresented {
        try? await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(duration))
        dismiss()
      }
    }
  }

  private var edge: Edge {
    switch alignment {
    case .top:
      return .top

    case .topLeading, .leading, .bottomLeading:
      return .leading

    case .topTrailing, .trailing, .bottomTrailing:
      return .trailing

    case .bottom:
      return .bottom

    default:
      return .bottom
    }
  }

  private func dismiss() {
    withAnimation {
      isPresented = false
      offset = .zero
      onDismiss?()
    }
  }
}

extension View {
  public func toast(
    isPresented: Binding<Bool>,
    alignment: Alignment = ToastDefaults.alignment,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offset: CGSize = ToastDefaults.offset,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: () -> some View
  ) -> some View {
    modifier(
      ToastModifier(
        isPresented: isPresented,
        duration: duration,
        tapToDismiss: tapToDismiss,
        alignment: alignment,
        additionalOffset: offset,
        toast: content,
        onDismiss: onDismiss
      )
    )
  }

  public func toast<Item>(
    item: Binding<Item?>,
    alignment: Alignment = ToastDefaults.alignment,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offset: CGSize = ToastDefaults.offset,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: (Item) -> some View
  ) -> some View {
    toast(
      isPresented: item.isPresent(),
      alignment: alignment,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offset: offset,
      onDismiss: onDismiss
    ) {
      item.wrappedValue.map(content)
    }
  }

  public func toast<Value>(
    unwrapping value: Binding<Value?>,
    alignment: Alignment = ToastDefaults.alignment,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offset: CGSize = ToastDefaults.offset,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: (Binding<Value>) -> some View
  ) -> some View {
    toast(
      isPresented: value.isPresent(),
      alignment: alignment,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offset: offset,
      onDismiss: onDismiss
    ) {
      Binding(unwrapping: value).map(content)
    }
  }

  public func toast<Enum, Case>(
    unwrapping enum: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    alignment: Alignment = ToastDefaults.alignment,
    duration: TimeInterval = ToastDefaults.duration,
    tapToDismiss: Bool = ToastDefaults.tapToDismiss,
    offset: CGSize = ToastDefaults.offset,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: (Binding<Case>) -> some View
  ) -> some View {
    toast(
      unwrapping: `enum`.case(casePath),
      alignment: alignment,
      duration: duration,
      tapToDismiss: tapToDismiss,
      offset: offset,
      onDismiss: onDismiss,
      content: content
    )
  }
}
