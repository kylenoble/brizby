//
//  Business.swift
//  udealio
//
//  Created by Kyle Noble on 12/7/14.
//  Copyright (c) 2014 udealio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



struct Business {
  enum Router: URLRequestConvertible {
    static let baseURLString = "http://www.udeal.io/api/v1"
    
    case SignIn(String, String)
    case SignOut()
    
    var URLRequest: NSURLRequest {
      let (path: String, parameters: [String: AnyObject], method: String) = {
        switch self {
        case .SignIn(let email, let password):
          let parameters = [
            "api_v1_business": [
              "email": "\(email)",
              "password": "\(password)"
            ]
          ]
          let method = "POST"
          return ("/businesses/sign_in.json", parameters, method)
        case .SignOut():
          let method = "DELETE"
          let parameters = ["users":[]]
          return ("/businesses/sign_out.json", parameters, method)
        }
        }()
      
      let URL = NSURL(string: Router.baseURLString)
      let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
      
      URLRequest.HTTPMethod = method
      URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      URLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
      
      if method == "DELETE" {
        println(authTokenSavedFromNSUserDefaults)
        println(emailSavedFromNSUserDefaults)
        URLRequest.setValue(authTokenSavedFromNSUserDefaults, forHTTPHeaderField: "X-User-Token")
        URLRequest.setValue(emailSavedFromNSUserDefaults, forHTTPHeaderField: "X-User-Email")
      }
      
      let encoding = Alamofire.ParameterEncoding.JSON
      return encoding.encode(URLRequest, parameters: parameters).0
    }
  }
  
}