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

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loginTitleLabel: UILabel!
    
    @IBOutlet weak var usernameTextInputField: UITextField!
    @IBOutlet weak var passwordTextInputField: UITextField!
    @IBOutlet weak var twitterLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    weak var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        usernameTextInputField.delegate = self
        passwordTextInputField.delegate = self
        
        switch PhoneSize(rawValue: UIScreen.mainScreen().bounds.height)! {
        case .Four:
            self.backgroundImage.image = UIImage(named: "LoginBG4S")
            self.loginTitleLabel.font = UIFont(name: "Alegreya Sans SC", size: 25.0)
            addBottomBorder(usernameTextInputField, widthSize: 8.5)
            addBottomBorder(passwordTextInputField, widthSize: 8.0)
        case .Five:
            addBottomBorder(usernameTextInputField, widthSize: 8.5)
            addBottomBorder(passwordTextInputField, widthSize: 8.0)
        case .SixPlus:
            addBottomBorder(usernameTextInputField, widthSize: 1.2)
            addBottomBorder(passwordTextInputField, widthSize: 1.2)
        default:
            addBottomBorder(usernameTextInputField, widthSize: 3.5)
            addBottomBorder(passwordTextInputField, widthSize: 3.5)
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
        var textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height)
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
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
    
    @IBAction func twitterLoginButtonPressed(sender: UIButton) {
        println("twitter")
    }
    
    
    @IBAction func facebookLoginButtonPressed(sender: UIButton) {
        println("facebook")
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
    }
    
    @IBAction func signUpButtonPressed(sender: UIButton) {
    }
    
    //UI Functions
    func addBottomBorder(textField:UITextField, widthSize:CGFloat) {
        
        var border = CALayer()
        var width = widthSize
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: textField.bounds.size.height - width, width: 400, height: textField.bounds.size.height)
        
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
            println(self.facebookLoginButton.bounds.size)
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
