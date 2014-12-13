//
//  TabViewController.swift
//  udealio
//
//  Created by Kyle Noble on 11/26/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let items = self.tabBar.items
        let item1:UITabBarItem = items![0] as UITabBarItem
        let item2:UITabBarItem = items![1] as UITabBarItem
        let item3:UITabBarItem = items![2] as UITabBarItem
        let item4:UITabBarItem = items![3] as UITabBarItem
        
        item1.selectedImage = UIImage(named: "HomeFill")
        item2.selectedImage = UIImage(named: "PFill")
        item3.selectedImage = UIImage(named: "DealFill")
        item4.selectedImage = UIImage(named: "MapFill")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        UIApplication.sharedApplication().statusBarHidden=false
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
