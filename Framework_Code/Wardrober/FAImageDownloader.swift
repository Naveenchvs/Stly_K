//
//  FAImageDownloader.swift
//  Fashion


#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Progress update block of downloader.
public typealias ImageDownloaderProgressBlock = DownloadProgressBlock

/// Completion block of downloader.
public typealias ImageDownloaderCompletionHandler = ((_ image: FAImage?, _ error: NSError?, _ url: URL?, _ originalData: Data?) -> ())

/// Download task.
public struct RetrieveImageDownloadTask {
    let internalTask: URLSessionDataTask
    
    /// Downloader by which this task is intialized.
    public private(set) weak var ownerDownloader: FAImageDownloader?

    /**
     Cancel this download task. It will trigger the completion handler with an NSURLErrorCancelled error.
     */
    public func cancel() {
        ownerDownloader?.cancelDownloadingTask(self)
    }
    
    /// The original request URL of this download task.
    public var url: URL? {
        return internalTask.originalRequest?.url
    }
    
    /// The relative priority of this download task. 
    /// It represents the `priority` property of the internal `NSURLSessionTask` of this download task.
    /// The value for it is between 0.0~1.0. Default priority is value of 0.5.
    /// See documentation on `priority` of `NSURLSessionTask` for more about it.
    public var priority: Float {
        get {
            return internalTask.priority
        }
        set {
            internalTask.priority = newValue
        }
    }
}

///The code of errors which `FAImageDownloader` might encountered.
public enum FashionError: Int {
    
    /// badData: The downloaded data is not an image or the data is corrupted.
    case badData = 10000
    
    /// notModified: The remote server responsed a 304 code. No image data downloaded.
    case notModified = 10001
    
    /// The HTTP status code in response is not valid. If an invalid
    /// code error received, you could check the value under `FashionErrorStatusCodeKey` 
    /// in `userInfo` to see the code.
    case invalidStatusCode = 10002
    
    /// notCached: The image rquested is not in cache but .onlyFromCache is activated.
    case notCached = 10003
    
    /// The URL is invalid.
    case invalidURL = 20000
    
    /// The downloading task is cancelled before started.
    case downloadCancelledBeforeStarting = 30000
}

/// Key will be used in the `userInfo` of `.invalidStatusCode`
public let FashionErrorStatusCodeKey = "statusCode"

/// Protocol of `FAImageDownloader`.
public protocol ImageDownloaderDelegate: class {
    /**
    Called when the `FAImageDownloader` object successfully downloaded an image from specified URL.
    
    - parameter downloader: The `FAImageDownloader` object finishes the downloading.
    - parameter image:      Downloaded image.
    - parameter url:        URL of the original request URL.
    - parameter response:   The response object of the downloading process.
    */
    func imageDownloader(_ downloader: FAImageDownloader, didDownload image: FAImage, for url: URL, with response: URLResponse?)
    
    /**
    Called when the `FAImageDownloader` object starts to download an image from specified URL.
     
    - parameter downloader: The `FAImageDownloader` object starts the downloading.
    - parameter url:        URL of the original request.
    - parameter response:   The request object of the downloading process.
    */
    func imageDownloader(_ downloader: FAImageDownloader, willDownloadImageForURL url: URL, with request: URLRequest?)
    
    /**
    Check if a received HTTP status code is valid or not. 
    By default, a status code between 200 to 400 (excluded) is considered as valid.
    If an invalid code is received, the downloader will raise an .invalidStatusCode error.
    It has a `userInfo` which includes this statusCode and localizedString error message.
     
    - parameter code: The received HTTP status code.
    - parameter downloader: The `FAImageDownloader` object asking for validate status code.
     
    - returns: Whether this HTTP status code is valid or not.
     
    - Note: If the default 200 to 400 valid code does not suit your need, 
            you can implement this method to change that behavior.
    */
    func isValidStatusCode(_ code: Int, for downloader: FAImageDownloader) -> Bool
}

extension ImageDownloaderDelegate {
    public func imageDownloader(_ downloader: FAImageDownloader, didDownload image: FAImage, for url: URL, with response: URLResponse?) {}
    
    public func imageDownloader(_ downloader: FAImageDownloader, willDownloadImageForURL url: URL, with request: URLRequest?) {}
    public func isValidStatusCode(_ code: Int, for downloader: FAImageDownloader) -> Bool {
        return (200..<400).contains(code)
    }
}

