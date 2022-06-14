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

  public let style: Style
  public let icon: Image?
  public let title: String
  public let subtitle: String?

  public init(
    style: Style = .regular,
    icon: Image? = nil,
    title: String,
    subtitle: String? = nil
  ) {
    self.style = style
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        icon
        Text(title)
      }
      subtitle.map { Text($0) }
    }
    .font(.headline.bold())
    .multilineTextAlignment(.leading)
    .padding(12)
#if !os(watchOS)
    .background(.regularMaterial)
#endif
    .background(style.backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    .padding(16)
  }
}
