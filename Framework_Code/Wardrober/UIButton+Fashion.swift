//
//  UIButton+Fashion.swift
//  Fashion
//

import UIKit

// MARK: - Set Images
/**
 *	Set image to use in button from web for a specified state.
 */
extension Fashion where Base: UIButton {
    /**
     Set an image to use for a specified state with a resource, a placeholder image, options, progress handler and
     completion handler.
     
     - parameter resource:          FAResource object contains information such as `cacheKey` and `downloadURL`.
     - parameter state:             The state that uses the specified image.
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
                         for state: UIControlState,
                         placeholder: UIImage? = nil,
                         options: FashionOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        guard let resource = resource else {
            base.setImage(placeholder, for: state)
            setWebURL(nil, for: state)
            completionHandler?(nil, nil, .none, nil)
            return .empty
        }
        
        let options = FashionManager.shared.defaultOptions + (options ?? FashionEmptyOptionsInfo)
        if !options.keepCurrentImageWhileLoading {
            base.setImage(placeholder, for: state)
        }
        
        setWebURL(resource.downloadURL, for: state)
        let task = FashionManager.shared.retrieveImage(
            with: resource,
            options: options,
            progressBlock: { receivedSize, totalSize in
                guard resource.downloadURL == self.webURL(for: state) else {
                    return
                }
                if let progressBlock = progressBlock {
                    progressBlock(receivedSize, totalSize)
                }
            },
            completionHandler: {[weak base] image, error, cacheType, imageURL in
                DispatchQueue.main.safeAsync {
                    guard let strongBase = base, imageURL == self.webURL(for: state) else {
                        completionHandler?(image, error, cacheType, imageURL)
                        return
                    }
                    self.setImageTask(nil)
                    if image != nil {
                        strongBase.setImage(image, for: state)
                    }

                    completionHandler?(image, error, cacheType, imageURL)
                }
            })
        
        setImageTask(task)
        return task
    }
    
    /**
     Cancel the image download task bounded to the image view if it is running.
     Nothing will happen if the downloading has already finished.
     */
    public func cancelImageDownloadTask() {
        imageTask?.cancel()
    }
    
    /**
     Set the background image to use for a specified state with a resource,
     a placeholder image, options progress handler and completion handler.
     
     - parameter resource:          FAResource object contains information such as `cacheKey` and `downloadURL`.
     - parameter state:             The state that uses the specified image.
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
    public func setBackgroundImage(with resource: FAResource?,
                                   for state: UIControlState,
                                   placeholder: UIImage? = nil,
                                   options: FashionOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        guard let resource = resource else {
            base.setBackgroundImage(placeholder, for: state)
            setBackgroundWebURL(nil, for: state)
            completionHandler?(nil, nil, .none, nil)
            return .empty
        }
        
        let options = FashionManager.shared.defaultOptions + (options ?? FashionEmptyOptionsInfo)
        if !options.keepCurrentImageWhileLoading {
            base.setBackgroundImage(placeholder, for: state)
        }
        
        setBackgroundWebURL(resource.downloadURL, for: state)
        let task = FashionManager.shared.retrieveImage(
            with: resource,
            options: options,
            progressBlock: { receivedSize, totalSize in
                guard resource.downloadURL == self.backgroundWebURL(for: state) else {
                    return
                }
                if let progressBlock = progressBlock {
                    progressBlock(receivedSize, totalSize)
                }
            },
            completionHandler: { [weak base] image, error, cacheType, imageURL in
                DispatchQueue.main.safeAsync {
                    guard let strongBase = base, imageURL == self.backgroundWebURL(for: state) else {
                        completionHandler?(image, error, cacheType, imageURL)
                        return
                    }
                    self.setBackgroundImageTask(nil)
                    if image != nil {
                        strongBase.setBackgroundImage(image, for: state)
                    }
                    completionHandler?(image, error, cacheType, imageURL)
                }
            })
        
        setBackgroundImageTask(task)
        return task
    }
    
    /**
     Cancel the background image download task bounded to the image view if it is running.
     Nothing will happen if the downloading has already finished.
     */
    public func cancelBackgroundImageDownloadTask() {
        backgroundImageTask?.cancel()
    }

}

// MARK: - Associated Object
private var lastURLKey: Void?
private var imageTaskKey: Void?

extension Fashion where Base: UIButton {
    /**
     Get the image URL binded to this button for a specified state.
     
     - parameter state: The state that uses the specified image.
     
     - returns: Current URL for image.
     */
    public func webURL(for state: UIControlState) -> URL? {
        return webURLs[NSNumber(value:state.rawValue)] as? URL
    }
    
