//
//  ImageView+Fashion.swift
//  Fashion

#if os(macOS)
import AppKit
#else
import UIKit
#endif

// MARK: - Extension methods.
/**
 *	Set image to use from web.
 */
extension Fashion where Base: ImageView {
    /**
     Set an image with a resource, a placeholder image, options, progress handler and completion handler.
     
     - parameter resource:          FAResource object contains information such as `cacheKey` and `downloadURL`.
     - parameter placeholder:       A placeholder image when retrieving the image at URL.
     - parameter options:           A dictionary could control some behaviors. See `FashionOptionsInfo` for more.
     - parameter progressBlock:     Called when the image downloading progress gets updated.
     - parameter completionHandler: Called when the image retrieved and set.
     
     - returns: A task represents the retrieving process.
     
     - note: Both the `progressBlock` and `completionHandler` will be invoked in main thread.
     The `CallbackDispatchQueue` specified in `optionsInfo` will not be used in callbacks of this method.
     
     If `resource` is `nil`, the `placeholder` image will be set and
     `completionHandler` will be called with both `error` and `image` being `nil`.
     */
    @discardableResult
    public func setImage(with resource: FAResource?,
                         placeholder: FAImage? = nil,
                         options: FashionOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        guard let resource = resource else {
            base.image = placeholder
            setWebURL(nil)
            completionHandler?(nil, nil, .none, nil)
            return .empty
        }
        
        var options = FashionManager.shared.defaultOptions + (options ?? FashionEmptyOptionsInfo)
        
        if !options.keepCurrentImageWhileLoading {
            base.image = placeholder
        }

        let maybeIndicator = indicator
        maybeIndicator?.startAnimatingView()
        
        setWebURL(resource.downloadURL)

        if base.shouldPreloadAllAnimation() {
            options.append(.preloadAllAnimationData)
        }
        
        let task = FashionManager.shared.retrieveImage(
            with: resource,
            options: options,
            progressBlock: { receivedSize, totalSize in
                guard resource.downloadURL == self.webURL else {
                    return
                }
                if let progressBlock = progressBlock {
                    progressBlock(receivedSize, totalSize)
                }
            },
            completionHandler: {[weak base] image, error, cacheType, imageURL in
                DispatchQueue.main.safeAsync {
                    guard let strongBase = base, imageURL == self.webURL else {
                        completionHandler?(image, error, cacheType, imageURL)
                        return
                    }
                    
                    self.setImageTask(nil)
                    guard let image = image else {
                        maybeIndicator?.stopAnimatingView()
                        completionHandler?(nil, error, cacheType, imageURL)
                        return
                    }
                    
                    guard let transitionItem = options.lastMatchIgnoringAssociatedValue(.transition(.none)),
                        case .transition(let transition) = transitionItem, ( options.forceTransition || cacheType == .none) else
                    {
                        maybeIndicator?.stopAnimatingView()
                        strongBase.image = image
                        completionHandler?(image, error, cacheType, imageURL)
                        return
                    }
                    
                    #if !os(macOS)
                        UIView.transition(with: strongBase, duration: 0.0, options: [],
                                          animations: { maybeIndicator?.stopAnimatingView() },
                                          completion: { _ in
                                            UIView.transition(with: strongBase, duration: transition.duration,
                                                              options: [transition.animationOptions, .allowUserInteraction],
                                                              animations: {
                                                                // Set image property in the animation.
                                                                transition.animations?(strongBase, image)
                                                              },
                                                              completion: { finished in
                                                                transition.completion?(finished)
                                                                completionHandler?(image, error, cacheType, imageURL)
                                                              })
                                          })
                    #endif
                }
            })
        
        setImageTask(task)
        
        return task
    }
    
    /**
     Cancel the image download task bounded to the image view if it is running.
     Nothing will happen if the downloading has already finished.
     */
    public func cancelDownloadTask() {
        imageTask?.cancel()
    }
}

// MARK: - Associated Object
private var lastURLKey: Void?
private var indicatorKey: Void?
private var indicatorTypeKey: Void?
private var imageTaskKey: Void?

extension Fashion where Base: ImageView {
    /// Get the image URL binded to this image view.
    public var webURL: URL? {
        return objc_getAssociatedObject(base, &lastURLKey) as? URL
    }
    
