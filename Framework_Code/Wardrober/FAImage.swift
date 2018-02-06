//
//  FAImage.swift
//  Fashion
//

#if os(macOS)
import AppKit
private var imagesKey: Void?
private var durationKey: Void?
#else
import UIKit
import MobileCoreServices
private var imageSourceKey: Void?
#endif
private var animatedImageDataKey: Void?

import ImageIO
import CoreGraphics

#if !os(watchOS)
import Accelerate
import CoreImage
#endif

// MARK: - FAImage Properties
extension Fashion where Base: FAImage {
    fileprivate(set) var animatedImageData: Data? {
        get {
            return objc_getAssociatedObject(base, &animatedImageDataKey) as? Data
        }
        set {
            objc_setAssociatedObject(base, &animatedImageDataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    #if os(macOS)
    var cgImage: CGImage? {
        return base.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    var scale: CGFloat {
        return 1.0
    }
    
    fileprivate(set) var images: [FAImage]? {
        get {
            return objc_getAssociatedObject(base, &imagesKey) as? [FAImage]
        }
        set {
            objc_setAssociatedObject(base, &imagesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate(set) var duration: TimeInterval {
        get {
            return objc_getAssociatedObject(base, &durationKey) as? TimeInterval ?? 0.0
        }
        set {
            objc_setAssociatedObject(base, &durationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var size: CGSize {
        return base.representations.reduce(CGSize.zero, { size, rep in
            return CGSize(width: max(size.width, CGFloat(rep.pixelsWide)), height: max(size.height, CGFloat(rep.pixelsHigh)))
        })
    }
    
    #else
    var cgImage: CGImage? {
        return base.cgImage
    }
    
    var scale: CGFloat {
        return base.scale
    }
    
    var images: [FAImage]? {
        return base.images
    }
    
    var duration: TimeInterval {
        return base.duration
    }
    
    fileprivate(set) var imageSource: ImageSource? {
        get {
            return objc_getAssociatedObject(base, &imageSourceKey) as? ImageSource
        }
        set {
            objc_setAssociatedObject(base, &imageSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var size: CGSize {
        return base.size
    }
    #endif
}

// MARK: - FAImage Conversion
extension Fashion where Base: FAImage {
    #if os(macOS)
    static func image(cgImage: CGImage, scale: CGFloat, refImage: FAImage?) -> FAImage {
        return FAImage(cgImage: cgImage, size: CGSize.zero)
    }
    
    /**
     Normalize the image. This method does nothing in OS X.
     
     - returns: The image itself.
     */
    public var normalized: FAImage {
        return base
    }
    
    static func animated(with images: [FAImage], forDuration forDurationduration: TimeInterval) -> FAImage? {
        return nil
    }
    #else
    static func image(cgImage: CGImage, scale: CGFloat, refImage: FAImage?) -> FAImage {
        if let refImage = refImage {
            return FAImage(cgImage: cgImage, scale: scale, orientation: refImage.imageOrientation)
        } else {
            return FAImage(cgImage: cgImage, scale: scale, orientation: .up)
        }
    }
    
    /**
     Normalize the image. This method will try to redraw an image with orientation and scale considered.
     
     - returns: The normalized image with orientation set to up and correct scale.
     */
    public var normalized: FAImage {
        // prevent animated image (GIF) lose it's images
        guard images == nil else { return base }
        // No need to do anything if already up
        guard base.imageOrientation != .up else { return base }
    
        return draw(cgImage: nil, to: size) {
            base.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }
    }
    
    static func animated(with images: [FAImage], forDuration duration: TimeInterval) -> FAImage? {
        return .animatedImage(with: images, duration: duration)
    }
    #endif
}

// MARK: - FAImage Representation
extension Fashion where Base: FAImage {
    // MARK: - PNG
    public func pngRepresentation() -> Data? {
        #if os(macOS)
            guard let cgimage = cgImage else {
                return nil
            }
            let rep = NSBitmapImageRep(cgImage: cgimage)
            return rep.representation(using: .PNG, properties: [:])
        #else
            return UIImagePNGRepresentation(base)
        #endif
    }
    
    // MARK: - JPEG
    public func jpegRepresentation(compressionQuality: CGFloat) -> Data? {
        #if os(macOS)
            guard let cgImage = cgImage else {
                return nil
            }
            let rep = NSBitmapImageRep(cgImage: cgImage)
            return rep.representation(using:.JPEG, properties: [NSImageCompressionFactor: compressionQuality])
        #else
            return UIImageJPEGRepresentation(base, compressionQuality)
        #endif
    }
    
    // MARK: - GIF
    public func gifRepresentation() -> Data? {
        return animatedImageData
    }
}

// MARK: - Create images from data
extension Fashion where Base: FAImage {
    static func animated(with data: Data, scale: CGFloat = 1.0, duration: TimeInterval = 0.0, preloadAll: Bool, onlyFirstFrame: Bool = false) -> FAImage? {
        
        func decode(from imageSource: CGImageSource, for options: NSDictionary) -> ([FAImage], TimeInterval)? {
            
            //Calculates frame duration for a gif frame out of the kCGImagePropertyGIFDictionary dictionary
            func frameDuration(from gifInfo: NSDictionary?) -> Double {
                let gifDefaultFrameDuration = 0.100
                
                guard let gifInfo = gifInfo else {
                    return gifDefaultFrameDuration
                }
                
                let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
                let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
                let duration = unclampedDelayTime ?? delayTime
                
                guard let frameDuration = duration else { return gifDefaultFrameDuration }
                
                return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : gifDefaultFrameDuration
            }
            
            let frameCount = CGImageSourceGetCount(imageSource)
            var images = [FAImage]()
            var gifDuration = 0.0
            for i in 0 ..< frameCount {
                
                guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, options) else {
                    return nil
                }

                if frameCount == 1 {
                    // Single frame
                    gifDuration = Double.infinity
                } else {
                    
                    // Animated GIF
                    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else {
                        return nil
                    }

                    let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary
                    gifDuration += frameDuration(from: gifInfo)
                }
                
                images.append(Fashion<FAImage>.image(cgImage: imageRef, scale: scale, refImage: nil))
                
                if onlyFirstFrame { break }
            }
            
            return (images, gifDuration)
        }
        
        // Start of fa.animatedImageWithGIFData
        let options: NSDictionary = [kCGImageSourceShouldCache as String: true, kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
            return nil
        }
        
        #if os(macOS)
            guard let (images, gifDuration) = decode(from: imageSource, for: options) else {
                return nil
            }
            let image: FAImage?
            if onlyFirstFrame {
                image = images.first
            } else {
                image = FAImage(data: data)
                image?.fa.images = images
                image?.fa.duration = gifDuration
            }
            image?.fa.animatedImageData = data
            return image
        #else
            
            let image: FAImage?
            if preloadAll || onlyFirstFrame {
                guard let (images, gifDuration) = decode(from: imageSource, for: options) else { return nil }
                image = onlyFirstFrame ? images.first : Fashion<FAImage>.animated(with: images, forDuration: duration <= 0.0 ? gifDuration : duration)
            } else {
                image = FAImage(data: data)
                image?.fa.imageSource = ImageSource(ref: imageSource)
            }
            image?.fa.animatedImageData = data
            return image
        #endif
    }

    static func image(data: Data, scale: CGFloat, preloadAllAnimationData: Bool, onlyFirstFrame: Bool) -> FAImage? {
        var image: FAImage?

        #if os(macOS)
            switch data.fa.imageFormat {
            case .JPEG:
                image = FAImage(data: data)
            case .PNG:
                image = FAImage(data: data)
            case .GIF:
                image = Fashion<FAImage>.animated(
                    with: data,
                    scale: scale,
                    duration: 0.0,
                    preloadAll: preloadAllAnimationData,
                    onlyFirstFrame: onlyFirstFrame)
            case .unknown:
                image = FAImage(data: data)
            }
        #else
            switch data.fa.imageFormat {
            case .JPEG:
                image = FAImage(data: data, scale: scale)
            case .PNG:
                image = FAImage(data: data, scale: scale)
            case .GIF:
                image = Fashion<FAImage>.animated(
                    with: data,
                    scale: scale,
                    duration: 0.0,
                    preloadAll: preloadAllAnimationData,
                    onlyFirstFrame: onlyFirstFrame)
            case .unknown:
                image = FAImage(data: data, scale: scale)
            }
        #endif

        return image
    }
}

// MARK: - FAImage Transforming
extension Fashion where Base: FAImage {

    // MARK: - Round Corner
    /// Create a round corner image based on `self`.
    ///
    /// - parameter radius:  The round corner radius of creating image.
    /// - parameter size:    The target size of creating image.
    /// - parameter corners: The target corners which will be applied rounding.
    ///
    /// - returns: An image with round corner of `self`.
    ///
    /// - Note: This method only works for CG-based image.
    public func image(withRoundRadius radius: CGFloat,
                      fit size: CGSize,
                      roundingCorners corners: RectCorner = .all) -> FAImage
    {   
        guard let cgImage = cgImage else {
            assertionFailure("[Fashion] Round corner image only works for CG-based image.")
            return base
        }
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return draw(cgImage: cgImage, to: size) {
            #if os(macOS)
                let path = NSBezierPath(roundedRect: rect, byRoundingCorners: corners, radius: radius)
                path.windingRule = .evenOddWindingRule
                path.addClip()
                base.draw(in: rect)
            #else
                guard let context = UIGraphicsGetCurrentContext() else {
                    assertionFailure("[Fashion] Failed to create CG context for image.")
                    return
                }
                let path = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corners.uiRectCorner,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath
                context.addPath(path)
                context.clip()
                base.draw(in: rect)
            #endif
        }
    }
    
    #if os(iOS) || os(tvOS)
    func resize(to size: CGSize, for contentMode: UIViewContentMode) -> FAImage {
        switch contentMode {
        case .scaleAspectFit:
            return resize(to: size, for: .aspectFit)
        case .scaleAspectFill:
            return resize(to: size, for: .aspectFill)
        default:
            return resize(to: size)
        }
    }
    #endif
    
    // MARK: - Resize
    /// Resize `self` to an image of new size.
    ///
    /// - parameter size: The target size.
    ///
    /// - returns: An image with new size.
    ///
    /// - Note: This method only works for CG-based image.
    public func resize(to size: CGSize) -> FAImage {
        
        guard let cgImage = cgImage else {
            assertionFailure("[Fashion] Resize only works for CG-based image.")
            return base
        }
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return draw(cgImage: cgImage, to: size) {
            #if os(macOS)
                base.draw(in: rect, from: NSRect.zero, operation: .copy, fraction: 1.0)
            #else
                base.draw(in: rect)
            #endif
        }
    }
    
    /// Resize `self` to an image of new size, respecting the content mode.
    ///
    /// - Parameters:
    ///   - size: The target size.
    ///   - contentMode: Content mode of output image should be.
    /// - Returns: An image with new size.
    public func resize(to size: CGSize, for contentMode: ContentMode) -> FAImage {
        switch contentMode {
        case .aspectFit:
            let newSize = self.size.fa.constrained(size)
            return resize(to: newSize)
        case .aspectFill:
            let newSize = self.size.fa.filling(size)
            return resize(to: newSize)
        default:
            return resize(to: size)
        }
    }
    
    public func crop(to size: CGSize, anchorOn anchor: CGPoint) -> FAImage {
        guard let cgImage = cgImage else {
            assertionFailure("[Fashion] Crop only works for CG-based image.")
            return base
        }
        
        let rect = self.size.fa.constrainedRect(for: size, anchor: anchor)
        guard let image = cgImage.cropping(to: rect.scaled(scale)) else {
            assertionFailure("[Fashion] Cropping image failed.")
            return base
        }
        
        return Fashion.image(cgImage: image, scale: scale, refImage: base)
    }
    
    // MARK: - Blur
    
    /// Create an image with blur effect based on `self`.
    ///
    /// - parameter radius: The blur radius should be used when creating blue.
    ///
    /// - returns: An image with blur effect applied.
    ///
    /// - Note: This method only works for CG-based image.
    public func blurred(withRadius radius: CGFloat) -> FAImage {
        #if os(watchOS)
            return base
        #else
            guard let cgImage = cgImage else {
                assertionFailure("[Fashion] Blur only works for CG-based image.")
                return base
            }
            
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            // if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            let s = Float(max(radius, 2.0))
            // We will do blur on a resized image (*0.5), so the blur radius could be half as well.
            
            // Fix the slow compiling time for Swift 3. 
            // See https://github.com/onevcat/Fashion/issues/611
            let pi2 = 2 * Float.pi
            let sqrtPi2 = sqrt(pi2)
            var targetRadius = floor(s * 3.0 * sqrtPi2 / 4.0 + 0.5)
            
            if targetRadius.isEven {
                targetRadius += 1
            }
            
            let iterations: Int
            if radius < 0.5 {
                iterations = 1
            } else if radius < 1.5 {
                iterations = 2
            } else {
                iterations = 3
            }
            
            let w = Int(size.width)
            let h = Int(size.height)
            let rowBytes = Int(CGFloat(cgImage.bytesPerRow))
            
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }

            guard let context = beginContext(size: size) else {
                assertionFailure("[Fashion] Failed to create CG context for blurring image.")
                return base
            }
            defer { endContext() }

            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: w, height: h))
            
            var inBuffer = createEffectBuffer(context)
            
            guard let outContext = beginContext(size: size) else {
                assertionFailure("[Fashion] Failed to create CG context for blurring image.")
                return base
            }
            defer { endContext() }
            var outBuffer = createEffectBuffer(outContext)
            
            for _ in 0 ..< iterations {
                vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(targetRadius), UInt32(targetRadius), nil, vImage_Flags(kvImageEdgeExtend))
                (inBuffer, outBuffer) = (outBuffer, inBuffer)
            }
            
            #if os(macOS)
                let result = outContext.makeImage().flatMap { fixedForRetinaPixel(cgImage: $0, to: size) }
            #else
                let result = outContext.makeImage().flatMap { FAImage(cgImage: $0, scale: base.scale, orientation: base.imageOrientation) }
            #endif
            guard let blurredImage = result else {
                assertionFailure("[Fashion] Can not make an blurred image within this context.")
                return base
            }
            
            return blurredImage
        #endif
    }
    
    // MARK: - Overlay
    
    /// Create an image from `self` with a color overlay layer.
    ///
    /// - parameter color:    The color should be use to overlay.
    /// - parameter fraction: Fraction of input color. From 0.0 to 1.0. 0.0 means solid color, 1.0 means transparent overlay.
    ///
    /// - returns: An image with a color overlay applied.
    ///
    /// - Note: This method only works for CG-based image.
    public func overlaying(with color: Color, fraction: CGFloat) -> FAImage {
        
        guard let cgImage = cgImage else {
            assertionFailure("[Fashion] Overlaying only works for CG-based image.")
            return base
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return draw(cgImage: cgImage, to: rect.size) {
            #if os(macOS)
                base.draw(in: rect)
                if fraction > 0 {
                    color.withAlphaComponent(1 - fraction).set()
                    NSRectFillUsingOperation(rect, .sourceAtop)
                }
            #else
                color.set()
                UIRectFill(rect)
                base.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
                
                if fraction > 0 {
                    base.draw(in: rect, blendMode: .sourceAtop, alpha: fraction)
                }
            #endif
        }
    }
    
    // MARK: - Tint
    
    /// Create an image from `self` with a color tint.
    ///
    /// - parameter color: The color should be used to tint `self`
    ///
    /// - returns: An image with a color tint applied.
    public func tinted(with color: Color) -> FAImage {
        #if os(watchOS)
            return base
        #else
            return apply(.tint(color))
        #endif
    }
    
    // MARK: - Color Control
    
    /// Create an image from `self` with color control.
    ///
    /// - parameter brightness: Brightness changing to image.
    /// - parameter contrast:   Contrast changing to image.
    /// - parameter saturation: Saturation changing to image.
    /// - parameter inputEV:    InputEV changing to image.
    ///
    /// - returns: An image with color control applied.
    public func adjusted(brightness: CGFloat, contrast: CGFloat, saturation: CGFloat, inputEV: CGFloat) -> FAImage {
        #if os(watchOS)
            return base
        #else
            return apply(.colorControl((brightness, contrast, saturation, inputEV)))
        #endif
    }
}

// MARK: - Decode
extension Fashion where Base: FAImage {
    var decoded: FAImage? {
        return decoded(scale: scale)
    }
    
    func decoded(scale: CGFloat) -> FAImage {
        // prevent animated image (GIF) lose it's images
        #if os(iOS)
            if imageSource != nil { return base }
        #else
            if images != nil { return base }
        #endif
        
        guard let imageRef = self.cgImage else {
            assertionFailure("[Fashion] Decoding only works for CG-based image.")
            return base
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = beginContext(size: CGSize(width: imageRef.width, height: imageRef.height)) else {
            assertionFailure("[Fashion] Decoding fails to create a valid context.")
            return base
        }
        
        defer { endContext() }
        
        let rect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        context.draw(imageRef, in: rect)
        let decompressedImageRef = context.makeImage()
        return Fashion<FAImage>.image(cgImage: decompressedImageRef!, scale: scale, refImage: base)
    }
}

/// Reference the source image reference
class ImageSource {
    var imageRef: CGImageSource?
    init(ref: CGImageSource) {
        self.imageRef = ref
    }
}

// MARK: - Image format
private struct ImageHeaderData {
    static var PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
    static var JPEG_SOI: [UInt8] = [0xFF, 0xD8]
    static var JPEG_IF: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47, 0x49, 0x46]
}

enum ImageFormat {
    case unknown, PNG, JPEG, GIF
}


// MARK: - Misc Helpers
public struct DataProxy {
    fileprivate let base: Data
    init(proxy: Data) {
        base = proxy
    }
}

extension Data: FashionCompatible {
    public typealias CompatibleType = DataProxy
    public var fa: DataProxy {
        return DataProxy(proxy: self)
    }
}

extension DataProxy {
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        (base as NSData).getBytes(&buffer, length: 8)
        if buffer == ImageHeaderData.PNG {
            return .PNG
        } else if buffer[0] == ImageHeaderData.JPEG_SOI[0] &&
            buffer[1] == ImageHeaderData.JPEG_SOI[1] &&
            buffer[2] == ImageHeaderData.JPEG_IF[0]
        {
            return .JPEG
        } else if buffer[0] == ImageHeaderData.GIF[0] &&
            buffer[1] == ImageHeaderData.GIF[1] &&
            buffer[2] == ImageHeaderData.GIF[2]
        {
            return .GIF
        }

        return .unknown
    }
}

public struct CGSizeProxy {
    fileprivate let base: CGSize
    init(proxy: CGSize) {
        base = proxy
    }
}

extension CGSize: FashionCompatible {
    public typealias CompatibleType = CGSizeProxy
    public var fa: CGSizeProxy {
        return CGSizeProxy(proxy: self)
    }
}

extension CGSizeProxy {
    func constrained(_ size: CGSize) -> CGSize {
        let aspectWidth = round(aspectRatio * size.height)
        let aspectHeight = round(size.width / aspectRatio)

        return aspectWidth > size.width ? CGSize(width: size.width, height: aspectHeight) : CGSize(width: aspectWidth, height: size.height)
    }

    func filling(_ size: CGSize) -> CGSize {
        let aspectWidth = round(aspectRatio * size.height)
        let aspectHeight = round(size.width / aspectRatio)

        return aspectWidth < size.width ? CGSize(width: size.width, height: aspectHeight) : CGSize(width: aspectWidth, height: size.height)
    }

    private var aspectRatio: CGFloat {
        return base.height == 0.0 ? 1.0 : base.width / base.height
    }
    
    
    func constrainedRect(for size: CGSize, anchor: CGPoint) -> CGRect {
        
        let unifiedAnchor = CGPoint(x: anchor.x.clamped(to: 0.0...1.0),
                                    y: anchor.y.clamped(to: 0.0...1.0))
        
        let x = unifiedAnchor.x * base.width - unifiedAnchor.x * size.width
        let y = unifiedAnchor.y * base.height - unifiedAnchor.y * size.height
        let r = CGRect(x: x, y: y, width: size.width, height: size.height)
        
        let ori = CGRect(origin: CGPoint.zero, size: base)
        return ori.intersection(r)
    }
}

extension CGRect {
    func scaled(_ scale: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scale, y: origin.y * scale,
                      width: size.width * scale, height: size.height * scale)
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Fashion where Base: FAImage {
    
    func beginContext(size: CGSize) -> CGContext? {
        #if os(macOS)
            guard let rep = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: Int(size.width),
                pixelsHigh: Int(size.height),
                bitsPerSample: cgImage?.bitsPerComponent ?? 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: NSCalibratedRGBColorSpace,
                bytesPerRow: 0,
                bitsPerPixel: 0) else
            {
                assertionFailure("[Fashion] FAImage representation cannot be created.")
                return nil
            }
            rep.size = size
            NSGraphicsContext.saveGraphicsState()
            guard let context = NSGraphicsContext(bitmapImageRep: rep) else {
                assertionFailure("[Fashion] FAImage contenxt cannot be created.")
                return nil
            }
            
            NSGraphicsContext.setCurrent(context)
            return context.cgContext
        #else
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let context = UIGraphicsGetCurrentContext()
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.translateBy(x: 0, y: -size.height)
            return context
        #endif
    }
    
    func endContext() {
        #if os(macOS)
            NSGraphicsContext.restoreGraphicsState()
        #else
            UIGraphicsEndImageContext()
        #endif
    }
    
    func draw(cgImage: CGImage?, to size: CGSize, draw: ()->()) -> FAImage {
        #if os(macOS)
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: cgImage?.bitsPerComponent ?? 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0) else
        {
            assertionFailure("[Fashion] FAImage representation cannot be created.")
            return base
        }
        rep.size = size
        
        NSGraphicsContext.saveGraphicsState()
        
        let context = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.setCurrent(context)
        draw()
        NSGraphicsContext.restoreGraphicsState()
        
        let outputImage = FAImage(size: size)
        outputImage.addRepresentation(rep)
        return outputImage
        #else
            
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw()
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
        
        #endif
    }
    
    #if os(macOS)
    func fixedForRetinaPixel(cgImage: CGImage, to size: CGSize) -> FAImage {
        
        let image = FAImage(cgImage: cgImage, size: base.size)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        return draw(cgImage: cgImage, to: self.size) {
            image.draw(in: rect, from: NSRect.zero, operation: .copy, fraction: 1.0)
        }
    }
    #endif
}

extension Float {
    var isEven: Bool {
        return truncatingRemainder(dividingBy: 2.0) == 0
    }
}

#if os(macOS)
extension NSBezierPath {
    convenience init(roundedRect rect: NSRect, topLeftRadius: CGFloat, topRightRadius: CGFloat,
         bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat)
    {
        self.init()
        
        let maxCorner = min(rect.width, rect.height) / 2
        
        let radiusTopLeft = min(maxCorner, max(0, topLeftRadius))
        let radiustopRight = min(maxCorner, max(0, topRightRadius))
        let radiusbottomLeft = min(maxCorner, max(0, bottomLeftRadius))
        let radiusbottomRight = min(maxCorner, max(0, bottomRightRadius))
        
        guard !NSIsEmptyRect(rect) else {
            return
        }
        
        let topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
        let topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
        let bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
        
        move(to: NSMakePoint(NSMidX(rect), NSMaxY(rect)))
        appendArc(from: topLeft, to: rect.origin, radius: radiusTopLeft)
        appendArc(from: rect.origin, to: bottomRight, radius: radiusbottomLeft)
        appendArc(from: bottomRight, to: topRight, radius: radiusbottomRight)
        appendArc(from: topRight, to: topLeft, radius: radiustopRight)
        close()
    }
    
    convenience init(roundedRect rect: NSRect, byRoundingCorners corners: RectCorner, radius: CGFloat) {
        let radiusTopLeft = corners.contains(.topLeft) ? radius : 0
        let radiusTopRight = corners.contains(.topRight) ? radius : 0
        let radiusBottomLeft = corners.contains(.bottomLeft) ? radius : 0
        let radiusBottomRight = corners.contains(.bottomRight) ? radius : 0
        
        self.init(roundedRect: rect, topLeftRadius: radiusTopLeft, topRightRadius: radiusTopRight,
                  bottomLeftRadius: radiusBottomLeft, bottomRightRadius: radiusBottomRight)
    }
}
    
#else
extension RectCorner {
    var uiRectCorner: UIRectCorner {
        
        var result: UIRectCorner = []
        
        if self.contains(.topLeft) { result.insert(.topLeft) }
        if self.contains(.topRight) { result.insert(.topRight) }
        if self.contains(.bottomLeft) { result.insert(.bottomLeft) }
        if self.contains(.bottomRight) { result.insert(.bottomRight) }
        
        return result
    }
}
#endif

// MARK: - Deprecated. Only for back compatibility.
extension FAImage {
    /**
     Normalize the image. This method does nothing in OS X.
     
     - returns: The image itself.
     */
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.normalized` instead.",
    renamed: "fa.normalized")
    public func fa_normalized() -> FAImage {
        return fa.normalized
    }
    
    // MARK: - Round Corner
    
    /// Create a round corner image based on `self`.
    ///
    /// - parameter radius: The round corner radius of creating image.
    /// - parameter size:   The target size of creating image.
    /// - parameter scale:  The image scale of creating image.
    ///
    /// - returns: An image with round corner of `self`.
    ///
    /// - Note: This method only works for CG-based image.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.image(withRoundRadius:fit:scale:)` instead.",
    renamed: "fa.image")
    public func fa_image(withRoundRadius radius: CGFloat, fit size: CGSize, scale: CGFloat) -> FAImage {
        return fa.image(withRoundRadius: radius, fit: size)
    }
    
    // MARK: - Resize
    /// Resize `self` to an image of new size.
    ///
    /// - parameter size: The target size.
    ///
    /// - returns: An image with new size.
    ///
    /// - Note: This method only works for CG-based image.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.resize(to:)` instead.",
    renamed: "fa.resize")
    public func fa_resize(to size: CGSize) -> FAImage {
        return fa.resize(to: size)
    }
    
    // MARK: - Blur
    /// Create an image with blur effect based on `self`.
    ///
    /// - parameter radius: The blur radius should be used when creating blue.
    ///
    /// - returns: An image with blur effect applied.
    ///
    /// - Note: This method only works for CG-based image.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.blurred(withRadius:)` instead.",
    renamed: "fa.blurred")
    public func fa_blurred(withRadius radius: CGFloat) -> FAImage {
        return fa.blurred(withRadius: radius)
    }
    
    // MARK: - Overlay
    /// Create an image from `self` with a color overlay layer.
    ///
    /// - parameter color:    The color should be use to overlay.
    /// - parameter fraction: Fraction of input color. From 0.0 to 1.0. 0.0 means solid color, 1.0 means transparent overlay.
    ///
    /// - returns: An image with a color overlay applied.
    ///
    /// - Note: This method only works for CG-based image.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.overlaying(with:fraction:)` instead.",
    renamed: "fa.overlaying")
    public func fa_overlaying(with color: Color, fraction: CGFloat) -> FAImage {
        return fa.overlaying(with: color, fraction: fraction)
    }
    
    // MARK: - Tint
    
    /// Create an image from `self` with a color tint.
    ///
    /// - parameter color: The color should be used to tint `self`
    ///
    /// - returns: An image with a color tint applied.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.tinted(with:)` instead.",
    renamed: "fa.tinted")
    public func fa_tinted(with color: Color) -> FAImage {
        return fa.tinted(with: color)
    }
    
    // MARK: - Color Control
    
    /// Create an image from `self` with color control.
    ///
    /// - parameter brightness: Brightness changing to image.
    /// - parameter contrast:   Contrast changing to image.
    /// - parameter saturation: Saturation changing to image.
    /// - parameter inputEV:    InputEV changing to image.
    ///
    /// - returns: An image with color control applied.
    @available(*, deprecated,
    message: "Extensions directly on FAImage are deprecated. Use `fa.adjusted` instead.",
    renamed: "fa.adjusted")
    public func fa_adjusted(brightness: CGFloat, contrast: CGFloat, saturation: CGFloat, inputEV: CGFloat) -> FAImage {
        return fa.adjusted(brightness: brightness, contrast: contrast, saturation: saturation, inputEV: inputEV)
    }
}

extension Fashion where Base: FAImage {
    @available(*, deprecated,
    message: "`scale` is not used. Use the version without scale instead. (Remove the `scale` argument)")
    public func image(withRoundRadius radius: CGFloat, fit size: CGSize, scale: CGFloat) -> FAImage {
        return image(withRoundRadius: radius, fit: size)
    }
}
