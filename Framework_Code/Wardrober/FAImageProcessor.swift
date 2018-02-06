//
//  FAImageProcessor.swift
//  Fashion

import Foundation
import CoreGraphics

/// The item which could be processed by an `FAImageProcessor`
///
/// - image: Input image
/// - data:  Input data
public enum ImageProcessItem {
    case image(FAImage)
    case data(Data)
}

/// An `FAImageProcessor` would be used to convert some downloaded data to an image.
public protocol FAImageProcessor {
    /// Identifier of the processor. It will be used to identify the processor when 
    /// caching and retriving an image. You might want to make sure that processors with
    /// same properties/functionality have the same identifiers, so correct processed images
    /// could be retrived with proper key.
    /// 
    /// - Note: Do not supply an empty string for a customized processor, which is already taken by
    /// the `DefaultImageProcessor`. It is recommended to use a reverse domain name notation
    /// string of your own for the identifier.
    var identifier: String { get }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: The return value will be `nil` if processing failed while converting data to image.
    ///         If input item is already an image and there is any errors in processing, the input 
    ///         image itself will be returned.
    /// - Note: Most processor only supports CG-based images. 
    ///         watchOS is not supported for processers containing filter, the input image will be returned directly on watchOS.
    func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage?
}

typealias ProcessorImp = ((ImageProcessItem, FashionOptionsInfo) -> FAImage?)

public extension FAImageProcessor {
    
    /// Append an `FAImageProcessor` to another. The identifier of the new `FAImageProcessor` 
    /// will be "\(self.identifier)|>\(another.identifier)".
    ///
    /// - parameter another: An `FAImageProcessor` you want to append to `self`.
    ///
    /// - returns: The new `FAImageProcessor` will process the image in the order
    ///            of the two processors concatenated.
    public func append(another: FAImageProcessor) -> FAImageProcessor {
        let newIdentifier = identifier.appending("|>\(another.identifier)")
        return GeneralProcessor(identifier: newIdentifier) {
            item, options in
            if let image = self.process(item: item, options: options) {
                return another.process(item: .image(image), options: options)
            } else {
                return nil
            }
        }
    }
}

fileprivate struct GeneralProcessor: FAImageProcessor {
    let identifier: String
    let p: ProcessorImp
    func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        return p(item, options)
    }
}

/// The default processor. It convert the input data to a valid image.
/// Images of .PNG, .JPEG and .GIF format are supported.
/// If an image is given, `DefaultImageProcessor` will do nothing on it and just return that image.
public struct DefaultImageProcessor: FAImageProcessor {
    
    /// A default `DefaultImageProcessor` could be used across.
    public static let `default` = DefaultImageProcessor()
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier = ""
    
    /// Initialize a `DefaultImageProcessor`
    public init() {}
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    /// 
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            return Fashion<FAImage>.image(
                data: data,
                scale: options.scaleFactor,
                preloadAllAnimationData: options.preloadAllAnimationData,
                onlyFirstFrame: options.onlyLoadFirstFrame)
        }
    }
}

public struct RectCorner: OptionSet {
    public let rawValue: Int
    public static let topLeft = RectCorner(rawValue: 1 << 0)
    public static let topRight = RectCorner(rawValue: 1 << 1)
    public static let bottomLeft = RectCorner(rawValue: 1 << 2)
    public static let bottomRight = RectCorner(rawValue: 1 << 3)
    public static let all: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    var cornerIdentifier: String {
        if self == .all {
            return ""
        }
        return "_corner(\(rawValue))"
    }
}

/// Processor for making round corner images. Only CG-based images are supported in macOS, 
/// if a non-CG image passed in, the processor will do nothing.
public struct RoundCornerImageProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String

    /// Corner radius will be applied in processing.
    public let cornerRadius: CGFloat
    
    /// The target corners which will be applied rounding.
    public let roundingCorners: RectCorner
    
    /// Target size of output image should be. If `nil`, the image will keep its original size after processing.
    public let targetSize: CGSize?
    
    /// Initialize a `RoundCornerImageProcessor`
    ///
    /// - parameter cornerRadius: Corner radius will be applied in processing.
    /// - parameter targetSize:   Target size of output image should be. If `nil`, 
    ///                           the image will keep its original size after processing.
    ///                           Default is `nil`.
    /// - parameter corners:      The target corners which will be applied rounding. Default is `.all`.
    public init(cornerRadius: CGFloat, targetSize: CGSize? = nil, roundingCorners corners: RectCorner = .all) {
        self.cornerRadius = cornerRadius
        self.targetSize = targetSize
        self.roundingCorners = corners
        
        if let size = targetSize {
            self.identifier = "com.onevcat.Fashion.RoundCornerImageProcessor(\(cornerRadius)_\(size)\(corners.cornerIdentifier))"
        } else {
            self.identifier = "com.onevcat.Fashion.RoundCornerImageProcessor(\(cornerRadius)\(corners.cornerIdentifier))"
        }
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            let size = targetSize ?? image.fa.size
            return image.fa.image(withRoundRadius: cornerRadius, fit: size, roundingCorners: roundingCorners)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}


