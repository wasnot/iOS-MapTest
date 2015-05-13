//
//  MapInterfaceController.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/05/13.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import WatchKit
import Foundation
import MapKit


class MapInterfaceController: WKInterfaceController {
    
    var mapView: MKMapView?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        mapView = MKMapView(frame: CGRectMake(0, 0, 50, 50))
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
