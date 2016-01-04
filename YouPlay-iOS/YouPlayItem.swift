//
//  YouPlayItem.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/4.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import Alamofire

private var api = "https://youplay.avosapps.com/api/v1/"

struct YouPlayItem {
    var status = ""
    var rating = ""
    var thumb = ""
    var title = ""
}

func queryItems(page: Int, complete: (items: [YouPlayItem]) -> Void) {
    Alamofire.request(.GET, "\(api)/channel/teleplaylist?page=\(page)").responseJSON { (data) -> Void in
        guard data.result.isSuccess && data.data != nil else {
            complete(items: [])
            return
        }
        let json = JSON(data: data.data!)
        guard json["err"].int == 0 && json["data"].array != nil else {
            complete(items: [])
            return
        }
        var l: [YouPlayItem] = []
        for item in json["data"].array! {
            l.append(YouPlayItem(
                status: item["status"].stringValue,
                rating: item["rating"].stringValue,
                thumb: item["thumb"].stringValue,
                title: item["title"].stringValue
                ))
        }
        complete(items: l)
    }
}

extension UIImageView {
    func setImageWithUrlString(str: String?) {
        if let url = NSURL(string: str ?? "") {
            setImageWithURL(url)
        }
    }
    
    func setImageWithURL(url: NSURL) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if data != nil {
                    self.image = UIImage(data: data!)
                }
            }
            }.resume()
    }
}
