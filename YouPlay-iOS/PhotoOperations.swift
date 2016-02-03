//
//  PhotoOperations.swift
//  YouPlay-iOS
//
//  Created by wujianguo on 16/1/5.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath: NSOperation]()
    lazy var downloadQueue: NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
//        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress = [NSIndexPath: NSOperation]()
    lazy var filtrationQueue: NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Image Filtration queue"
//        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class PhotoRecord {
    let url: NSURL
    let bounds: CGRect
    var image: UIImage?
    var color: UIColor?
    init(bounds: CGRect, url: NSURL) {
        self.bounds = bounds
        self.url = url
    }
}

class ImageDownloader: NSOperation {

    let photoRecord: PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        guard !cancelled else { return }

        if let img = Util.imageCache.objectForKey(photoRecord.url) as? UIImage {
            photoRecord.image = img
            return
        }
        let imageData = NSData(contentsOfURL: photoRecord.url)
        guard !cancelled && imageData?.length > 0 else { return }
        if let img = UIImage(data: imageData!) {
            Util.imageCache.setObject(img, forKey: photoRecord.url)
            photoRecord.image = img
        }
    }
}

class ImageFiltration: NSOperation {

    let photoRecord: PhotoRecord

    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main () {
        guard !cancelled else { return }
        
        if let image = photoRecord.image {
            photoRecord.color = image.darkEffectColor(photoRecord.bounds)
        }
    }
}

