//
//  OnboardingViewController.swift
//  udealio
//
//  Created by Kyle Noble on 12/8/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func getStartedButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("onboardingToHomeScreen", sender: nil)
    }
    

}
