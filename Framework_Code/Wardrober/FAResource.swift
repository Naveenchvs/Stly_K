//
//  FAResource.swift
//  Fashion

import Foundation


/// `FAResource` protocol defines how to download and cache a resource from network.
public protocol FAResource {
    /// The key used in cache.
    var cacheKey: String { get }
    
    /// The target image URL.
    var downloadURL: URL { get }
}

/**
 ImageResource is a simple combination of `downloadURL` and `cacheKey`.
 
 When passed to image view set methods, Fashion will try to download the target 
 image from the `downloadURL`, and then store it with the `cacheKey` as the key in cache.
 */
public struct ImageResource: FAResource {
    /// The key used in cache.
    public let cacheKey: String
    
    /// The target image URL.
    public let downloadURL: URL
    
    /**
     Create a resource.
     
     - parameter downloadURL: The target image URL.
     - parameter cacheKey:    The cache key. If `nil`, Fashion will use the `absoluteString` of `downloadURL` as the key.
     
     - returns: A resource.
     */
    public init(downloadURL: URL, cacheKey: String? = nil) {
        self.downloadURL = downloadURL
        self.cacheKey = cacheKey ?? downloadURL.absoluteString
    }
}

/**
 URL conforms to `FAResource` in Fashion.
 The `absoluteString` of this URL is used as `cacheKey`. And the URL itself will be used as `downloadURL`.
 If you need customize the url and/or cache key, use `ImageResource` instead.
 */
extension URL: FAResource {
    public var cacheKey: String { return absoluteString }
    public var downloadURL: URL { return self }
}
