//
//  YouPlayItem.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/4.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import Alamofire

private var api = "https://youplay.avosapps.com/api/v1"

struct YouPlayItem {
    var status = ""
    var rating = ""
    var thumb = ""
    var title = ""
    var actors = [String]()
}


struct YouPlayDetail {
    
}

func queryItems(page: Int, complete: (items: [YouPlayItem]) -> Void) {
    Alamofire.request(.GET, "\(api)/channel/teleplaylist?page=\(page)").responseJSON { (data) -> Void in
        guard data.result.isSuccess && data.data != nil else {
            complete(items: [])
            return
        }
        let json = JSON(data: data.data!)
        guard json["err"].int == 0 else {
            complete(items: [])
            return
        }
        var l: [YouPlayItem] = []
        for item in json["data"].arrayValue {
            var actors = [String]()
            for actor in item["actors"].arrayValue {
                actors.append(actor.stringValue)
            }
            l.append(YouPlayItem(
                status: item["status"].stringValue,
                rating: item["rating"].stringValue,
                thumb: item["thumb"].stringValue,
                title: item["title"].stringValue,
                actors: actors
                ))
        }
        complete(items: l)
    }
}
