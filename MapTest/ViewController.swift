//
//  ViewController.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/04/29.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Twitter.sharedInstance().logInWithCompletion {
            (session, error) -> Void in
            if (session != nil) {
                println("signed in as \(session.userName)");
                
                // ログイン成功したらクソ遷移する
//                let timelineVC = MapViewController()
//                UIApplication.sharedApplication().keyWindow?.rootViewController = timelineVC
                self.performSegueWithIdentifier("mapViewSegue", sender: nil)

            } else {
                println("error: \(error.localizedDescription)");
                let alertController = UIAlertController(title: ("Hello! " + session.userName), message: "This is Alert sample.", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