/// Specify how a size adjusts itself to fit a target size.
///
/// - none: Not scale the content.
/// - aspectFit: Scale the content to fit the size of the view by maintaining the aspect ratio.
/// - aspectFill: Scale the content to fill the size of the view
public enum ContentMode {
    case none
    case aspectFit
    case aspectFill
}

/// Processor for resizing images. Only CG-based images are supported in macOS.
public struct ResizingImageProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String
    
    /// The reference size for resizing operation.
    public let referenceSize: CGSize
    
    /// Target content mode of output image should be.
    /// Default to ContentMode.none
    public let targetContentMode: ContentMode
    
    /// Initialize a `ResizingImageProcessor`.
    ///
    /// - Parameters:
    ///   - referenceSize: The reference size for resizing operation.
    ///   - mode: Target content mode of output image should be.
    ///
    /// - Note:
    ///   The instance of `ResizingImageProcessor` will follow its `mode` property
    ///   and try to resizing the input images to fit or fill the `referenceSize`.
    ///   That means if you are using a `mode` besides of `.none`, you may get an
    ///   image with its size not be the same as the `referenceSize`.
    ///
    ///   **Example**: With input image size: {100, 200}, 
    ///   `referenceSize`: {100, 100}, `mode`: `.aspectFit`,
    ///   you will get an output image with size of {50, 100}, which "fit"s
    ///   the `referenceSize`.
    ///
    ///   If you need an output image exactly to be a specified size, append or use
    ///   a `CroppingImageProcessor`.
    public init(referenceSize: CGSize, mode: ContentMode = .none) {
        self.referenceSize = referenceSize
        self.targetContentMode = mode
        
        if mode == .none {
            self.identifier = "com.onevcat.Fashion.ResizingImageProcessor(\(referenceSize))"
        } else {
            self.identifier = "com.onevcat.Fashion.ResizingImageProcessor(\(referenceSize), \(mode))"
        }
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image.fa.resize(to: referenceSize, for: targetContentMode)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Processor for adding blur effect to images. `Accelerate.framework` is used underhood for 
/// a better performance. A simulated Gaussian blur with specified blur radius will be applied.
public struct BlurImageProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String
    
    /// Blur radius for the simulated Gaussian blur.
    public let blurRadius: CGFloat

    /// Initialize a `BlurImageProcessor`
    ///
    /// - parameter blurRadius: Blur radius for the simulated Gaussian blur.
    public init(blurRadius: CGFloat) {
        self.blurRadius = blurRadius
        self.identifier = "com.onevcat.Fashion.BlurImageProcessor(\(blurRadius))"
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            let radius = blurRadius * options.scaleFactor
            return image.fa.blurred(withRadius: radius)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Processor for adding an overlay to images. Only CG-based images are supported in macOS.
public struct OverlayImageProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String
    
    /// Overlay color will be used to overlay the input image.
    public let overlay: Color
    
    /// Fraction will be used when overlay the color to image.
    public let fraction: CGFloat
    
    /// Initialize an `OverlayImageProcessor`
    ///
    /// - parameter overlay:  Overlay color will be used to overlay the input image.
    /// - parameter fraction: Fraction will be used when overlay the color to image. 
    ///                       From 0.0 to 1.0. 0.0 means solid color, 1.0 means transparent overlay.
    public init(overlay: Color, fraction: CGFloat = 0.5) {
        self.overlay = overlay
        self.fraction = fraction
        self.identifier = "com.onevcat.Fashion.OverlayImageProcessor(\(overlay.hex)_\(fraction))"
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image.fa.overlaying(with: overlay, fraction: fraction)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Processor for tint images with color. Only CG-based images are supported.
public struct TintImageProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String
    
    /// Tint color will be used to tint the input image.
    public let tint: Color
    
    /// Initialize a `TintImageProcessor`
    ///
    /// - parameter tint: Tint color will be used to tint the input image.
    public init(tint: Color) {
        self.tint = tint
        self.identifier = "com.onevcat.Fashion.TintImageProcessor(\(tint.hex))"
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image.fa.tinted(with: tint)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Processor for applying some color control to images. Only CG-based images are supported.
/// watchOS is not supported.
public struct ColorControlsProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String
    
    /// Brightness changing to image.
    public let brightness: CGFloat
    
    /// Contrast changing to image.
    public let contrast: CGFloat
    
    /// Saturation changing to image.
    public let saturation: CGFloat
    
    /// InputEV changing to image.
    public let inputEV: CGFloat
    
    /// Initialize a `ColorControlsProcessor`
    ///
    /// - parameter brightness: Brightness changing to image.
    /// - parameter contrast:   Contrast changing to image.
    /// - parameter saturation: Saturation changing to image.
    /// - parameter inputEV:    InputEV changing to image.
    public init(brightness: CGFloat, contrast: CGFloat, saturation: CGFloat, inputEV: CGFloat) {
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.inputEV = inputEV
        self.identifier = "com.onevcat.Fashion.ColorControlsProcessor(\(brightness)_\(contrast)_\(saturation)_\(inputEV))"
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image.fa.adjusted(brightness: brightness, contrast: contrast, saturation: saturation, inputEV: inputEV)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Processor for applying black and white effect to images. Only CG-based images are supported.
/// watchOS is not supported.
public struct BlackWhiteProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier = "com.onevcat.Fashion.BlackWhiteProcessor"
    
    /// Initialize a `BlackWhiteProcessor`
    public init() {}
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        return ColorControlsProcessor(brightness: 0.0, contrast: 1.0, saturation: 0.0, inputEV: 0.7)
            .process(item: item, options: options)
    }
}

/// Processor for cropping an image. Only CG-based images are supported.
/// watchOS is not supported.
public struct CroppingImageProcessor: FAImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public let identifier: String
    
    /// Target size of output image should be.
    public let size: CGSize
    
    /// Anchor point from which the output size should be calculate.
    /// The anchor point is consisted by two values between 0.0 and 1.0.
    /// It indicates a related point in current image. 
    /// See `CroppingImageProcessor.init(size:anchor:)` for more.
    public let anchor: CGPoint
    
    /// Initialize a `CroppingImageProcessor`
    ///
    /// - Parameters:
    ///   - size: Target size of output image should be.
    ///   - anchor: The anchor point from which the size should be calculated.
    ///             Default is `CGPoint(x: 0.5, y: 0.5)`, which means the center of input image.
    /// - Note:
    ///   The anchor point is consisted by two values between 0.0 and 1.0.
    ///   It indicates a related point in current image, eg: (0.0, 0.0) for top-left
    ///   corner, (0.5, 0.5) for center and (1.0, 1.0) for bottom-right corner.
    ///   The `size` property of `CroppingImageProcessor` will be used along with
    ///   `anchor` to calculate a target rectange in the size of image.
    ///    
    ///   The target size will be automatically calculated with a reasonable behavior.
    ///   For example, when you have an image size of `CGSize(width: 100, height: 100)`,
    ///   and a target size of `CGSize(width: 20, height: 20)`: 
    ///   - with a (0.0, 0.0) anchor (top-left), the crop rect will be `{0, 0, 20, 20}`; 
    ///   - with a (0.5, 0.5) anchor (center), it will be `{40, 40, 20, 20}`
    ///   - while with a (1.0, 1.0) anchor (bottom-right), it will be `{80, 80, 20, 20}`
    public init(size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        self.size = size
        self.anchor = anchor
        self.identifier = "com.onevcat.Fashion.CroppingImageProcessor(\(size)_\(anchor))"
    }
    
    /// Process an input `ImageProcessItem` item to an image for this processor.
    ///
    /// - parameter item:    Input item which will be processed by `self`
    /// - parameter options: Options when processing the item.
    ///
    /// - returns: The processed image.
    ///
    /// - Note: See documentation of `FAImageProcessor` protocol for more.
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image.fa.crop(to: size, anchorOn: anchor)
        case .data(_): return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Concatenate two `FAImageProcessor`s. `FAImageProcessor.appen(another:)` is used internally.
///
/// - parameter left:  First processor.
/// - parameter right: Second processor.
///
/// - returns: The concatenated processor.
public func >>(left: FAImageProcessor, right: FAImageProcessor) -> FAImageProcessor {
    return left.append(another: right)
}

fileprivate extension Color {
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rInt = Int(r * 255) << 24
        let gInt = Int(g * 255) << 16
        let bInt = Int(b * 255) << 8
        let aInt = Int(a * 255)
        
        let rgba = rInt | gInt | bInt | aInt
        
        return String(format:"#%08x", rgba)
    }
}

// MARK: - Deprecated
extension ResizingImageProcessor {
    /// Reference size of output image should follow.
    @available(*, deprecated,
    message: "targetSize are renamed. Use `referenceSize` instead",
    renamed: "referenceSize")
    public var targetSize: CGSize {
        return referenceSize
    }
    
    /// Initialize a `ResizingImageProcessor`
    ///
    /// - parameter targetSize: Reference size of output image should follow.
    /// - parameter contentMode: Target content mode of output image should be.
    @available(*, deprecated,
    message: "targetSize and contentMode are renamed. Use `init(referenceSize:mode:)` instead",
    renamed: "init(referenceSize:mode:)")
    public init(targetSize: CGSize, contentMode: ContentMode = .none) {
        self.init(referenceSize: targetSize, mode: contentMode)
    }
}
