//
//  FAFilter.swift
//  Fashion




import CoreImage
import Accelerate

// Reuse the same CI Context for all CI drawing.
private let ciContext = CIContext(options: nil)

/// Transformer method which will be used in to provide a `FAFilter`.
public typealias Transformer = (CIImage) -> CIImage?

/// Supply a filter to create an `FAImageProcessor`.
public protocol CIImageProcessor: FAImageProcessor {
    var filter: FAFilter { get }
}

extension CIImageProcessor {
    public func process(item: ImageProcessItem, options: FashionOptionsInfo) -> FAImage? {
        switch item {
        case .image(let image):
            return image.fa.apply(filter)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

/// Wrapper for a `Transformer` of CIImage filters.
public struct FAFilter {
    
    let transform: Transformer

    public init(tranform: @escaping Transformer) {
        self.transform = tranform
    }
    
    /// Tint filter which will apply a tint color to images.
    public static var tint: (Color) -> FAFilter = {
        color in
        FAFilter { input in
            let colorFilter = CIFilter(name: "CIConstantColorGenerator")!
            colorFilter.setValue(CIColor(color: color), forKey: kCIInputColorKey)
            
            let colorImage = colorFilter.outputImage
            let filter = CIFilter(name: "CISourceOverCompositing")!
            filter.setValue(colorImage, forKey: kCIInputImageKey)
            filter.setValue(input, forKey: kCIInputBackgroundImageKey)
            return filter.outputImage?.cropped(to: input.extent)
        }
    }
    
    public typealias ColorElement = (CGFloat, CGFloat, CGFloat, CGFloat)
    
    /// Color control filter which will apply color control change to images.
    public static var colorControl: (ColorElement) -> FAFilter = {
        (arg) -> FAFilter in
        
        let (brightness, contrast, saturation, inputEV) = arg
        return FAFilter { input in
            let paramsColor = [kCIInputBrightnessKey: brightness,
                               kCIInputContrastKey: contrast,
                               kCIInputSaturationKey: saturation]
            
            let blackAndWhite = input.applyingFilter("CIColorControls", parameters: paramsColor)
            let paramsExposure = [kCIInputEVKey: inputEV]
            return blackAndWhite.applyingFilter("CIExposureAdjust", parameters: paramsExposure)
        }
        
    }
}

extension Fashion where Base: FAImage {
    /// Apply a `FAFilter` containing `CIImage` transformer to `self`.
    ///
    /// - parameter filter: The filter used to transform `self`.
    ///
    /// - returns: A transformed image by input `FAFilter`.
    ///
    /// - Note: Only CG-based images are supported. If any error happens during transforming, `self` will be returned.
    public func apply(_ filter: FAFilter) -> FAImage {
        
        guard let cgImage = cgImage else {
            assertionFailure("[Fashion] Tint image only works for CG-based image.")
            return base
        }
        
        let inputImage = CIImage(cgImage: cgImage)
        guard let outputImage = filter.transform(inputImage) else {
            return base
        }
        
        guard let result = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
            assertionFailure("[Fashion] Can not make an tint image within context.")
            return base
        }
        
        #if os(macOS)
            return fixedForRetinaPixel(cgImage: result, to: size)
        #else
            return FAImage(cgImage: result, scale: base.scale, orientation: base.imageOrientation)
        #endif
    }

}

public extension FAImage {
    
    /// Apply a `FAFilter` containing `CIImage` transformer to `self`.
    ///
    /// - parameter filter: The filter used to transform `self`.
    ///
    /// - returns: A transformed image by input `FAFilter`.
    ///
    /// - Note: Only CG-based images are supported. If any error happens during transforming, `self` will be returned.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.apply` instead.",
    renamed: "fa.apply")
    public func fa_apply(_ filter: FAFilter) -> FAImage {
        return fa.apply(filter)
    }
}