    fileprivate func setWebURL(_ url: URL?) {
        objc_setAssociatedObject(base, &lastURLKey, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// Holds which indicator type is going to be used.
    /// Default is .none, means no indicator will be shown.
    public var indicatorType: IndicatorType {
        get {
            let indicator = (objc_getAssociatedObject(base, &indicatorTypeKey) as? FABox<IndicatorType?>)?.value
            return indicator ?? .none
        }
        
        set {
            switch newValue {
            case .none:
                indicator = nil
            case .activity:
                indicator = ActivityIndicator()
            case .image(let data):
                indicator = ImageIndicator(imageData: data)
            case .custom(let anIndicator):
                indicator = anIndicator
            }
            
            objc_setAssociatedObject(base, &indicatorTypeKey, FABox(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Holds any type that conforms to the protocol `FAIndicator`.
    /// The protocol `FAIndicator` has a `view` property that will be shown when loading an image.
    /// It will be `nil` if `indicatorType` is `.none`.
    public fileprivate(set) var indicator: FAIndicator? {
        get {
            return (objc_getAssociatedObject(base, &indicatorKey) as? FABox<FAIndicator?>)?.value
        }
        
        set {
            // Remove previous
            if let previousIndicator = indicator {
                previousIndicator.view.removeFromSuperview()
            }
            
            // Add new
            if var newIndicator = newValue {
                newIndicator.view.frame = base.frame
                newIndicator.viewCenter = CGPoint(x: base.bounds.midX, y: base.bounds.midY)
                newIndicator.view.isHidden = true
                base.addSubview(newIndicator.view)
            }
            
            // Save in associated object
            objc_setAssociatedObject(base, &indicatorKey, FABox(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var imageTask: RetrieveImageTask? {
        return objc_getAssociatedObject(base, &imageTaskKey) as? RetrieveImageTask
    }
    
    fileprivate func setImageTask(_ task: RetrieveImageTask?) {
        objc_setAssociatedObject(base, &imageTaskKey, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


// MARK: - Deprecated. Only for back compatibility.
/**
*	Set image to use from web. Deprecated. Use `fa` namespacing instead.
*/
extension ImageView {
    /**
    Set an image with a resource, a placeholder image, options, progress handler and completion handler.
    
    - parameter resource:          FAResource object contains information such as `cacheKey` and `downloadURL`.
    - parameter placeholder:       A placeholder image when retrieving the image at URL.
    - parameter options:           A dictionary could control some behaviors. See `FashionOptionsInfo` for more.
    - parameter progressBlock:     Called when the image downloading progress gets updated.
    - parameter completionHandler: Called when the image retrieved and set.
    
    - returns: A task represents the retrieving process.
     
    - note: Both the `progressBlock` and `completionHandler` will be invoked in main thread. 
     The `CallbackDispatchQueue` specified in `optionsInfo` will not be used in callbacks of this method.
    */
    @available(*, deprecated, message: "Extensions directly on image views are deprecated. Use `imageView.fa.setImage` instead.", renamed: "fa.setImage")
    @discardableResult
    public func fa_setImage(with resource: FAResource?,
                              placeholder: FAImage? = nil,
                                  options: FashionOptionsInfo? = nil,
                            progressBlock: DownloadProgressBlock? = nil,
                        completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        return fa.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    /**
     Cancel the image download task bounded to the image view if it is running.
     Nothing will happen if the downloading has already finished.
     */
    @available(*, deprecated, message: "Extensions directly on image views are deprecated. Use `imageView.fa.cancelDownloadTask` instead.", renamed: "fa.cancelDownloadTask")
    public func fa_cancelDownloadTask() { fa.cancelDownloadTask() }
    
    /// Get the image URL binded to this image view.
    @available(*, deprecated, message: "Extensions directly on image views are deprecated. Use `imageView.fa.webURL` instead.", renamed: "fa.webURL")
    public var fa_webURL: URL? { return fa.webURL }
    
    /// Holds which indicator type is going to be used.
    /// Default is .none, means no indicator will be shown.
    @available(*, deprecated, message: "Extensions directly on image views are deprecated. Use `imageView.fa.indicatorType` instead.", renamed: "fa.indicatorType")
    public var fa_indicatorType: IndicatorType {
        get { return fa.indicatorType }
        set { fa.indicatorType = newValue }
    }
    
    @available(*, deprecated, message: "Extensions directly on image views are deprecated. Use `imageView.fa.indicator` instead.", renamed: "fa.indicator")
    /// Holds any type that conforms to the protocol `FAIndicator`.
    /// The protocol `FAIndicator` has a `view` property that will be shown when loading an image.
    /// It will be `nil` if `fa_indicatorType` is `.none`.
    public private(set) var fa_indicator: FAIndicator? {
        get { return fa.indicator }
        set { fa.indicator = newValue }
    }
    
    @available(*, deprecated, message: "Extensions directly on image views are deprecated.", renamed: "fa.imageTask")
    fileprivate var fa_imageTask: RetrieveImageTask? { return fa.imageTask }
    @available(*, deprecated, message: "Extensions directly on image views are deprecated.", renamed: "fa.setImageTask")
    fileprivate func fa_setImageTask(_ task: RetrieveImageTask?) { fa.setImageTask(task) }
    @available(*, deprecated, message: "Extensions directly on image views are deprecated.", renamed: "fa.setWebURL")
    fileprivate func fa_setWebURL(_ url: URL) { fa.setWebURL(url) }

    @objc func shouldPreloadAllAnimation() -> Bool { return true }

    @available(*, deprecated, renamed: "shouldPreloadAllAnimation")
    func shouldPreloadAllGIF() -> Bool { return true }
}
