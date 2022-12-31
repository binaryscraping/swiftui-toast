import _SwiftUINavigationState
import SwiftUI

public struct ImageState: Hashable, Equatable {
  fileprivate var modifiers: [Modifier] = []
  fileprivate var storage: Storage

  fileprivate enum Modifier: Equatable, Hashable {
    case resizable(capInsets: ImageState.EdgeInsets, resizingMode: Image.ResizingMode)
    case antialiased(Bool)
    case symbolRenderingMode(ImageState.SymbolRenderingMode?)
    case renderingMode(Image.TemplateRenderingMode?)
    case interpolation(Image.Interpolation)
  }

  public struct EdgeInsets: Equatable, Hashable {
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat

    public init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
      self.top = top
      self.bottom = bottom
      self.leading = leading
      self.trailing = trailing
    }

    var toSwiftUI: SwiftUI.EdgeInsets {
      .init(
        top: top,
        leading: leading,
        bottom: bottom,
        trailing: trailing
      )
    }
  }

  public enum SymbolRenderingMode: Equatable, Hashable {
    case hierarchical
    case monochrome
    case multicolor
    case palette

    var toSwiftUI: SwiftUI.SymbolRenderingMode {
      switch self {
      case .hierarchical: return .hierarchical
      case .monochrome: return .monochrome
      case .multicolor: return .multicolor
      case .palette: return .palette
      }
    }
  }

  fileprivate enum Storage: Equatable, Hashable {
    case named(String, Bundle?)

    case namedWithVariableValue(String, Double?, Bundle?)

    case labeled(String, Bundle?, TextState)
    case labeledWithVariableValue(String, Double?, Bundle?, TextState)
    case labeledWithCGImage(CGImage, CGFloat, Image.Orientation, TextState)

    case decorative(String, Bundle?)
    case decorativeWithVariableValue(String, Double?, Bundle?)
    case decorativeWithCGImage(CGImage, CGFloat, Image.Orientation)

    case systemName(String)
    case systemNameWithVariableValue(String, Double?)

    #if canImport(UIKit)
      case uiImage(UIImage)
    #endif

    #if canImport(AppKit)
      case nsImage(NSImage)
    #endif
  }
}

extension ImageState {
  public init(_ name: String, bundle: Bundle? = nil) {
    self.init(storage: .named(name, bundle))
  }

  @available(macOS 13.0, iOS 16.0, *)
  public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil) {
    self.init(storage: .namedWithVariableValue(name, variableValue, bundle))
  }

  public init(_ name: String, bundle: Bundle? = nil, label: TextState) {
    self.init(storage: .labeled(name, bundle, label))
  }

  @available(macOS 13.0, iOS 16.0, *)
  public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil, label: TextState) {
    self.init(storage: .labeledWithVariableValue(name, variableValue, bundle, label))
  }

  public init(
    _ cgImage: CGImage,
    scale: CGFloat,
    orientation: Image.Orientation = .up,
    label: TextState
  ) {
    self.init(storage: .labeledWithCGImage(cgImage, scale, orientation, label))
  }

  public init(decorative name: String, bundle: Bundle? = nil) {
    self.init(storage: .decorative(name, bundle))
  }

  @available(macOS 13.0, iOS 16.0, *)
  public init(decorative name: String, variableValue: Double?, bundle: Bundle? = nil) {
    self.init(storage: .decorativeWithVariableValue(name, variableValue, bundle))
  }

  public init(decorative cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up) {
    self.init(storage: .decorativeWithCGImage(cgImage, scale, orientation))
  }

  public init(systemName: String) {
    self.init(storage: .systemName(systemName))
  }

  @available(macOS 13.0, iOS 16.0, *)
  public init(systemName: String, variableValue: Double?) {
    self.init(storage: .systemNameWithVariableValue(systemName, variableValue))
  }

  #if canImport(UIKit)
    public init(uiImage: UIImage) {
      self.init(storage: .uiImage(uiImage))
    }
  #endif

  #if canImport(AppKit)
    public init(nsImage: NSImage) {
      self.init(storage: .nsImage(nsImage))
    }
  #endif

  @available(*, unavailable)
  public init(
    size _: CGSize,
    label _: Text? = nil,
    opaque _: Bool = false,
    colorMode _: ColorRenderingMode = .nonLinear,
    renderer _: @escaping (inout GraphicsContext) -> Void
  ) {
    fatalError("Unsupported.")
  }
}