/// Protocol indicates that an authentication challenge could be handled.
public protocol AuthenticationChallengeResponsable: class {
    /**
     Called when an session level authentication challenge is received.
     This method provide a chance to handle and response to the authentication challenge before downloading could start.
     
     - parameter downloader:        The downloader which receives this challenge.
     - parameter challenge:         An object that contains the request for authentication.
     - parameter completionHandler: A handler that your delegate method must call.
     
     - Note: This method is a forward from `URLSession(:didReceiveChallenge:completionHandler:)`. Please refer to the document of it in `NSURLSessionDelegate`.
     */
    func downloader(_ downloader: FAImageDownloader, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
}

extension AuthenticationChallengeResponsable {
    
    func downloader(_ downloader: FAImageDownloader, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trustedHosts = downloader.trustedHosts, trustedHosts.contains(challenge.protectionSpace.host) {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
                return
            }
        }
        
        completionHandler(.performDefaultHandling, nil)
    }
}

/// `FAImageDownloader` represents a downloading manager for requesting the image with a URL from server.
open class FAImageDownloader {
    
    class ImageFetchLoad {
        var contents = [(callback: CallbackPair, options: FashionOptionsInfo)]()
        var responseData = NSMutableData()

        var downloadTaskCount = 0
        var downloadTask: RetrieveImageDownloadTask?
    }
    
    // MARK: - Public property
    /// The duration before the download is timeout. Default is 15 seconds.
    open var downloadTimeout: TimeInterval = 15.0
    
    /// A set of trusted hosts when receiving server trust challenges. A challenge with host name contained in this set will be ignored. 
    /// You can use this set to specify the self-signed site. It only will be used if you don't specify the `authenticationChallengeResponder`. 
    /// If `authenticationChallengeResponder` is set, this property will be ignored and the implemention of `authenticationChallengeResponder` will be used instead.
    open var trustedHosts: Set<String>?
    
    /// Use this to set supply a configuration for the downloader. By default, NSURLSessionConfiguration.ephemeralSessionConfiguration() will be used. 
    /// You could change the configuration before a downloaing task starts. A configuration without persistent storage for caches is requsted for downloader working correctly.
    open var sessionConfiguration = URLSessionConfiguration.ephemeral {
        didSet {
            session?.invalidateAndCancel()
            session = URLSession(configuration: sessionConfiguration, delegate: sessionHandler, delegateQueue: OperationQueue.main)
        }
    }
    
    /// Whether the download requests should use pipeling or not. Default is false.
    open var requestsUsePipelining = false
    
    fileprivate let sessionHandler: ImageDownloaderSessionHandler
    fileprivate var session: URLSession?
    
    /// Delegate of this `FAImageDownloader` object. See `ImageDownloaderDelegate` protocol for more.
    open weak var delegate: ImageDownloaderDelegate?
    
    /// A responder for authentication challenge. 
    /// Downloader will forward the received authentication challenge for the downloading session to this responder.
    open weak var authenticationChallengeResponder: AuthenticationChallengeResponsable?
    
    // MARK: - Internal property
    let barrierQueue: DispatchQueue
    let processQueue: DispatchQueue
    
    typealias CallbackPair = (progressBlock: ImageDownloaderProgressBlock?, completionHandler: ImageDownloaderCompletionHandler?)
    
    var fetchLoads = [URL: ImageFetchLoad]()
    
    // MARK: - Public method
    /// The default downloader.
    public static let `default` = FAImageDownloader(name: "default")
    
    /**
    Init a downloader with name.
    
    - parameter name: The name for the downloader. It should not be empty.
    
    - returns: The downloader object.
    */
    public init(name: String) {
        if name.isEmpty {
            fatalError("[Fashion] You should specify a name for the downloader. A downloader with empty name is not permitted.")
        }
        
        barrierQueue = DispatchQueue(label: "com.onevcat.Fashion.FAImageDownloader.Barrier.\(name)", attributes: .concurrent)
        processQueue = DispatchQueue(label: "com.onevcat.Fashion.FAImageDownloader.Process.\(name)", attributes: .concurrent)
        
        sessionHandler = ImageDownloaderSessionHandler()

        // Provide a default implement for challenge responder.
        authenticationChallengeResponder = sessionHandler
        session = URLSession(configuration: sessionConfiguration, delegate: sessionHandler, delegateQueue: .main)
    }
    
    deinit {
        session?.invalidateAndCancel()
    }
    
    func fetchLoad(for url: URL) -> ImageFetchLoad? {
        var fetchLoad: ImageFetchLoad?
        barrierQueue.sync { fetchLoad = fetchLoads[url] }
        return fetchLoad
    }
    
