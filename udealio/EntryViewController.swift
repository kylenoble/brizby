//
//  EntryViewController.swift
//  udealio
//
//  Created by Kyle Noble on 11/27/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIScreen.mainScreen().bounds.height == 480 {
            self.backgroundImage.image = UIImage(named: "EntryBG4S")
            println("true")
        }
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
