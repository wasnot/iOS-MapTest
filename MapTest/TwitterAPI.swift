//
//  TwitterAPI.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/05/02.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterAPI {
    let baseURL = "https://api.twitter.com"
    let version = "/1.1"
    
    init() {
        
    }
    
    class func getHomeTimeline(tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
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
    
    class func getNearTimeline(tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
        let api = TwitterAPI()
        var clientError: NSError?
        let path = "/search/tweets.json"
        let endpoint = api.baseURL + api.version + path
        let params = ["id": "20"]
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

}