    fileprivate func setWebURL(_ url: URL?, for state: UIControlState) {
        webURLs[NSNumber(value:state.rawValue)] = url
    }
    
    fileprivate var webURLs: NSMutableDictionary {
        var dictionary = objc_getAssociatedObject(base, &lastURLKey) as? NSMutableDictionary
        if dictionary == nil {
            dictionary = NSMutableDictionary()
            setWebURLs(dictionary!)
        }
        return dictionary!
    }
    
    fileprivate func setWebURLs(_ URLs: NSMutableDictionary) {
        objc_setAssociatedObject(base, &lastURLKey, URLs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate var imageTask: RetrieveImageTask? {
        return objc_getAssociatedObject(base, &imageTaskKey) as? RetrieveImageTask
    }
    
    fileprivate func setImageTask(_ task: RetrieveImageTask?) {
        objc_setAssociatedObject(base, &imageTaskKey, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


private var lastBackgroundURLKey: Void?
private var backgroundImageTaskKey: Void?


extension Fashion where Base: UIButton {
    /**
     Get the background image URL binded to this button for a specified state.
     
     - parameter state: The state that uses the specified background image.
     
     - returns: Current URL for background image.
     */
    public func backgroundWebURL(for state: UIControlState) -> URL? {
        return backgroundWebURLs[NSNumber(value:state.rawValue)] as? URL
    }
    
    fileprivate func setBackgroundWebURL(_ url: URL?, for state: UIControlState) {
        backgroundWebURLs[NSNumber(value:state.rawValue)] = url
    }
    
    fileprivate var backgroundWebURLs: NSMutableDictionary {
        var dictionary = objc_getAssociatedObject(base, &lastBackgroundURLKey) as? NSMutableDictionary
        if dictionary == nil {
            dictionary = NSMutableDictionary()
            setBackgroundWebURLs(dictionary!)
        }
        return dictionary!
    }
    
    fileprivate func setBackgroundWebURLs(_ URLs: NSMutableDictionary) {
        objc_setAssociatedObject(base, &lastBackgroundURLKey, URLs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate var backgroundImageTask: RetrieveImageTask? {
        return objc_getAssociatedObject(base, &backgroundImageTaskKey) as? RetrieveImageTask
    }
    
    fileprivate func setBackgroundImageTask(_ task: RetrieveImageTask?) {
        objc_setAssociatedObject(base, &backgroundImageTaskKey, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - Deprecated. Only for back compatibility.
/**
*	Set image to use from web for a specified state. Deprecated. Use `fa` namespacing instead.
*/
extension UIButton {
    /**
    Set an image to use for a specified state with a resource, a placeholder image, options, progress handler and 
     completion handler.
    
    - parameter resource:          FAResource object contains information such as `cacheKey` and `downloadURL`.
    - parameter state:             The state that uses the specified image.
    - parameter placeholder:       A placeholder image when retrieving the image at URL.
    - parameter options:           A dictionary could control some behaviors. See `FashionOptionsInfo` for more.
    - parameter progressBlock:     Called when the image downloading progress gets updated.
    - parameter completionHandler: Called when the image retrieved and set.
    
    - returns: A task represents the retrieving process.
     
    - note: Both the `progressBlock` and `completionHandler` will be invoked in main thread.
     The `CallbackDispatchQueue` specified in `optionsInfo` will not be used in callbacks of this method.
    */
    @discardableResult
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated. Use `button.fa.setImage` instead.",
    renamed: "fa.setImage")
    public func fa_setImage(with resource: FAResource?,
                                for state: UIControlState,
                              placeholder: UIImage? = nil,
                                  options: FashionOptionsInfo? = nil,
                            progressBlock: DownloadProgressBlock? = nil,
                        completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        return fa.setImage(with: resource, for: state, placeholder: placeholder, options: options,
                              progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    /**
     Cancel the image download task bounded to the image view if it is running.
     Nothing will happen if the downloading has already finished.
     */
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated. Use `button.fa.cancelImageDownloadTask` instead.",
    renamed: "fa.cancelImageDownloadTask")
    public func fa_cancelImageDownloadTask() { fa.cancelImageDownloadTask() }
    
    /**
     Set the background image to use for a specified state with a resource,
     a placeholder image, options progress handler and completion handler.
     
     - parameter resource:          FAResource object contains information such as `cacheKey` and `downloadURL`.
     - parameter state:             The state that uses the specified image.
     - parameter placeholder:       A placeholder image when retrieving the image at URL.
     - parameter options:           A dictionary could control some behaviors. See `FashionOptionsInfo` for more.
     - parameter progressBlock:     Called when the image downloading progress gets updated.
     - parameter completionHandler: Called when the image retrieved and set.
     
     - returns: A task represents the retrieving process.
     
     - note: Both the `progressBlock` and `completionHandler` will be invoked in main thread.
     The `CallbackDispatchQueue` specified in `optionsInfo` will not be used in callbacks of this method.
     */
    @discardableResult
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated. Use `button.fa.setBackgroundImage` instead.",
    renamed: "fa.setBackgroundImage")
    public func fa_setBackgroundImage(with resource: FAResource?,
                                      for state: UIControlState,
                                      placeholder: UIImage? = nil,
                                      options: FashionOptionsInfo? = nil,
                                      progressBlock: DownloadProgressBlock? = nil,
                                      completionHandler: CompletionHandler? = nil) -> RetrieveImageTask
    {
        return fa.setBackgroundImage(with: resource, for: state, placeholder: placeholder, options: options,
                                     progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    /**
     Cancel the background image download task bounded to the image view if it is running.
     Nothing will happen if the downloading has already finished.
     */
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated. Use `button.fa.cancelBackgroundImageDownloadTask` instead.",
    renamed: "fa.cancelBackgroundImageDownloadTask")
    public func fa_cancelBackgroundImageDownloadTask() { fa.cancelBackgroundImageDownloadTask() }
    
    /**
     Get the image URL binded to this button for a specified state.
     
     - parameter state: The state that uses the specified image.
     
     - returns: Current URL for image.
     */
    @available(*, deprecated,
        message: "Extensions directly on UIButton are deprecated. Use `button.fa.webURL` instead.",
        renamed: "fa.webURL")
    public func fa_webURL(for state: UIControlState) -> URL? { return fa.webURL(for: state) }
    
    @available(*, deprecated, message: "Extensions directly on UIButton are deprecated.",renamed: "fa.setWebURL")
    fileprivate func fa_setWebURL(_ url: URL, for state: UIControlState) { fa.setWebURL(url, for: state) }
    
    @available(*, deprecated, message: "Extensions directly on UIButton are deprecated.",renamed: "fa.webURLs")
    fileprivate var fa_webURLs: NSMutableDictionary { return fa.webURLs }
    
    @available(*, deprecated, message: "Extensions directly on UIButton are deprecated.",renamed: "fa.setWebURLs")
    fileprivate func fa_setWebURLs(_ URLs: NSMutableDictionary) { fa.setWebURLs(URLs) }
    
    @available(*, deprecated, message: "Extensions directly on UIButton are deprecated.",renamed: "fa.imageTask")
    fileprivate var fa_imageTask: RetrieveImageTask? { return fa.imageTask }
    
    @available(*, deprecated, message: "Extensions directly on UIButton are deprecated.",renamed: "fa.setImageTask")
    fileprivate func fa_setImageTask(_ task: RetrieveImageTask?) { fa.setImageTask(task) }
    
    /**
     Get the background image URL binded to this button for a specified state.
     
     - parameter state: The state that uses the specified background image.
     
     - returns: Current URL for background image.
     */
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated. Use `button.fa.backgroundWebURL` instead.",
    renamed: "fa.backgroundWebURL")
    public func fa_backgroundWebURL(for state: UIControlState) -> URL? { return fa.backgroundWebURL(for: state) }
    
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated.",renamed: "fa.setBackgroundWebURL")
    fileprivate func fa_setBackgroundWebURL(_ url: URL, for state: UIControlState) {
        fa.setBackgroundWebURL(url, for: state)
    }
    
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated.",renamed: "fa.backgroundWebURLs")
    fileprivate var fa_backgroundWebURLs: NSMutableDictionary { return fa.backgroundWebURLs }
    
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated.",renamed: "fa.setBackgroundWebURLs")
    fileprivate func fa_setBackgroundWebURLs(_ URLs: NSMutableDictionary) { fa.setBackgroundWebURLs(URLs) }
    
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated.",renamed: "fa.backgroundImageTask")
    fileprivate var fa_backgroundImageTask: RetrieveImageTask? { return fa.backgroundImageTask }
    
    @available(*, deprecated,
    message: "Extensions directly on UIButton are deprecated.",renamed: "fa.setBackgroundImageTask")
    fileprivate func fa_setBackgroundImageTask(_ task: RetrieveImageTask?) { return fa.setBackgroundImageTask(task) }
    
}
