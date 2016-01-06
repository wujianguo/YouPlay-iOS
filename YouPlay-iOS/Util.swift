//
//  Util.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/5.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

class Util {
    static let imageCache = NSCache()

}

extension UIColor {
    
    class func themeColor() -> UIColor { return UIColor.whiteColor().colorWithAlphaComponent(0.5) }

    /**
     * Initializes and returns a color object for the given RGB hex integer.
     */
    public convenience init(rgb: Int) {
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: 1)
    }
    
    public convenience init(colorString: String) {
        var colorInt: UInt32 = 0
        NSScanner(string: colorString).scanHexInt(&colorInt)
        self.init(rgb: (Int) (colorInt ?? 0xaaaaaa))
    }
}


import Alamofire

extension UIImageView {
    class func requestImageWithUrlString(str: String?, complete: ((UIImage)->Void)? = nil) {
        if let url = NSURL(string: str ?? "") {
            requestImageWithUrl(url, complete: complete)
        }
    }
    
    class func requestImageWithUrl(url: NSURL, complete: ((UIImage)->Void)? = nil) {
        if let image = Util.imageCache.objectForKey(url) as? UIImage {
            complete?(image)
            return
        }
        Alamofire.request(.GET, url.absoluteString)
            .responseData { response in
                guard response.data != nil else { return }
                if let img = UIImage(data: response.data!) {
                    Util.imageCache.setObject(img, forKey: url)
                    complete?(img)
                }
        }
    }
    
    func setImageWithUrlString(str: String?, complete: ((UIImage)->Void)? = nil) {
        UIImageView.requestImageWithUrlString(str) { (image) -> Void in
            self.image = image
            complete?(image)
        }
    }
    
    func setImageWithURL(url: NSURL, complete: ((UIImage)->Void)? = nil) {
        UIImageView.requestImageWithUrl(url) { (image) -> Void in
            self.image = image
            complete?(image)
        }
    }
}

extension UIImage {
    
    func lightEffectImage(bounds: CGRect) -> UIImage {
        var img = self.applyLightEffectAtFrame(CGRectMake(0, 0, self.size.width, self.size.height))
        UIGraphicsBeginImageContext(bounds.size);
        img.drawInRect(bounds)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func darkEffectImage(bounds: CGRect) -> UIImage {
        var img = self.applyDarkEffectAtFrame(CGRectMake(0, 0, self.size.width, self.size.height))
        UIGraphicsBeginImageContext(bounds.size);
        img.drawInRect(bounds)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func lightEffectColor(bounds: CGRect) -> UIColor {
        let img = lightEffectImage(bounds)
        return UIColor(patternImage: img)
    }
    
    func darkEffectColor(bounds: CGRect) -> UIColor {
        let img = darkEffectImage(bounds)
        return UIColor(patternImage: img)
    }
}


extension UIView {
    
    func setBackgroundLightEffect(url: String) {
        let b = bounds
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            UIImageView.requestImageWithUrlString(url) { (image) -> Void in
                let color = image.lightEffectColor(b)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.backgroundColor = color
                }
            }
        }
    }
    
    func setBackgroundDarkEffect(url: String) {
        let b = bounds
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            UIImageView.requestImageWithUrlString(url) { (image) -> Void in
                let color = image.darkEffectColor(b)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.backgroundColor = color
                }
            }
        }
    }
    
}

