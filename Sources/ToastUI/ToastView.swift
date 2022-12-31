import SwiftUI

public struct ToastView: View {
  public enum Style {
    case success
    case failure
    case warning
    case info
    case regular

    var backgroundColor: Color {
      switch self {
      case .success: return .green
      case .failure: return .red
      case .warning: return .yellow
      case .info: return .blue
      case .regular: return .clear
      }
    }
  }

  public let state: ToastState

  public init(_ state: ToastState) {
    self.state = state
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        if let icon = state.icon {
          Image(icon)
        }
        Text(state.title)
      }
      state.subtitle.map { Text($0) }
    }
    .font(.headline.bold())
    .multilineTextAlignment(.leading)
    .padding(12)
    #if !os(watchOS)
      .background(.regularMaterial)
    #endif
      .background(state.style.backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
      .padding(16)
  }
}
