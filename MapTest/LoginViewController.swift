//
//  LoginViewController.swift
//  MapTest
//
//  Created by AidaAkihiro on 2015/05/02.
//  Copyright (c) 2015年 Wasnot Apps. All rights reserved.
//

import UIKit
import TwitterKit


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            // play with Twitter session
            if session != nil {
                println(session.userName)
                // ログイン成功したらクソ遷移する
                let timelineVC = TimelineViewController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = timelineVC
            } else {
                println(error.localizedDescription)
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
