//
//  User.swift
//  udealio
//
//  Created by Kyle Noble on 12/7/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let emailSavedFromNSUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey(kEmailKey) as String
let authTokenSavedFromNSUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey(kAuthTokenKey) as String

struct User {
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://www.udeal.io/api/v1"
        
        case SignUp(String, String, String)
        case SignIn(String, String)
        case SignOut(String, String)
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject], method: String) = {
                switch self {
                case .SignUp(let email, let password, let username):
                    let parameters = [
                    "user": [
                            "email": "\(email)",
                            "password": "\(password)",
                            "username": "\(username)"
                        ]
                    ]
                    let method = "POST"
                    return ("/users.json", parameters, method)
                case .SignIn(let username, let password):
                    let parameters = [
                        "api_v1_user": [
                            "username": "\(username)",
                            "password": "\(password)"
                        ]
                    ]
                    let method = "POST"
                    return ("/users/sign_in.json", parameters, method)
                case .SignOut(let email, let auth_token):
                    let method = "DELETE"
                    let parameters = ["users":[]]
                    return ("/users/sign_out.json", parameters, method)
                }
            }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            
            URLRequest.HTTPMethod = method
            URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            if method == "DELETE" {
                URLRequest.setValue(authTokenSavedFromNSUserDefaults, forHTTPHeaderField: "X-User-Token")
                URLRequest.setValue(emailSavedFromNSUserDefaults, forHTTPHeaderField: "X-User-Email")
            }
            
            let encoding = Alamofire.ParameterEncoding.JSON
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    
}