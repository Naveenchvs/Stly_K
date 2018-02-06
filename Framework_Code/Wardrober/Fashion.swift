//
//  Fashion.swift
//  Fashion
//

import Foundation
import ImageIO

#if os(macOS)
    import AppKit
    public typealias FAImage = NSImage
    public typealias Color = NSColor
    public typealias ImageView = NSImageView
    typealias Button = NSButton
#else
    import UIKit
    public typealias FAImage = UIImage
    public typealias Color = UIColor
    #if !os(watchOS)
    public typealias ImageView = UIImageView
    typealias Button = UIButton
    #endif
#endif

public final class Fashion<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/**
 A type that has Fashion extensions.
 */
public protocol FashionCompatible {
    associatedtype CompatibleType
    var fa: CompatibleType { get }
}

public extension FashionCompatible {
    public var fa: Fashion<Self> {
        get { return Fashion(self) }
    }
}

extension FAImage: FashionCompatible { }
#if !os(watchOS)
extension ImageView: FashionCompatible { }
extension Button: FashionCompatible { }
#endif
