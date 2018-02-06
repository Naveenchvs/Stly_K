//
//  UIImage+UIImage_ContentBounds.swift
//  Fashion180
//
//  Created by Saraschandra on 13/06/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import Foundation

extension UIImage
{
    func trimmedImageFrame() -> CGRect
    {
        let inImage: CGImage? = cgImage
        var m_DataRef: CFData
        
        m_DataRef = inImage!.dataProvider!.data!
        
        let m_PixelBuf: UnsafePointer<UInt8> = CFDataGetBytePtr(m_DataRef)

        let width: size_t = inImage!.width
        let height: size_t = inImage!.height
        
        var top : CGPoint!
        var left : CGPoint!
        var right : CGPoint!
        var bottom : CGPoint!
        
        var breakOut: Bool = false
        for x in 0..<width
        {
            if breakOut == true
            {
                break
            }
            for y in 0..<height
            {
                var loc: Int = x + (y * width)
                loc *= 4
                if m_PixelBuf[loc + 3] != 0
                {
                    left = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    breakOut = true
                    break
                }
            }
        }
        
        breakOut = false
        for y in 0..<height
        {
            if breakOut == true
            {
              break
            }
            for x in 0..<width
            {
                var loc: Int = x + (y * width)
                loc *= 4
                if m_PixelBuf[loc + 3] != 0
                {
                    top = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    breakOut = true
                    break
                }
            }
        }
        
        breakOut = false
        var y = height - 1
        while breakOut == false && y >= 0
        {
            var x = width - 1
            while x >= 0
            {
                var loc: Int = x + (y * width)
                loc *= 4
                if m_PixelBuf[loc + 3] != 0
                {
                    bottom = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    breakOut = true
                    break
                }
                x -= 1
            }
            y -= 1
        }
        
        breakOut = false
        var x = width - 1
        while breakOut == false && x >= 0
        {
            var y = height - 1
            while y >= 0
            {
                var loc: Int = x + (y * width)
                loc *= 4
                if m_PixelBuf[loc + 3] != 0
                {
                    right = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    breakOut = true
                    break
                }
                y -= 1
            }
            x -= 1
        }
        let scale: CGFloat = self.scale
        
        var cropRect = CGRect()
        
        if (left != nil)  && (top != nil) && (right != nil) && (bottom != nil)
        {
             cropRect = CGRect(x: CGFloat(left.x / scale), y: CGFloat(top.y / scale), width: CGFloat((right.x - left.x) / scale), height: CGFloat((bottom.y - top.y) / scale))
            return cropRect
 
        }
        return cropRect
    }

    func crop(_ rect: CGRect) -> UIImage
    {
        let rect1 = CGRect(x: CGFloat(rect.origin.x * scale),
                      y: CGFloat(rect.origin.y * scale),
                      width: CGFloat(rect.size.width * scale),
                      height: CGFloat(rect.size.height * scale))
        
        let imageRef: CGImage? = cgImage?.cropping(to: rect1)
        
        let result = UIImage(cgImage: imageRef!,
                             scale: scale,
                             orientation: imageOrientation)
        
        return result
    }
    
}
