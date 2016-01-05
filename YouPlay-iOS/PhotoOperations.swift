//
//  PhotoOperations.swift
//  YouPlay-iOS
//
//  Created by wujianguo on 16/1/5.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class PhotoRecord {
    let name:String
    let url:NSURL
    var state = PhotoRecordState.New
    var originImage = UIImage()
    var filteredImage = UIImage()
    
    init(name:String, url:NSURL) {
        self.name = name
        self.url = url
    }
}

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress = [NSIndexPath:NSOperation]()
    lazy var filtrationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader: NSOperation {
    let photoRecord: PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        let imageData = NSData(contentsOfURL:self.photoRecord.url)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.photoRecord.originImage = UIImage(data:imageData!)
            self.photoRecord.state = .Downloaded
        }
        else
        {
            self.photoRecord.state = .Failed
        }
    }
}