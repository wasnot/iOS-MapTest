//
//  MapViewController.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/05/11.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import TwitterKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var tweets: [TWTRTweet] = [] {
        didSet {
//            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    //1.経度、緯度からメルカトル図法の点に変換する
    //出発点：六本木　〜　目的地：渋谷
    var fromCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213, 139.730011)
    var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.658987, 139.702776)
    var locationManager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("didLoad: ", self)
        self.mapView.delegate = self
        
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
        
        
        //2.CLLocationCoordinate2DからMKPlacemarkを作成する
        var fromPlacemark = MKPlacemark(coordinate:fromCoordinate, addressDictionary:nil)
        var toPlacemark = MKPlacemark(coordinate:toCoordinate, addressDictionary:nil)
        
        //3.MKPlacemarkからMKMapItemを生成します。
        var fromItem = MKMapItem(placemark:fromPlacemark);
        var toItem = MKMapItem(placemark:toPlacemark);
        
        //4.MKMapItem をセットして MKDirectionsRequest を生成します
        let request = MKDirectionsRequest()
        request.setSource(fromItem)
        request.setDestination(toItem)
        request.requestsAlternateRoutes = true; //複数経路
        request.transportType = MKDirectionsTransportType.Walking //移動手段 Walking:徒歩/Automobile:車
        
        drawDirection(request)
//        setMap(37.506804,lon: 139.930531)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawDirection(request: MKDirectionsRequest){
        //5.経路を検索する(非同期で実行される)
        let directions = MKDirections(request:request)
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, error:NSError!) -> Void in
            println("calculated: ", response)
            if (error != nil || response.routes.isEmpty) {
                return
            }
            let route: MKRoute = response.routes[0] as! MKRoute
            println("calculated: ", route.polyline)
            self.mapView.addOverlay(route.polyline!)
        })
    }
    
    func setMap(lat: CLLocationDegrees, lon: CLLocationDegrees){
        // 中心点の緯度経度.
//        let myLat: CLLocationDegrees = 37.506804
//        let myLon: CLLocationDegrees = 139.930531
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon) as CLLocationCoordinate2D
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        // MapViewに反映.
        self.mapView.setRegion(myRegion, animated: true)
    }
    
    @IBAction func pushButton(sender: UIButton) {
        println("pushButton")
//        locationManager?.startUpdatingLocation()
        TwitterAPI.getNearTimeline({
            twttrs in
            println("count \(twttrs.count)")
            for tweet in twttrs {
//                self.tweets.append(tweet)
            }
            }, error: {
                error in
                println("error:\(error.localizedFailureReason)")
            }, lat: Float(mapView.region.center.latitude), lon: Float(mapView.region.center.longitude))
    }

    
    // MARK: - MKMapViewDelegate
    
    //6.経路検索のルート表示設定を行います
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
    
    // Regionが変更した時に呼び出されるメソッド.
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        println("regionDidChangeAnimated")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - CLLocationManagerDelegete
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        
        var userLocation = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude)
        
        var userLocAnnotation: MKPointAnnotation = MKPointAnnotation()
        userLocAnnotation.coordinate = userLocation
        userLocAnnotation.title = "現在地"
        mapView.addAnnotation(userLocAnnotation)
        println("locationManager:\(userLocation.latitude),\(userLocation.longitude)")
        
        setMap(userLocation.latitude, lon: userLocation.longitude)
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("locationManager error \(manager) \(error)")
    }

    

}
