//
//  FAIndicator.swift
//  Fashion
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

#if os(macOS)
    public typealias IndicatorView = NSView
#else
    public typealias IndicatorView = UIView
#endif

public enum IndicatorType {
    /// No indicator.
    case none
    /// Use system activity indicator.
    case activity
    /// Use an image as indicator. GIF is supported.
    case image(imageData: Data)
    /// Use a custom indicator, which conforms to the `FAIndicator` protocol.
    case custom(indicator: FAIndicator)
}

// MARK: - FAIndicator Protocol
public protocol FAIndicator {
    func startAnimatingView()
    func stopAnimatingView()

    var viewCenter: CGPoint { get set }
    var view: IndicatorView { get }
}

extension FAIndicator {
    #if os(macOS)
    public var viewCenter: CGPoint {
        get {
            let frame = view.frame
            return CGPoint(x: frame.origin.x + frame.size.width / 2.0, y: frame.origin.y + frame.size.height / 2.0 )
        }
        set {
            let frame = view.frame
            let newFrame = CGRect(x: newValue.x - frame.size.width / 2.0,
                                  y: newValue.y - frame.size.height / 2.0,
                                  width: frame.size.width,
                                  height: frame.size.height)
            view.frame = newFrame
        }
    }
    #else
    public var viewCenter: CGPoint {
        get {
            return view.center
        }
        set {
            view.center = newValue
        }
    }
    #endif
}

// MARK: - ActivityIndicator
// Displays a NSProgressIndicator / UIActivityIndicatorView
struct ActivityIndicator: FAIndicator {

    #if os(macOS)
    private let activityIndicatorView: NSProgressIndicator
    #else
    private let activityIndicatorView: UIActivityIndicatorView
    #endif

    var view: IndicatorView {
        return activityIndicatorView
    }

    func startAnimatingView() {
        #if os(macOS)
            activityIndicatorView.startAnimation(nil)
        #else
            activityIndicatorView.startAnimating()
        #endif
        activityIndicatorView.isHidden = false
    }

    func stopAnimatingView() {
        #if os(macOS)
            activityIndicatorView.stopAnimation(nil)
        #else
            activityIndicatorView.stopAnimating()
        #endif
        activityIndicatorView.isHidden = true
    }

    init() {
        #if os(macOS)
            activityIndicatorView = NSProgressIndicator(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            activityIndicatorView.controlSize = .small
            activityIndicatorView.style = .spinningStyle
        #else
            #if os(tvOS)
                let indicatorStyle = UIActivityIndicatorViewStyle.white
            #else
                let indicatorStyle = UIActivityIndicatorViewStyle.gray
            #endif
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:indicatorStyle)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        #endif
    }
}

// MARK: - ImageIndicator
// Displays an ImageView. Supports gif
struct ImageIndicator: FAIndicator {
    private let animatedImageIndicatorView: ImageView

    var view: IndicatorView {
        return animatedImageIndicatorView
    }

    init?(imageData data: Data, processor: FAImageProcessor = DefaultImageProcessor.default, options: FashionOptionsInfo = FashionEmptyOptionsInfo) {

        var options = options
        // Use normal image view to show animations, so we need to preload all animation data.
        if !options.preloadAllAnimationData {
            options.append(.preloadAllAnimationData)
        }
        
        guard let image = processor.process(item: .data(data), options: options) else {
            return nil
        }

        animatedImageIndicatorView = ImageView()
        animatedImageIndicatorView.image = image
        
        #if os(macOS)
            // Need for gif to animate on macOS
            self.animatedImageIndicatorView.imageScaling = .scaleNone
            self.animatedImageIndicatorView.canDrawSubviewsIntoLayer = true
        #else
            animatedImageIndicatorView.contentMode = .center
            
            animatedImageIndicatorView.autoresizingMask = [.flexibleLeftMargin,
                                                           .flexibleRightMargin,
                                                           .flexibleBottomMargin,
                                                           .flexibleTopMargin]
        #endif
    }

    func startAnimatingView() {
        #if os(macOS)
            animatedImageIndicatorView.animates = true
        #else
            animatedImageIndicatorView.startAnimating()
        #endif
        animatedImageIndicatorView.isHidden = false
    }

    func stopAnimatingView() {
        #if os(macOS)
            animatedImageIndicatorView.animates = false
        #else
            animatedImageIndicatorView.stopAnimating()
        #endif
        animatedImageIndicatorView.isHidden = true
    }
}
