//
//  SignUpViewController.swift
//  udealio
//
//  Created by Kyle Noble on 12/1/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MobileCoreServices
import ImageIO
import Security

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let transitionManager = TransitionManager()
  
  @IBOutlet weak var innerView: UIView!
  @IBOutlet weak var backgroundImage: UIImageView!
  
  @IBOutlet weak var twitterLoginButton: UIButton!
  @IBOutlet weak var facebookLoginButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  
  @IBOutlet weak var addProfImageButton: UIButton!
  
  @IBOutlet weak var signupTitleLabel: UILabel!
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  
  var picker:UIImagePickerController? = UIImagePickerController()
  @IBOutlet weak var profilePicImageView: UIImageView!
  var profilePicImage: UIImage?
  
  var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
  var keyboardFrame: CGRect = CGRect.nullRect
  var keyboardIsShowing: Bool = false
  weak var activeTextField: UITextField?
  
  var usernameAnchor:CGFloat = 0.0
  var passwordAnchor:CGFloat = 0.0
  var emailAnchor:CGFloat = 0.0
  var photoAnchor:CGFloat = 0.0
  
  //var highestIncrease:CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    emailTextField.delegate = self
    
    usernameAnchor = self.usernameTextField.center.y - 18
    passwordAnchor = self.passwordTextField.center.y - 21
    emailAnchor = self.emailTextField.center.y - 24
    photoAnchor = self.addProfImageButton.center.y - 21
    
    
    var fields:[UITextField] = [usernameTextField!, passwordTextField!, emailTextField!]
    
    switch PhoneSize(rawValue: UIScreen.mainScreen().bounds.height)! {
    case .Four:
      self.backgroundImage.image = UIImage(named: "SignUp4S")
      self.signupTitleLabel.font = UIFont(name: "Alegreya Sans SC", size: 25.0)
      self.usernameTextField.font = UIFont(name: "Alegreya Sans", size: 18.0)
      self.passwordTextField.font = UIFont(name: "Alegreya Sans", size: 18.0)
      self.emailTextField.font = UIFont(name: "Alegreya Sans", size: 18.0)
      for field in fields {
        addBottomBorder(field, widthSize: 1.5)
      }
    case .Five:
      for field in fields {
        addBottomBorder(field, widthSize: 1.5)
      }
    case .SixPlus:
      for field in fields {
        addBottomBorder(field, widthSize: 2.2)
      }
    default:
      for field in fields {
        addBottomBorder(field, widthSize: 1.5)
      }
    }
    
    var twitter:UIImage = UIImage(named: "Twitter")!
    var facebook:UIImage = UIImage(named: "Facebook")!
    twitterLoginButton.setImage(twitter, forState: UIControlState.Normal)
    facebookLoginButton.setImage(facebook, forState: UIControlState.Normal)
    twitterLoginButton.backgroundColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
    facebookLoginButton.backgroundColor = UIColor(red:59/255, green:89/255, blue:152/255, alpha:1.0)
    
    var addProfImageIcon:UIImage = UIImage(named: "AddProfImage")!
    addProfImageButton.setImage(addProfImageIcon, forState: UIControlState.Normal)
    addProfImageButton.layer.borderWidth = 2.2
    addProfImageButton.layer.borderColor = UIColor.whiteColor().CGColor
    
    signupButton.layer.cornerRadius = 4.0
    facebookLoginButton.layer.cornerRadius = 4.0
    twitterLoginButton.layer.cornerRadius = 4.0
    
    addOneSidedRounding(self.twitterLoginButton, color: UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0), direction: "left")
    addOneSidedRounding(self.facebookLoginButton, color: UIColor(red:59/255, green:89/255, blue:152/255, alpha:1.0), direction: "right")
    
    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: attributesDictionary)
    passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
    emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
    
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
  
  //UI Functions
  
  func addBottomBorder(textField:UITextField, widthSize:CGFloat) {
    var border = CALayer()
    var width = widthSize
    border.borderColor = UIColor.whiteColor().CGColor
    border.frame = CGRect(x: 0, y: textField.bounds.size.height + 6.5, width: 400, height: textField.bounds.size.height)
    
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
    resetTextFieldPositions()
  }
  
  func arrangeViewOffsetFromKeyboard()
  {
    var theApp: UIApplication = UIApplication.sharedApplication()
    var windowView: UIView? = theApp.delegate!.window!
    var textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.center.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height + innerView.frame.origin.y)
    var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
    var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - textFieldLowerPoint.y
    
    if textFieldLowerPoint.y + kPreferredTextFieldToKeyboardOffset > self.keyboardFrame.origin.y {
      UIView.animateWithDuration(0.2, animations:  {
        self.usernameTextField.frame.origin.y -= (targetPointOffset * -1)
        self.passwordTextField.frame.origin.y -= (targetPointOffset * -1)
        self.emailTextField.frame.origin.y -= (targetPointOffset * -1)
        self.addProfImageButton.frame.origin.y -= (targetPointOffset * -1)
        if targetPointOffset < -10.0 {
          self.signupTitleLabel.hidden = true
        }
      })
    }
  }
  
  func returnViewToInitialFrame()
  {
    var initialViewRect: CGRect = CGRectMake(innerView.frame.origin.x, innerView.frame.origin.y, innerView.frame.size.width, innerView.frame.size.height)
    
    if (!CGRectEqualToRect(initialViewRect, innerView.frame))
    {
      UIView.animateWithDuration(0.2, animations: {
        self.innerView.frame = initialViewRect
        //self.resetTextFieldPositions()
      });
    }
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
    resetTextFieldPositions()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    
    if textField == self.usernameTextField {
      self.passwordTextField.becomeFirstResponder()
    }
    else if textField == self.passwordTextField {
      self.emailTextField.becomeFirstResponder()
    }
    else {
      textField.resignFirstResponder()
      resetTextFieldPositions()
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
  
  func resetTextFieldPositions() {
    self.signupTitleLabel.hidden = false
    UIView.animateWithDuration(0.2, animations:  {
      self.usernameTextField.center.y = self.usernameAnchor
      self.passwordTextField.center.y = self.passwordAnchor
      self.emailTextField.center.y = self.emailAnchor
      self.addProfImageButton.center.y = self.photoAnchor + 8
      self.profilePicImageView.center.y = self.photoAnchor + 8
    })
  }
  
  //Button Actions
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // this gets a reference to the screen that we're about to transition to
    let toViewController = segue.destinationViewController as UIViewController
    
    // instead of using the default transition animation, we'll ask
    // the segue to use our custom TransitionManager object to manage the transition animation
    toViewController.transitioningDelegate = self.transitionManager
    
  }
  
  
  @IBAction func addProfilePicButtonPressed(sender: UIButton) {
    
    var alert:UIAlertController=UIAlertController(title: "Add Profile Picture", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    var cameraAction = UIAlertAction(title: "Take Picture", style: UIAlertActionStyle.Default) {
      UIAlertAction in
      self.openCamera()
      
    }
    var gallaryAction = UIAlertAction(title: "Choose Picture", style: UIAlertActionStyle.Default) {
      UIAlertAction in
      self.openGallery()
    }
    var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
      UIAlertAction in
      
    }
    
    // Add the actions
    alert.addAction(cameraAction)
    alert.addAction(gallaryAction)
    alert.addAction(cancelAction)
    // Present the controller
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func openCamera() {
    
    if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
      picker!.sourceType = UIImagePickerControllerSourceType.Camera
      picker!.delegate = self
      self .presentViewController(picker!, animated: true, completion: nil)
    }
    else {
      openGallery()
    }
  }
  
  func openGallery() {
    
    if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
      picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      picker!.delegate = self
      self.presentViewController(picker!, animated: true, completion: nil)
    }
    else {
      var alertController = UIAlertController(title: "Alert", message: "Your device does not support a camera or photo library", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    
    let image = info[UIImagePickerControllerOriginalImage] as UIImage
    
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.25, 0.25))
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    
    self.profilePicImage = scaledImage
    
    //println(imageString)
    //println(data)
    println("working")
    
    profilePicImageView.hidden = false
    profilePicImageView.image = scaledImage
    profilePicImageView.layer.borderColor = UIColor.whiteColor().CGColor
    profilePicImageView.layer.borderWidth = 2
    addProfImageButton.hidden = true
    picker .dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
    picker .dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func signupButtonPressed(sender: UIButton) {
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    spinner.startAnimating()
    spinner.center = self.view.center
    self.view.addSubview(spinner)
    
    var msg = ""
    var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")

    var imageUrl: String!

    if let selectedImage =  self.profilePicImage {
      let bucketInfo = BucketInfo()
      let path = "api/v1/profile-pics/"
      let name = "\(NSUUID().UUIDString)"
      imageUrl = "https://udealio.s3-us-west-1.amazonaws.com/\(name)"
      bucketInfo.uploadImage(selectedImage, path: path, name: name) {
        imageObj, error in
        if error != nil {
      
        }
        println("Image done uploading. Error? \(error)")
        println("Image: \(imageObj.url)")
        println("Image: \(imageObj.key)")
      }
    }

    APIManager.sharedInstance.userSignUp(emailTextField.text, password: passwordTextField.text, profilePicUrl: imageUrl) { myJSON, error in
      

        if let code = myJSON?["state"]["code"] {
          if code == 0 {
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "userLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()

            let token = myJSON?["auth_token"].string
            let email = myJSON?["email"].string

            Locksmith.saveData(["email": "\(email)"], forUserAccount: "Email_Token", inService: "KeyChainService")
            Locksmith.saveData(["auth_token": "\(token)"], forUserAccount: "Auth_Token", inService: "KeyChainService")

            self.performSegueWithIdentifier("signupToOnboardingView", sender: nil)
          }
          else {
            spinner.stopAnimating()
            alert.title = "Error"
            alert.message = myJSON!["error"].string
            alert.show()
          }
        }
        else {
          spinner.stopAnimating()
          alert.title = "Error"
          alert.message = myJSON!["error"].string
          alert.show()
          
        }
      }

    }

  }
  

