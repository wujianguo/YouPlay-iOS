//
//  YouPlayItem.swift
//  YouPlay-iOS
//
//  Created by 吴建国 on 16/1/4.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import Alamofire

private var api = "https://youplay.leanapp.cn/api/v1"

struct YouPlayItem {
    var status = ""
    var rating = ""
    var thumb = ""
    var title = ""
    var detail = ""
    var actors = [String]()
}

struct YouPlaySource {
    var status = ""
    var site = ""
    var name = ""
    var icon = ""
    var urls = [String]()
    var titles = [String]()
}

struct YouPlayDetail {
    var status = ""
    var rating = ""
    var thumb = ""
    var title = ""
    var pub = ""
    var sum = ""
    var actors = [String]()

    var sources = [YouPlaySource]()
}

enum YouPlaychannel: Int, CustomStringConvertible {
    case Teleplay = 0
    case Anime
    
    var description: String {
        switch self {
        case .Teleplay:
            return "teleplaylist"
        case .Anime:
            return "animelist"
        }
    }
}

func queryItems(channel: YouPlaychannel, page: Int, complete: ([YouPlayItem], Bool) -> Void) {
    Alamofire.request(.GET, "\(api)/channel/\(channel)?page=\(page)").responseJSON { (data) -> Void in
        guard data.result.isSuccess && data.data != nil else {
            complete([], false)
            return
        }
        let json = JSON(data: data.data!)
        guard json["err"].int == 0 else {
            complete([], false)
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
                detail: item["detail"].stringValue,
                actors: actors
                ))
        }
        complete(l, true)
    }
}


func queryDetail(detailApi: String, complete: (YouPlayDetail?) -> Void) {
    Alamofire.request(.GET, "\(api)\(detailApi)").responseJSON { (data) -> Void in
        guard data.result.isSuccess && data.data != nil else {
            complete(nil)
            return
        }
        let json = JSON(data: data.data!)
        guard json["err"].int == 0 else {
            complete(nil)
            return
        }
        var detail = YouPlayDetail()
        detail.status = json["data"]["status"].stringValue
        detail.rating = json["data"]["rating"].stringValue
        detail.thumb = json["data"]["thumb"].stringValue
        detail.title = json["data"]["name"].stringValue
        detail.pub = json["data"]["pub"].stringValue
        detail.sum = json["data"]["sum"].stringValue
        for s in json["data"]["sources"].arrayValue {
            var source = YouPlaySource()
            source.status = s["status"].stringValue
            source.site = s["site"].stringValue
            source.name = s["name"].stringValue
            source.icon = s["icon"].stringValue
            for it in s["episodes"].arrayValue {
                source.urls.append(it["url"].stringValue)
                source.titles.append(it["title"].stringValue)
            }
            detail.sources.append(source)
        }
        complete(detail)
    }
}

extension String {
    /**
     Encode a String to Base64
     
     :returns:
     */
    func toBase64()->String {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
    }
    
}

func queryStreamUrls(url: String, complete: ([String]) -> Void) {
    Alamofire.request(.GET, "\(api)/videos2/\(url.toBase64())").responseJSON { (data) -> Void in
        guard data.result.isSuccess && data.data != nil else {
            complete([])
            return
        }
        var us = [String]()
        let json = JSON(data: data.data!)
        for u in json["entries"].arrayValue {
            us.append(u["url"].stringValue)
        }
        complete(us)
    }
}

