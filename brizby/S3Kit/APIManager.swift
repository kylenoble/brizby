//
//  APIManager.swift
//  brizby
//
//  Created by Kyle Noble on 3/9/15.
//  Copyright (c) 2015 udealio. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class APIManager: NSObject {

    class var sharedInstance: APIManager {
        struct Singleton {
            static let instance = APIManager()
        }
        return Singleton.instance
    }

    override init() {

    }

    enum Router: URLRequestConvertible {
        static let baseURLString = "http://api.brizby.localhost:3000/v1"
        static let perPage = 50
        static var AuthToken: String?
        static var Email: String?

        case Login(params: [String: AnyObject])
        case Logout()

        case CreateUser(params: [String: AnyObject])
        case ReadUser(id:  String)
        case UpdateUser(id: String, params: [String: AnyObject])
        case DestroyUser(id: String)

        case ReadBusiness(id:  String)
        case UpdateBusiness(id: String, params: [String: AnyObject])
        case DestroyBusiness(id: String)

        case CreateDeal(params: [String: AnyObject])
        case ReadDeal(id:  String)
        case UpdateDeal(id: String, params: [String: AnyObject])
        case DestroyDeal(id: String)
        case GetDeals(businessId: String, page: Int)

        case CreatePost(params: [String: AnyObject])
        case ReadPost(id:  String)
        case UpdatePost(id: String, params: [String: AnyObject])
        case DestroyPost(id: String)
        case GetPosts(type: String, typeId: String, page: Int)

        case Follow(params: [String: AnyObject])
        case UnFollow(params: [String: AnyObject])
        case GetFollowers(userType: String, userTypeId: String, type:String, page: Int)
        case GetFollowing(userType: String, userTypeId: String, type:String, page: Int)

        case Love(params: [String: AnyObject])
        case UnLove(params: [String: AnyObject])
        case GetLovers(item_type: String, itemId: String, page: Int)

        case CreateComment(params: [String: AnyObject])
        case GetComments(item: String, itemId: String, page: Int)

        case GetFeedLocal(lat: String, lon: String, distance:String, type:String, category:String, page: Int)
        case GetFeedGlobal(type:String, category:String, page: Int)
        case GetFeedFollowing(category:String, page: Int)

        case Search(query: String, page: Int)

        var method: Alamofire.Method {
            switch self {
            case .Login, .CreateUser, .CreateDeal, .CreatePost, .Follow, .Love, .CreateComment:
                return .POST
            case .ReadUser, .ReadBusiness, .ReadDeal, .GetDeals, .ReadPost, .GetPosts, .GetFollowers, .GetFollowing, .GetLovers, .GetComments, .GetFeedLocal, .GetFeedFollowing, .GetFeedGlobal, .Search:
                return .GET
            case .UpdateUser, .UpdateBusiness, .UpdateDeal, .UpdatePost:
                return .PUT
            case .Logout, .DestroyUser, .DestroyBusiness, .DestroyDeal, .DestroyPost, .UnFollow, .UnLove:
                return .DELETE
            }
        }

        var urlPath: String {
            switch self {
            case .Search(_, _):
                return "/search"
            case .Login(_):
                return "/users/sign_in"
            case .Logout():
                return "/users/sign_out"
            case .CreateUser:
                return "/users"
            case .ReadUser(let id):
                return "/users/\(id)"
            case .UpdateUser(let id, _):
                return "/users/\(id)"
            case .DestroyUser(let id):
                return "/user/\(id)"
            case .ReadBusiness(let id):
                return "/businesses/\(id)"
            case .UpdateBusiness(let id, _):
                return "/businesses/\(id)"
            case .DestroyBusiness(let id):
                return "/business/\(id)"
            case .CreateDeal:
                return "/deals"
            case .ReadDeal(let id):
                return "/deals/\(id)"
            case .UpdateDeal(let id, _):
                return "/deals/\(id)"
            case .DestroyDeal(let id):
                return "/deals/\(id)"
            case .GetDeals(_, _):
                return "/deals"
            case .CreatePost:
                return "/posts"
            case .ReadPost(let id):
                return "/posts/\(id)"
            case .UpdatePost(let id, _):
                return "/posts/\(id)"
            case .DestroyPost(let id):
                return "/posts/\(id)"
            case .GetPosts(_, _, _):
                return "/posts"
            case .Follow(_):
                return "/followships"
            case .UnFollow(_):
                return "/followships/unfollow"
            case .GetFollowers(_,_,_,_):
                return "/followships"
            case .GetFollowing(_,_,_,_):
                return "/followships"
            case .Love(_):
                return "/loves"
            case .UnLove(_):
                return "/loves/unlove"
            case .GetLovers(_, _, _):
                return "/loves"
            case .CreateComment(_):
                return "/comments"
            case .GetComments(_, _, _):
                return "/comments"
            case .GetFeedLocal(_, _, _, _, _, _):
                return "/feed"
            case .GetFeedGlobal(_, _, _):
                return "/feed"
            case .GetFeedFollowing(_, _):
                return "/feed"

            }
        }



        // MARK: URLRequestConvertible

        var URLRequest: NSURLRequest {

            var email_token: NSDictionary?
            var auth_token: NSDictionary?
            var email_error: NSError?
            var auth_error: NSError?

            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(urlPath))
            mutableURLRequest.HTTPMethod = method.rawValue

            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")

            if Defaults[kLoggedIn].string != "false" {
                (email_token, email_error) = Locksmith.loadDataForUserAccount("Email_Token", inService: "KeyChainService")
                if email_error == nil {
                    Router.Email = email_token!["email"] as? String
                }

                (auth_token, auth_error) = Locksmith.loadDataForUserAccount("Auth_Token", inService: "KeyChainService")

                if auth_error == nil {
                    Router.AuthToken = auth_token!["auth_token"] as? String
                }
            }

            if let token = Router.AuthToken {
                mutableURLRequest.setValue("\(token)", forHTTPHeaderField: "X-User-Token")
            }

            if let email = Router.Email {
                mutableURLRequest.setValue("Bearer \(email)", forHTTPHeaderField: "X-User-Email")
            }

            switch self {
            case .Login(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0

            case .CreateUser(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateUser(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0

            case .UpdateBusiness(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0

            case .CreateDeal(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateDeal(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .GetDeals(let businessId, let page) where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["business_id": businessId, "page_size": Router.perPage * page]).0
            case .Search(let businessId, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["business_id": businessId]).0

            case .CreatePost(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdatePost(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .GetPosts(let type, let typeId, let page) where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["postable_type": type,"postable_id": typeId, "page_size": Router.perPage * page]).0
            case .GetPosts(let type, let typeId, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["postable_type": type,"postable_id": typeId]).0

            case .Follow(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UnFollow(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .GetFollowers(let userType, let userTypeId, let type, let page)  where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["user_type": userType, "user_type_id": userTypeId, "type": type, "page_size": Router.perPage * page]).0
            case .GetFollowers(let userType, let userTypeId, let type, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["user_type": userType, "user_type_id": userTypeId, "type": type]).0
            case .GetFollowing(let userType, let userTypeId, let type, let page):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["user_type": userType, "user_type_id": userTypeId, "type": type]).0
            case .GetFollowing(let userType, let userTypeId, let type, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["user_type": userType, "user_type_id": userTypeId, "type": type]).0

            case .Love(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UnLove(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .GetLovers(let item_type, let itemId, let page)  where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["loveable_type": item_type, "loveable_id": itemId, "page_size": Router.perPage * page]).0
            case .GetLovers(let item_type, let itemId, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["loveable_type": item_type, "loveable_id": itemId]).0

            case .CreateComment(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .GetComments(let item, let itemId, let page)  where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["commentable_type": item, "commentable_id": itemId, "page_size": Router.perPage * page]).0
            case .GetComments(let item, let itemId, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["commentable_type": item, "commentable_id": itemId]).0

            case .GetFeedLocal(let lat, let lon, let distance, let type, let category, let page)  where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["lat": lat, "lon": lon, "distance": distance, "type": type, "category": category, "page": page, "page_size": Router.perPage * page]).0
            case .GetFeedLocal(let lat, let lon, let distance, let type, let category, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["lat": lat, "lon": lon, "distance": distance, "type": type, "category": category]).0

            case .GetFeedGlobal(let type, let category, let page) where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["type": type, "category": category, "page": page, "page_size": Router.perPage * page]).0
            case .GetFeedLocal(let lat, let lon, let distance, let type, let category, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["type": type, "category": category]).0

            case .GetFeedFollowing(let category, let page) where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["category": category, "page": page, "page_size": Router.perPage * page]).0
            case .GetFeedFollowing(let category, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["category": category]).0

            case .GetComments(let item, let itemId, let page)  where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["commentable_type": item, "commentable_id": itemId, "page_size": Router.perPage * page]).0
            case .GetComments(let item, let itemId, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["commentable_type": item, "commentable_id": itemId]).0

            case .Search(let query, let page) where page > 1:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["q": query, "page_size": Router.perPage * page]).0
            case .Search(let query, _):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["q": query]).0
            default:
                return mutableURLRequest
            }

        }

    }

}
