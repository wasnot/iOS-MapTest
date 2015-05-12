//
//  MapViewController.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/05/11.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //1.経度、緯度からメルカトル図法の点に変換する
    //出発点：六本木　〜　目的地：渋谷
    var fromCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213, 139.730011)
    var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.658987, 139.702776)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("didLoad: ", self)
        self.mapView.delegate = self
        
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
    
    //6.経路検索のルート表示設定を行います
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
