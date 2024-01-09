import SwiftUI
import SwiftUINavigationCore
import ToastUI

struct ExamplesView: View {
  @State var toast: ToastView?

  var body: some View {
    VStack(spacing: 12) {
      Button("Regular toast") {
        toast = ToastView(
          ToastState(
            style: .regular,
            icon: ImageState(systemName: "exclamationmark.square"),
            title: TextState("Regular toast"),
            subtitle: TextState("This is the subtitle.")
          )
        )
      }

      Button("Failure toast") {
        toast = ToastView(
          ToastState(
            style: .failure,
            icon: ImageState(systemName: "exclamationmark.square"),
            title: TextState("Failure toast"),
            subtitle: TextState("This is the subtitle.")
          )
        )
      }

      Button("Warning toast") {
        toast = ToastView(
          ToastState(
            style: .warning,
            icon: ImageState(systemName: "exclamationmark.square"),
            title: TextState("Warning toast"),
            subtitle: TextState("This is the subtitle.")
          )
        )
      }

      Button("Info toast") {
        toast = ToastView(
          ToastState(
            style: .info,
            icon: ImageState(systemName: "exclamationmark.square"),
            title: TextState("Info toast"),
            subtitle: TextState("This is the subtitle.")
          )
        )
      }

      Button("Success toast") {
        toast = ToastView(
          ToastState(
            style: .success,
            icon: ImageState(systemName: "exclamationmark.square"),
            title: TextState("Success toast"),
            subtitle: TextState("This is the subtitle.")
          )
        )
      }
    }
    .buttonStyle(.bordered)
    .padding(12)
    .toast(item: $toast) { $0 }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ExamplesView()
  }
}
