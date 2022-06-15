import ToastUI
import SwiftUI

struct ExamplesView: View {
    @State var toast: ToastView?

    var body: some View {
        VStack(spacing: 12) {
            Button("Regular toast") {
                toast = ToastView(
                    style: .regular,
                    icon: Image(systemName: "exclamationmark.square"),
                    title: "Regular toast",
                    subtitle: "This is the subtitle."
                )
            }

            Button("Failure toast") {
                toast = ToastView(
                    style: .failure,
                    icon: Image(systemName: "exclamationmark.square"),
                    title: "Failure toast",
                    subtitle: "This is the subtitle."
                )
            }

            Button("Warning toast") {
                toast = ToastView(
                    style: .warning,
                    icon: Image(systemName: "exclamationmark.square"),
                    title: "Warning toast",
                    subtitle: "This is the subtitle."
                )
            }

            Button("Info toast") {
                toast = ToastView(
                    style: .info,
                    icon: Image(systemName: "exclamationmark.square"),
                    title: "Info toast",
                    subtitle: "This is the subtitle."
                )
            }

            Button("Success toast") {
                toast = ToastView(
                    style: .success,
                    icon: Image(systemName: "exclamationmark.square"),
                    title: "Success toast",
                    subtitle: "This is the subtitle."
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
