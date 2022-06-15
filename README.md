# ToastUI

## Usage

```swift
struct ContentView: View {
    @State var tostPresented = false

    var body: some View {
        Button("Show toast") { 
            toastPresented = true 
        }
        .toast(isPresented: $toastPresented) { 
            ToastView(title: "This a toast")
        }
    }
}
```
