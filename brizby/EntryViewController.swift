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
  
  
  @IBOutlet weak var userLoginButton: UIButton!
  @IBOutlet weak var businessLoginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userLoginButton.layer.cornerRadius = 4.0
    businessLoginButton.layer.cornerRadius = 4.0
    
    userLoginButton.backgroundColor = UIColor(red: 0/255, green: 200/255, blue: 82/255, alpha: 1.0)
    businessLoginButton.backgroundColor = UIColor(red:52/255, green:152/255, blue:219/255, alpha:1.0)
    
    addOneSidedRounding(self.userLoginButton, color: UIColor(red: 0/255, green: 200/255, blue: 82/255, alpha: 1.0), direction: "left")
    addOneSidedRounding(self.businessLoginButton, color: UIColor(red:52/255, green:152/255, blue:219/255, alpha:1.0), direction: "right")
    
    // Do any additional setup after loading the view.
    if UIScreen.mainScreen().bounds.height == 480 {
      self.backgroundImage.image = UIImage(named: "EntryBG4S")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true);
    UIApplication.sharedApplication().statusBarHidden=true; // for status bar hide
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // this gets a reference to the screen that we're about to transition to
    let toViewController = segue.destinationViewController as UIViewController
    
    // instead of using the default transition animation, we'll ask
    // the segue to use our custom TransitionManager object to manage the transition animation
    toViewController.transitioningDelegate = self.transitionManager
    
  }
  
  func addOneSidedRounding(button:UIButton, color:UIColor, direction:String) {
    var newButton:CGRect
    var shapePath:UIBezierPath
    var xValue:CGFloat
    
    
    switch PhoneSize(rawValue: UIScreen.mainScreen().bounds.height)! {
    case .Six:
      xValue = button.bounds.size.width * 2 - 16
    case .SixPlus:
      xValue = button.bounds.size.width * 2 - 8
    default:
      xValue = button.bounds.size.width + 16
    }
    
    if direction == "left" {
      newButton = CGRect(x: xValue, y: 0, width: 20, height: 56)
      shapePath = UIBezierPath(roundedRect: newButton, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(0.0, 0.0))
    }
    else {
      newButton = CGRect(x: 0, y: 0, width: 20, height: 56)
      shapePath = UIBezierPath(roundedRect: newButton, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(0.0, 0.0))
    }
    
    var shapeLayer:CAShapeLayer = CAShapeLayer()
    shapeLayer.path = shapePath.CGPath
    shapeLayer.frame = newButton
    shapeLayer.fillColor = color.CGColor
    button.layer.addSublayer(shapeLayer)
  }
  
  @IBAction func loginButtonPressed(sender: UIButton) {
    self.performSegueWithIdentifier("entryToLogin", sender: nil)
  }
  
  @IBAction func businessLoginButtonPressed(sender: UIButton) {
    self.performSegueWithIdentifier("entryToBusinessLogin", sender: nil)
  }
}
