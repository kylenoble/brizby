//
//  HTTPClient.swift
//  brizby
//
//  Created by Kyle Noble on 3/9/15.
//  Copyright (c) 2015 udealio. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class HTTPClient {

    init() {

    }

    //check here http://stackoverflow.com/questions/27390656/how-to-return-value-from-alamofire


    func request(url:String, parameters: [String:AnyObject], method: String, authRequired: Bool, completionHandler: (myJSON: SwiftyJSON.JSON?, error: NSError?) -> ()) -> () {
        let baseUrl = "http://api.brizby.localhost:3000/v1"
        let URL = NSURL(string: baseUrl)
        let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(url))

        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        //Method Needs to be All-Caps
        URLRequest.HTTPMethod = method
        let encoding = Alamofire.ParameterEncoding.JSON
        let httpRequest = encoding.encode(URLRequest, parameters: parameters).0

        if (authRequired != false) {
            var email_token: NSDictionary?
            var auth_token: NSDictionary?
            var email_error: NSError?
            var auth_error: NSError?

            var credential: NSURLCredential

            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.objectForKey("userLoggedIn") as Bool != false {
                (email_token, email_error) = Locksmith.loadDataForUserAccount("Email_Token", inService: "KeyChainService")
                (auth_token, auth_error) = Locksmith.loadDataForUserAccount("Auth_Token", inService: "KeyChainService")
            } else {
                email_token = ["key": "value"]
                auth_token = ["key": "value"]
            }

            if email_error == nil && auth_error == nil {
                credential = NSURLCredential(user: email_token!["email"] as String, password: auth_token!["auth_token"] as String, persistence: .ForSession)
            } else {
                println(email_error?)
                println(auth_error?)
                credential = NSURLCredential(user: "", password: "", persistence: .ForSession)
            }

            Alamofire.request(httpRequest)
                .authenticate(usingCredential: credential)
                .responseJSON {
                    (_, _, object, error) in

                    if object != nil {
                        let myJSON = SwiftyJSON.JSON(object!)
                        completionHandler(myJSON: myJSON, error: error)
                    } else {
                        let myJSON = SwiftyJSON.JSON("There is an unkown error\(error!)")
                        completionHandler(myJSON: myJSON, error: error)
                    }

            }

        } else {

            Alamofire.request(httpRequest).responseJSON {
                    (_, _, object, error) in

                    if object != nil {
                        let myJSON = SwiftyJSON.JSON(object!)
                        completionHandler(myJSON: myJSON, error: error)
                    } else {
                        let myJSON = SwiftyJSON.JSON("There is an unkown error\(error!)")
                        completionHandler(myJSON: myJSON, error: error)
                    }

            }

        }
    }

}
