//
//  ClothingItem.swift
//  Fashion180
//
//  Created by Yogi on 01/11/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//


protocol ClothingItemImageViewDelegate {
    
    func clothingItemImageViewDidTap(_ clothingItemImgView : ClothingItemImageView)
    
}


class ClothingItemImageView : UIImageView, UIGestureRecognizerDelegate
{
    
    var clothingType : ClothingType!
    var imageName : String!
    
    var xPos : CGFloat!
    var yPos : CGFloat!
    var zPos : CGFloat!
    
    @IBOutlet var xConstraint : NSLayoutConstraint!
    @IBOutlet var yConstraint : NSLayoutConstraint!
    @IBOutlet var widhtConstraint : NSLayoutConstraint!
    @IBOutlet var heightConstraint : NSLayoutConstraint!
    
    var delegate : ClothingItemImageViewDelegate?
    
    
    var boundsView : UIView? = nil
    var xConstraintBoundsView : NSLayoutConstraint!
    var yConstraintBoundsView : NSLayoutConstraint!
    var widhtConstraintBoundsView : NSLayoutConstraint!
    var heightConstraintBoundsView : NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        let touchGestureRecogr = UITapGestureRecognizer(target: self, action: #selector(ClothingItemImageView.swipeDetectorViewTouched))
        
        self.addGestureRecognizer(touchGestureRecogr)
        
    }
    

    
    @objc func swipeDetectorViewTouched()
    {
        ///////print("swipeDetectorViewTouched")

        self.delegate?.clothingItemImageViewDidTap(self)
        
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if clothingType == ClothingType.top_SECONDARY || clothingType == ClothingType.bottom || clothingType == ClothingType.top_MAIN //|| clothingType == ClothingType.SHOES
        {
            if self.image == nil
            {
                return super.point(inside: point, with: event)
            }
            
            var act_P = CGPoint.zero
            let x_perc = point.x / self.bounds.size.width
            let y_perc = point.y / self.bounds.size.height
            act_P.x = x_perc * (self.image?.size.width)!
            act_P.y = y_perc * (self.image?.size.height)!
            
            let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 1)
            pixel.pointee = 0
            
            let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceGray()
            
            let context = CGContext(data: pixel,
                                                width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 1, space: colorSpace,
                                                bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue);
            UIGraphicsPushContext(context!);
            self.image?.draw(at: CGPoint(x: -act_P.x, y: -act_P.y))
            UIGraphicsPopContext();
            ///CGContextRelease(context);
            let alpha = Float(pixel.pointee)/255.0;
            let transparent = alpha < 0.01;
            

            return !transparent;
        }
        else
        {
            if self.image == nil
            {
                return super.point(inside: point, with: event)
            }
            //////print("this is earrings")
            
            if clothingType == ClothingType.earrings
            {
                let scaleMultiplier = CGFloat(3)
                let scaledWidth = scaleMultiplier * self.bounds.size.width
                let scaledHeight = scaleMultiplier * self.bounds.size.height
                let newOriginX = self.center.x - scaledWidth / CGFloat(2)
                let newOrignY = self.center.y - scaledHeight / CGFloat(2)
                
                
                let scaledFrame = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
                
                let pointX_wrt_ScaledFrame = self.frame.origin.x - newOriginX + point.x
                let pointY_writ_ScaledFrame = self.frame.origin.y - newOrignY + point.y
                
                let point_wrt_ScaledFrame = CGPoint(x: pointX_wrt_ScaledFrame, y: pointY_writ_ScaledFrame)
                
                if scaledFrame.contains(point_wrt_ScaledFrame)
                {
                    ///////print("contains point")
                    return true
                }

            }
            
            
            return super.point(inside: point, with: event)
        }
        
        
        
    }
    
    
    func setItemImage(_ image : UIImage)
    {
        self.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: { 
            
            self.image = image
            
            self.alpha = 1
        }) 
    }
    
    class func imageForImageUrl(url : String) -> UIImage?
    {
        ///print("imageForImageUrl \(url)")
        
        if let image = FAImageCache.default.retrieveImageInDiskCache(forKey: url)
        {
            let scaledImage = UIImage(cgImage: (image.cgImage)!, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
            
            return scaledImage
            
        }
        return nil
        
    }
    
    
}