    /**
     Download an image with a URL and option.
     
     - parameter url:               Target URL.
     - parameter retrieveImageTask: The task to cooporate with cache. Pass `nil` if you are not trying to use downloader and cache.
     - parameter options:           The options could control download behavior. See `FashionOptionsInfo`.
     - parameter progressBlock:     Called when the download progress updated.
     - parameter completionHandler: Called when the download progress finishes.
     
     - returns: A downloading task. You could call `cancel` on it to stop the downloading process.
     */
    @discardableResult
    open func downloadImage(with url: URL,
                       retrieveImageTask: RetrieveImageTask? = nil,
                       options: FashionOptionsInfo? = nil,
                       progressBlock: ImageDownloaderProgressBlock? = nil,
                       completionHandler: ImageDownloaderCompletionHandler? = nil) -> RetrieveImageDownloadTask?
    {
        if let retrieveImageTask = retrieveImageTask, retrieveImageTask.cancelledBeforeDownloadStarting {
            completionHandler?(nil, NSError(domain: FashionErrorDomain, code: FashionError.downloadCancelledBeforeStarting.rawValue, userInfo: nil), nil, nil)
            return nil
        }
        
        let timeout = self.downloadTimeout == 0.0 ? 15.0 : self.downloadTimeout
        
        // We need to set the URL as the load key. So before setup progress, we need to ask the `requestModifier` for a final URL.
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        request.httpShouldUsePipelining = requestsUsePipelining

        if let modifier = options?.modifier {
            guard let r = modifier.modified(for: request) else {
                completionHandler?(nil, NSError(domain: FashionErrorDomain, code: FashionError.downloadCancelledBeforeStarting.rawValue, userInfo: nil), nil, nil)
                return nil
            }
            request = r
        }
        
        // There is a possiblility that request modifier changed the url to `nil` or empty.
        guard let url = request.url, !url.absoluteString.isEmpty else {
            completionHandler?(nil, NSError(domain: FashionErrorDomain, code: FashionError.invalidURL.rawValue, userInfo: nil), nil, nil)
            return nil
        }
        
        var downloadTask: RetrieveImageDownloadTask?
        setup(progressBlock: progressBlock, with: completionHandler, for: url, options: options) {(session, fetchLoad) -> Void in
            if fetchLoad.downloadTask == nil {
                let dataTask = session.dataTask(with: request)
                
                fetchLoad.downloadTask = RetrieveImageDownloadTask(internalTask: dataTask, ownerDownloader: self)
                
                dataTask.priority = options?.downloadPriority ?? URLSessionTask.defaultPriority
                dataTask.resume()
                delegate?.imageDownloader(self, willDownloadImageForURL: url, with: request)
                
                // Hold self while the task is executing.
                self.sessionHandler.downloadHolder = self
            }
            
            fetchLoad.downloadTaskCount += 1
            downloadTask = fetchLoad.downloadTask
            
            retrieveImageTask?.downloadTask = downloadTask
        }
        return downloadTask
    }
    
}

// MARK: - Download method
extension FAImageDownloader {
    
    // A single key may have multiple callbacks. Only download once.
    func setup(progressBlock: ImageDownloaderProgressBlock?, with completionHandler: ImageDownloaderCompletionHandler?, for url: URL, options: FashionOptionsInfo?, started: ((URLSession, ImageFetchLoad) -> Void)) {

        barrierQueue.sync(flags: .barrier) {
            let loadObjectForURL = fetchLoads[url] ?? ImageFetchLoad()
            let callbackPair = (progressBlock: progressBlock, completionHandler: completionHandler)
            
            loadObjectForURL.contents.append((callbackPair, options ?? FashionEmptyOptionsInfo))
            
            fetchLoads[url] = loadObjectForURL
            
            if let session = session {
                started(session, loadObjectForURL)
            }
        }
    }
    
    func cancelDownloadingTask(_ task: RetrieveImageDownloadTask) {
        barrierQueue.sync {
            if let URL = task.internalTask.originalRequest?.url, let imageFetchLoad = self.fetchLoads[URL] {
                imageFetchLoad.downloadTaskCount -= 1
                if imageFetchLoad.downloadTaskCount == 0 {
                    task.internalTask.cancel()
                }
            }
        }
    }
    
    func clean(for url: URL) {
        barrierQueue.sync(flags: .barrier) {
            fetchLoads.removeValue(forKey: url)
            return
        }
    }
}

// MARK: - NSURLSessionDataDelegate

/// Delegate class for `NSURLSessionTaskDelegate`.
/// The session object will hold its delegate until it gets invalidated.
/// If we use `FAImageDownloader` as the session delegate, it will not be released.
/// So we need an additional handler to break the retain cycle.
// See https://github.com/onevcat/Fashion/issues/235
class ImageDownloaderSessionHandler: NSObject, URLSessionDataDelegate, AuthenticationChallengeResponsable {
    
