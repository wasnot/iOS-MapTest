//
//  TwitterAPI.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/05/13.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import Foundation
import TwitterKit

public class TwitterAPI {
    let baseURL = "https://api.twitter.com"
    let version = "/1.1"
    
    init() {
        
    }
    
    public class func getHomeTimeline(tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
        let api = TwitterAPI()
        var clientError: NSError?
        let path = "/statuses/home_timeline.json"
        let endpoint = api.baseURL + api.version + path
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: endpoint, parameters: nil, error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: {
                response, data, err in
                if err == nil {
                    var jsonError: NSError?
                    let json: AnyObject? =  NSJSONSerialization.JSONObjectWithData(data,
                        options: nil,
                        error: &jsonError)
                    if let jsonArray = json as? NSArray {
                        tweets(TWTRTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet])
                    }
                } else {
                    error(err)
                }
            })
        }
    }
    
    public class func getNearTimeline(tweets: [NSDictionary]->(), error: (NSError) -> (), lat: Float, lon: Float, within: Int) {
        let api = TwitterAPI()
        var clientError: NSError?
        let path = "/search/tweets.json"
        let endpoint = api.baseURL + api.version + path
        let params = ["geocode": "\(lat),\(lon),\(within)km"]
        
        //        let params = ["q": "test",
        //            "geocode": "\(lat),\(lon),25km"]
        //        let params = ["q": "test"]
        
        println("test \(Twitter.sharedInstance().APIClient)")
        if(true) {
            return
        }
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: endpoint, parameters: params, error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: {
                response, data, err in
                println("completion ")
                if err == nil {
                    var jsonError: NSError?
                    let json: AnyObject? =  NSJSONSerialization.JSONObjectWithData(data,
                        options: nil,
                        error: &jsonError)
                    //                    println("completion \(json)")
                    // Search APIは二階層
                    if let top = json as? NSDictionary {
                        //                        var list: [TWTRTweet] = []
                        //                        if let statuses = top["statuses"] as? NSArray {
                        //                            list = TWTRTweet.tweetsWithJSONArray(statuses as [AnyObject]) as! [TWTRTweet]
                        //                        }
                        var list: [NSDictionary] = []
                        if let statuses = top["statuses"] as? NSArray {
                            list = statuses as! [NSDictionary]
                        }
                        tweets(list)
                    }else if let jsonArray = json as? NSArray {
                        //                        tweets(TWTRTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet])
                    }
                } else {
                    error(err)
                }
            })
        }
    }
    
}
