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