    // The holder will keep downloader not released while a data task is being executed.
    // It will be set when the task started, and reset when the task finished.
    var downloadHolder: FAImageDownloader?
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        guard let downloader = downloadHolder else {
            completionHandler(.cancel)
            return
        }
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
           let url = dataTask.originalRequest?.url,
            !(downloader.delegate ?? downloader).isValidStatusCode(statusCode, for: downloader)
        {
            let error = NSError(domain: FashionErrorDomain,
                                code: FashionError.invalidStatusCode.rawValue,
                                userInfo: [FashionErrorStatusCodeKey: statusCode, NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: statusCode)])
            callCompletionHandlerFailure(error: error, url: url)
        }
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        guard let downloader = downloadHolder else {
            return
        }

        if let url = dataTask.originalRequest?.url, let fetchLoad = downloader.fetchLoad(for: url) {
            fetchLoad.responseData.append(data)
            
            if let expectedLength = dataTask.response?.expectedContentLength {
                for content in fetchLoad.contents {
                    DispatchQueue.main.async {
                        content.callback.progressBlock?(Int64(fetchLoad.responseData.length), expectedLength)
                    }
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard let url = task.originalRequest?.url else {
            return
        }
        
        guard error == nil else {
            callCompletionHandlerFailure(error: error!, url: url)
            return
        }
        
        processImage(for: task, url: url)
    }
    
    /**
    This method is exposed since the compiler requests. Do not call it.
    */
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let downloader = downloadHolder else {
            return
        }
        
        downloader.authenticationChallengeResponder?.downloader(downloader, didReceive: challenge, completionHandler: completionHandler)
    }
    
    private func cleanFetchLoad(for url: URL) {
        guard let downloader = downloadHolder else {
            return
        }
        
        downloader.clean(for: url)
        
        if downloader.fetchLoads.isEmpty {
            downloadHolder = nil
        }
    }
    
    private func callCompletionHandlerFailure(error: Error, url: URL) {
        guard let downloader = downloadHolder, let fetchLoad = downloader.fetchLoad(for: url) else {
            return
        }
        
        // We need to clean the fetch load first, before actually calling completion handler.
        cleanFetchLoad(for: url)
        
        for content in fetchLoad.contents {
            content.options.callbackDispatchQueue.safeAsync {
                content.callback.completionHandler?(nil, error as NSError, url, nil)
            }
        }
    }
    
    private func processImage(for task: URLSessionTask, url: URL) {

        guard let downloader = downloadHolder else {
            return
        }
        
        // We are on main queue when receiving this.
        downloader.processQueue.async {
            
            guard let fetchLoad = downloader.fetchLoad(for: url) else {
                return
            }
            
            self.cleanFetchLoad(for: url)
            
            let data = fetchLoad.responseData as Data
            
            // Cache the processed images. So we do not need to re-process the image if using the same processor.
            // Key is the identifier of processor.
            var imageCache: [String: FAImage] = [:]
            for content in fetchLoad.contents {
                
                let options = content.options
                let completionHandler = content.callback.completionHandler
                let callbackQueue = options.callbackDispatchQueue
                
                let processor = options.processor
                
                var image = imageCache[processor.identifier]
                if image == nil {
                    image = processor.process(item: .data(data), options: options)
                    
                    // Add the processed image to cache. 
                    // If `image` is nil, nothing will happen (since the key is not existing before).
                    imageCache[processor.identifier] = image
                }
                
                if let image = image {
                    
                    downloader.delegate?.imageDownloader(downloader, didDownload: image, for: url, with: task.response)
                    
                    if options.backgroundDecode {
                        let decodedImage = image.fa.decoded(scale: options.scaleFactor)
                        callbackQueue.safeAsync { completionHandler?(decodedImage, nil, url, data) }
                    } else {
                        callbackQueue.safeAsync { completionHandler?(image, nil, url, data) }
                    }
                    
                } else {
                    if let res = task.response as? HTTPURLResponse , res.statusCode == 304 {
                        let notModified = NSError(domain: FashionErrorDomain, code: FashionError.notModified.rawValue, userInfo: nil)
                        completionHandler?(nil, notModified, url, nil)
                        continue
                    }
                    
                    let badData = NSError(domain: FashionErrorDomain, code: FashionError.badData.rawValue, userInfo: nil)
                    callbackQueue.safeAsync { completionHandler?(nil, badData, url, nil) }
                }
            }
        }
    }
}

// Placeholder. For retrieving extension methods of ImageDownloaderDelegate
extension FAImageDownloader: ImageDownloaderDelegate {}

// MARK: - Deprecated
extension FAImageDownloader {
    @available(*, deprecated, message: "`requestsUsePipeling` is deprecated. Use `requestsUsePipelining` instead", renamed: "requestsUsePipelining")
    open var requestsUsePipeling: Bool {
        get { return requestsUsePipelining }
        set { requestsUsePipelining = newValue }
    }
}
