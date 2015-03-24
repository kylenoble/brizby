//
//  ProfileViewController.swift
//  udealio
//
//  Created by Kyle Noble on 11/26/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import UIKit
import AlamoFire
import SwiftyJSON
import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let transitionManager = TransitionManager()
    var currentUserId: String = ""
    var currentUser: User = User()

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var userHomeCity: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        let tabView = self.tabBarController as TabViewController

        println(Defaults[kUserId].string)
        println(NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as Int)

        let currentUserId = NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as Int

        self.currentUser.userId = currentUserId


        println(currentUser.userId)
        getUserdata("\(currentUser.userId)")

        tableView.delegate = self
        tableView.dataSource = self

        self.headerImage.backgroundColor = UIColor.blackColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        UIApplication.sharedApplication().statusBarHidden=false
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }

    func getUserdata(userId: String) {
        var msg = ""
        var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")

        Alamofire.request(APIManager.Router.ReadUser(id: userId))
            .responseJSON { (_, _, JSON, error) in

            var myJSON: SwiftyJSON.JSON?

            if error == nil && JSON != nil {
                myJSON = SwiftyJSON.JSON(JSON!)
            } else {
                alert.title = "Error"
                alert.message = "\(error)"
                alert.show()
            }
            let name = myJSON?["name"].string
            let homeCity = myJSON?["home_city"].string
            let following = myJSON?["following"].int
            let followers = myJSON?["followers"].int
            let avatar = myJSON?["avatar"].string

            var avatarUrl:NSURL = NSURL(string: avatar!)!
            var err: NSError?
            var imageData :NSData = NSData(contentsOfURL:avatarUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!

            self.userHomeCity.text = homeCity
            self.followersButton.setTitle("Followers \(followers!)", forState: UIControlState.Normal)
            self.followingButton.setTitle("Following \(following!)", forState: UIControlState.Normal)
            self.navigationItem.title = name

            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                let avatarImageData = UIImage(data:imageData)
                dispatch_async(dispatch_get_main_queue()) {
                    self.avatarImage.image = self.maskRoundedImage(avatarImageData!, radius: 150.0)
                }
            }

        }

    }
    
    @IBAction func logOutButtonPressed(sender: UIButton) {
        var msg = ""
        var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")

        Alamofire.request(APIManager.Router.Logout())
            .responseJSON { (_, _, JSON, error) in

            var myJSON: SwiftyJSON.JSON?

            if error == nil && JSON != nil {
                myJSON = SwiftyJSON.JSON(JSON!)
            } else {
                alert.title = "Error"
                alert.message = "\(error)"
                alert.show()
            }

            if let message = myJSON?["message"] {
                if message == "Logged out successfully." {
                    self.performSegueWithIdentifier("logoutToLoginScreen", sender: nil)
                }
                else {
                    alert.title = "Error"
                    alert.message = myJSON!["error"].string
                    alert.show()
                }
            }
            else {
                alert.title = "Error"
                alert.message = myJSON!["error"].string
                alert.show()
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        var imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer

        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)

        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext())
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
