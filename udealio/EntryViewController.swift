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
    
    let transitionManager = TransitionManager()
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("entryToLogin", sender: nil)
    }

    @IBAction func tourButtonPressed(sender: UIButton) {
    }


}
