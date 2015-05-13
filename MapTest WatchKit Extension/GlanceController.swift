//
//  GlanceController.swift
//  MapTest WatchKit Extension
//
//  Created by AidaAkihiro on 2015/05/13.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import WatchKit
import Foundation
import TwitterKit


class GlanceController: WKInterfaceController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: WKInterfaceMap!
    var locationManager : CLLocationManager?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        println("awakeWithContext")
        
        // Configure interface objects here.
        
        // locationManagerのデリゲートセット
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        println("didChangeAuthorizationStatus:\(status)");
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager?.requestAlwaysAuthorization()
        }
        // 取得精度の設定.
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        locationManager?.distanceFilter = 100
        locationManager?.startUpdatingLocation()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        println("willActivate")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        println("didDeactive")
    }
    
    func setAnnotation(lat: CLLocationDegrees, lon: CLLocationDegrees){
        TwitterAPI.getNearTimeline({
            twttrs in
            println("count \(twttrs.count)")
            for tweet :NSDictionary in twttrs {
                var t:TWTRTweet = TWTRTweet(JSONDictionary: tweet as [NSObject : AnyObject])
                var coordinates = tweet.valueForKey("coordinates")
                //                println("count \(t.retweetCount) \(coordinates)")
                if let a = coordinates as? NSDictionary {
                    var b = a.valueForKey("coordinates")
                    if let bb = b as? NSArray {
                        var cc = CLLocationCoordinate2DMake(bb[1] as! CLLocationDegrees, bb[0] as! CLLocationDegrees)
                        println("coordinates: \(cc.latitude) \(cc.longitude)")
                        self.setMapAnnotation(cc)
                    }
                }
                //                self.tweets.append(tweet)
            }
            },
            error: {
                error in
                println("error:\(error.localizedFailureReason)")
            },
            lat: Float(lat),
            lon: Float(lon),
            within: 25)
    }
    
    func setMap(lat: CLLocationDegrees, lon: CLLocationDegrees){
        // 中心点の緯度経度.
        //        let myLat: CLLocationDegrees = 37.506804
        //        let myLon: CLLocationDegrees = 139.930531
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon) as CLLocationCoordinate2D
        // 縮尺.
        let myLatDist : CLLocationDistance = 25000
        let myLonDist : CLLocationDistance = 25000
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        // MapViewに反映.
        self.mapView.setRegion(myRegion)
    }
    
    func setMapAnnotation(userLocation: CLLocationCoordinate2D){
//        var userLocAnnotation: MKPointAnnotation = MKPointAnnotation()
//        userLocAnnotation.coordinate = userLocation
//        userLocAnnotation.title = tweet.text
        self.mapView.addAnnotation(userLocation, withPinColor: WKInterfaceMapPinColor.Red)
        println("setMapAnnotation:\(userLocation.latitude),\(userLocation.longitude)")
    }
    
    // MARK: - CLLocationManagerDelegete
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        var userLocation = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude)
        println("locationManager:\(userLocation.latitude),\(userLocation.longitude)")
        //        setMapAnnotation(userLocation)
        
        setMap(userLocation.latitude, lon: userLocation.longitude)
        setAnnotation(userLocation.latitude, lon: userLocation.longitude)
        setMapAnnotation(userLocation)
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("locationManager error \(manager) \(error)")
    }
}
