//
//  FACacheSerializer.swift
//  Fashion

import Foundation

/// An `FACacheSerializer` would be used to convert some data to an image object for 
/// retrieving from disk cache and vice versa for storing to disk cache.
public protocol FACacheSerializer {
    
    /// Get the serialized data from a provided image
    /// and optional original data for caching to disk.
    ///
    ///
    /// - parameter image:    The image needed to be serialized.
    /// - parameter original: The original data which is just downloaded. 
    ///                       If the image is retrieved from cache instead of
    ///                       downloaded, it will be `nil`.
    ///
    /// - returns: A data which will be stored to cache, or `nil` when no valid
    ///            data could be serialized.
    func data(with image: FAImage, original: Data?) -> Data?
    
    /// Get an image deserialized from provided data.
    ///
    /// - parameter data:    The data from which an image should be deserialized.
    /// - parameter options: Options for deserialization.
    ///
    /// - returns: An image deserialized or `nil` when no valid image 
    ///            could be deserialized.
    func image(with data: Data, options: FashionOptionsInfo?) -> FAImage?
}


/// `DefaultCacheSerializer` is a basic `FACacheSerializer` used in default cache of
/// Fashion. It could serialize and deserialize PNG, JEPG and GIF images. For 
/// image other than these formats, a normalized `pngRepresentation` will be used.
public struct DefaultCacheSerializer: FACacheSerializer {
    
    public static let `default` = DefaultCacheSerializer()
    private init() {}
    
    public func data(with image: FAImage, original: Data?) -> Data? {
        let imageFormat = original?.fa.imageFormat ?? .unknown
        
        let data: Data?
        switch imageFormat {
        case .PNG: data = image.fa.pngRepresentation()
        case .JPEG: data = image.fa.jpegRepresentation(compressionQuality: 1.0)
        case .GIF: data = image.fa.gifRepresentation()
        case .unknown: data = original ?? image.fa.normalized.fa.pngRepresentation()
        }
        
        return data
    }
    
    public func image(with data: Data, options: FashionOptionsInfo?) -> FAImage? {
        let options = options ?? FashionEmptyOptionsInfo
        return Fashion<FAImage>.image(
            data: data,
            scale: options.scaleFactor,
            preloadAllAnimationData: options.preloadAllAnimationData,
            onlyFirstFrame: options.onlyLoadFirstFrame)
    }
}
