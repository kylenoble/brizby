//
//  LoginViewController.swift
//  udealio
//
//  Created by Kyle Noble on 11/28/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

enum PhoneSize: CGFloat {
  case Four = 480.0
  case Five = 568.0
  case Six = 667.0
  case SixPlus = 736.0
}

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var loginTitleLabel: UILabel!
  
  @IBOutlet weak var innerView: UIView!
  
  @IBOutlet weak var usernameTextInputField: UITextField!
  @IBOutlet weak var passwordTextInputField: UITextField!
  @IBOutlet weak var twitterLoginButton: UIButton!
  @IBOutlet weak var facebookLoginButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
  var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
  var keyboardFrame: CGRect = CGRect.nullRect
  var keyboardIsShowing: Bool = false
  weak var activeTextField: UITextField?
  
  let transitionManager = TransitionManager()
  
  var usernameAnchor:CGFloat = 0.0
  var passwordAnchor:CGFloat = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    usernameTextInputField.delegate = self
    passwordTextInputField.delegate = self
    
    usernameAnchor = self.usernameTextInputField.center.y - 18
    passwordAnchor = self.passwordTextInputField.center.y - 21
    
    switch PhoneSize(rawValue: UIScreen.mainScreen().bounds.height)! {
    case .Four:
      self.backgroundImage.image = UIImage(named: "LoginBG4S")
      self.loginTitleLabel.font = UIFont(name: "Alegreya Sans SC", size: 25.0)
      addBottomBorder(usernameTextInputField, widthSize: 5.5, yAdjust: 1.5)
      addBottomBorder(passwordTextInputField, widthSize: 5.0, yAdjust: 1.5)
      self.loginTitleLabel.font = UIFont(name: "Alegreya Sans SC", size: 25.0)
      self.usernameTextInputField.font = UIFont(name: "Alegreya Sans", size: 17.0)
      self.passwordTextInputField.font = UIFont(name: "Alegreya Sans", size: 17.0)
    case .Five:
      addBottomBorder(usernameTextInputField, widthSize: 2.5, yAdjust: 1.5)
      addBottomBorder(passwordTextInputField, widthSize: 2.0, yAdjust: 1.5)
    case .SixPlus:
      addBottomBorder(usernameTextInputField, widthSize: 2.0, yAdjust: 8.5)
      addBottomBorder(passwordTextInputField, widthSize: 2.0, yAdjust: 10.5)
    default:
      addBottomBorder(usernameTextInputField, widthSize: 2.5, yAdjust: 6.5)
      addBottomBorder(passwordTextInputField, widthSize: 2.5, yAdjust: 6.5)
    }
    
    var twitter:UIImage = UIImage(named: "Twitter")!
    var facebook:UIImage = UIImage(named: "Facebook")!
    twitterLoginButton.setImage(twitter, forState: UIControlState.Normal)
    facebookLoginButton.setImage(facebook, forState: UIControlState.Normal)
    twitterLoginButton.backgroundColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
    facebookLoginButton.backgroundColor = UIColor(red:59/255, green:89/255, blue:152/255, alpha:1.0)
    
    
    loginButton.layer.cornerRadius = 4.0
    facebookLoginButton.layer.cornerRadius = 4.0
    twitterLoginButton.layer.cornerRadius = 4.0
    
    addOneSidedRounding(self.twitterLoginButton, color: UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0), direction: "left")
    addOneSidedRounding(self.facebookLoginButton, color: UIColor(red:59/255, green:89/255, blue:152/255, alpha:1.0), direction: "right")
    
    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    usernameTextInputField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: attributesDictionary)
    passwordTextInputField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    for subview in self.view.subviews {
      if (subview.isKindOfClass(UITextField)) {
        var textField = subview as UITextField
        textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        
        textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
        
      }
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
  
  //Keyboard Functions
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func keyboardWillShow(notification: NSNotification)
  {
    self.keyboardIsShowing = true
    if let info = notification.userInfo {
      self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey]! as NSValue).CGRectValue()
      self.arrangeViewOffsetFromKeyboard()
    }
    
  }
  
  func keyboardWillHide(notification: NSNotification)
  {
    self.keyboardIsShowing = false
    
    self.returnViewToInitialFrame()
  }
  
  func arrangeViewOffsetFromKeyboard()
  {
    var theApp: UIApplication = UIApplication.sharedApplication()
    var windowView: UIView? = theApp.delegate!.window!
    var textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height + innerView.frame.origin.y)
    var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
    var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - textFieldLowerPoint.y
    if textFieldLowerPoint.y + kPreferredTextFieldToKeyboardOffset > self.keyboardFrame.origin.y {
      UIView.animateWithDuration(0.2, animations:  {
        self.usernameTextInputField.frame.origin.y -= (targetPointOffset * -1)
        self.passwordTextInputField.frame.origin.y -= (targetPointOffset * -1)
      })
    }
  }
  
  func returnViewToInitialFrame()
  {
    UIView.animateWithDuration(0.2, animations:  {
      self.usernameTextInputField.center.y = self.usernameAnchor
      self.passwordTextInputField.center.y = self.passwordAnchor
    })
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
  {
    if (self.activeTextField != nil)
    {
      self.activeTextField?.resignFirstResponder()
      self.activeTextField = nil
    }
  }
  
  @IBAction func textFieldDidReturn(textField: UITextField!)
  {
    textField.resignFirstResponder()
    self.activeTextField = nil
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == self.passwordTextInputField {
      textField.resignFirstResponder()
    }
    else if textField == self.usernameTextInputField {
      self.passwordTextInputField.becomeFirstResponder()
    }
    return true
  }
  
  @IBAction func textFieldDidBeginEditing(sender: UITextField) {
    self.activeTextField = sender
    if(self.keyboardIsShowing)
    {
      self.arrangeViewOffsetFromKeyboard()
    }
  }
  
  //Button Actions
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // this gets a reference to the screen that we're about to transition to
    let toViewController = segue.destinationViewController as UIViewController
    
    // instead of using the default transition animation, we'll ask
    // the segue to use our custom TransitionManager object to manage the transition animation
    toViewController.transitioningDelegate = self.transitionManager
    
  }
  
  @IBAction func twitterLoginButtonPressed(sender: UIButton) {
  }
  
  
  @IBAction func facebookLoginButtonPressed(sender: UIButton) {
  }
  
  @IBAction func loginButtonPressed(sender: UIButton) {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    spinner.startAnimating()
    spinner.center = self.view.center
    self.view.addSubview(spinner)
    
    var msg = ""
    
    var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")

    APIManager.sharedInstance.userSignIn(usernameTextInputField.text, password: passwordTextInputField.text) { myJSON, error in

        if let message = myJSON?["message"] {
            if message == "Logged in" {
              
              let token = myJSON?["auth_token"].string
              let email = myJSON?["email"].string
              
              Locksmith.saveData(["email": "\(email)"], forUserAccount: "Email_Token", inService: "KeyChainService")
              Locksmith.saveData(["auth_token": "\(token)"], forUserAccount: "Auth_Token", inService: "KeyChainService")

              self.performSegueWithIdentifier("loginToHomeView", sender: nil)
            }
            else {
              spinner.stopAnimating()
              alert.title = "Error"
              alert.message = myJSON?["error"].string
              alert.show()
            }
          }
          else {
            alert.title = "Error"

            if myJSON?["error"] != nil {
                alert.message = myJSON?["error"].string
            } else {
                alert.message = "Uknown error occured"
            }

            alert.show()
            spinner.stopAnimating()
          }
        }
  }


  @IBAction func signUpButtonPressed(sender: UIButton) {
    self.performSegueWithIdentifier("loginToSignUp", sender: nil)
  }
  
  @IBAction func forgotPasswordButtonPressed(sender: UIButton) {
  }
  
  //UI Functions
  
  func addBottomBorder(textField:UITextField, widthSize:CGFloat, yAdjust:CGFloat) {
    
    var border = CALayer()
    var width = widthSize
    border.borderColor = UIColor.whiteColor().CGColor
    border.frame = CGRect(x: 0, y: textField.bounds.size.height + yAdjust, width: 400, height: textField.bounds.size.height)
    
    border.borderWidth = width
    textField.layer.addSublayer(border)
    textField.layer.masksToBounds = true
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
      newButton = CGRect(x: xValue, y: 0, width: 20, height: 40)
      shapePath = UIBezierPath(roundedRect: newButton, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(0.0, 0.0))
    }
    else {
      newButton = CGRect(x: 0, y: 0, width: 20, height: 40)
      shapePath = UIBezierPath(roundedRect: newButton, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(0.0, 0.0))
    }
    
    var shapeLayer:CAShapeLayer = CAShapeLayer()
    shapeLayer.path = shapePath.CGPath
    shapeLayer.frame = newButton
    shapeLayer.fillColor = color.CGColor
    button.layer.addSublayer(shapeLayer)
  }
  
}
