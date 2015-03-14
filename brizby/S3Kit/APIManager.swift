//
//  APIManager.swift
//  brizby
//
//  Created by Kyle Noble on 3/9/15.
//  Copyright (c) 2015 udealio. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIManager: NSObject {

    private let httpClient: HTTPClient

    class var sharedInstance: APIManager {
        struct Singleton {
            static let instance = APIManager()
        }
        return Singleton.instance
    }

    override init() {
        httpClient = HTTPClient()

        super.init()
    }

    func userSignUp(email:String, password: String, profilePicUrl: String, completionHandler: (myJSON: SwiftyJSON.JSON?, error: NSError?) -> ())  {
        let parameters = [
            "api_v1_user": [
                "email": "\(email)",
                "password": "\(password)",
                "profile_pic_attributes": [
                    "image": "\(profilePicUrl)"
                ]
            ]
        ]

        httpClient.request("/users/sign_up.json", parameters: parameters, method: "POST", authRequired: false, completionHandler: completionHandler)
        
    }

    func signIn(email: String, password: String, type: String, completionHandler: (myJSON: SwiftyJSON.JSON?, error: NSError?) -> ()) {
        var urlEndpoint: String

        let parameters = [
            "api_v1_\(type)": [
                "email": "\(email)",
                "password": "\(password)"
            ]
        ]

        if type == "user" {
            urlEndpoint = "/users/sign_in.json"
        } else {
            urlEndpoint = "/businesses/sign_in.json"
        }

        httpClient.request(urlEndpoint, parameters: parameters, method: "POST", authRequired: false, completionHandler: completionHandler)
    }

    func signOut(type: String, completionHandler: (myJSON: SwiftyJSON.JSON?, error: NSError?) -> ()) {
        let parameters = ["":""]
        var urlEndpoint: String

        if type == "user" {
            urlEndpoint = "/users/sign_out.json"
        } else {
            urlEndpoint = "/businesses/sign_out.json"
        }
        httpClient.request(urlEndpoint, parameters: parameters, method: "DELETE", authRequired: true, completionHandler: completionHandler)

    }
}