extension ImageState {
  public func resizable(
    capInsets: ImageState.EdgeInsets = .init(top: 0, bottom: 0, leading: 0, trailing: 0),
    resizingMode: Image.ResizingMode = .stretch
  ) -> ImageState {
    var copy = self
    copy.modifiers.append(.resizable(capInsets: capInsets, resizingMode: resizingMode))
    return copy
  }

  public func antialiased(_ isAntialiased: Bool) -> ImageState {
    var copy = self
    copy.modifiers.append(.antialiased(isAntialiased))
    return copy
  }

  public func symbolRenderingMode(_ mode: ImageState.SymbolRenderingMode?) -> ImageState {
    var copy = self
    copy.modifiers.append(.symbolRenderingMode(mode))
    return copy
  }

  public func renderingMode(_ mode: Image.TemplateRenderingMode?) -> ImageState {
    var copy = self
    copy.modifiers.append(.renderingMode(mode))
    return copy
  }

  public func interpolation(_ interpolation: Image.Interpolation) -> ImageState {
    var copy = self
    copy.modifiers.append(.interpolation(interpolation))
    return copy
  }
}

extension Image {
  public init(_ state: ImageState) {
    let image: Image
    switch state.storage {
    case let .named(name, bundle):
      image = .init(name, bundle: bundle)
    case let .namedWithVariableValue(name, variableValue, bundle):
      if #available(macOS 13.0, iOS 16.0, *) {
        image = .init(name, variableValue: variableValue, bundle: bundle)
      } else {
        fatalError("Not supported.")
      }
    case let .labeled(name, bundle, label):
      image = .init(name, bundle: bundle, label: Text(label))
    case let .labeledWithVariableValue(name, variableValue, bundle, label):
      if #available(macOS 13.0, iOS 16.0, *) {
        image = .init(name, variableValue: variableValue, bundle: bundle, label: Text(label))
      } else {
        fatalError("Not supported.")
      }
    case let .labeledWithCGImage(cgImage, scale, orientation, label):
      image = .init(cgImage, scale: scale, orientation: orientation, label: Text(label))
    case let .decorative(decorative, bundle):
      image = .init(decorative: decorative, bundle: bundle)
    case let .decorativeWithVariableValue(decorative, variableValue, bundle):
      if #available(macOS 13.0, iOS 16.0, *) {
        image = .init(decorative: decorative, variableValue: variableValue, bundle: bundle)
      } else {
        fatalError("Not supported.")
      }
    case let .decorativeWithCGImage(cgImage, scale, orientation):
      image = .init(decorative: cgImage, scale: scale, orientation: orientation)
    case let .systemName(systemName):
      image = .init(systemName: systemName)
    case let .systemNameWithVariableValue(systemName, variableValue):
      if #available(macOS 13.0, iOS 16.0, *) {
        image = .init(systemName: systemName, variableValue: variableValue)
      } else {
        fatalError("Not supported.")
      }

    #if canImport(UIKit)
      case let .uiImage(uiImage):
        image = .init(uiImage: uiImage)
    #endif

    #if canImport(AppKit)
      case let .nsImage(nsImage):
        image = .init(nsImage: nsImage)
    #endif
    }

    self = state.modifiers.reduce(image) { image, modifier in
      switch modifier {
      case let .resizable(capInsets, resizingMode):
        return image.resizable(capInsets: capInsets.toSwiftUI, resizingMode: resizingMode)
      case let .antialiased(isAntialiased):
        return image.antialiased(isAntialiased)
      case let .symbolRenderingMode(mode):
        return image.symbolRenderingMode(mode?.toSwiftUI)
      case let .renderingMode(mode):
        return image.renderingMode(mode)
      case let .interpolation(interpolation):
        return image.interpolation(interpolation)
      }
    }
  }
}
