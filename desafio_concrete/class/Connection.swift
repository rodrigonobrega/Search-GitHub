//
//  Connection.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WatchConnectivity

class Connection: NSObject, WCSessionDelegate {
    
    static let urlRepository = "https://api.github.com/search/repositories?q=language:Java&sort=stars&page=%d" //page
    
    class func loadRepository(page:Int, onSuccess: (retorno: ItemsRepository) -> Void, onError: (NSError) -> Void) {
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: urlRepository, code: -999, userInfo: nil))
            return;
        }
        print("calling \(String(format: urlRepository, page))")
        
        Alamofire.request(.GET, String(format: urlRepository, page)).responseJSON { (responseData) -> Void in
            if let json = responseData.result.value {
                let js = JSON(json)
                let data = NSKeyedArchiver.archivedDataWithRootObject(json)
                let items = ItemsRepository(json: js)
                if items.listRepository.count > 0 {
                    Connection().pushSettingsToWatchApp(data)
                }
                onSuccess(retorno: items)
            } else {
                onError(NSError(domain: urlRepository, code: (responseData.result.error?.code)!, userInfo: nil))
            }
        }
    }
    
    class func loadRepositoryDetail(creator:String,repository:String, onSuccess: (retorno: ItemsRepositoryDetail) -> Void, onError: (NSError) -> Void) {
        let urlDetailRepository = "https://api.github.com/repos/\(creator)/\(repository)/pulls"
        
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: urlDetailRepository, code: -999, userInfo: nil))
            return;
        }
        
        Alamofire.request(.GET, urlDetailRepository).responseJSON { (responseData) -> Void in
            if let json = responseData.result.value {
                let js = JSON(json)
                onSuccess(retorno: ItemsRepositoryDetail(json: js))
            } else {
                onError(NSError(domain: urlDetailRepository, code: (responseData.result.error?.code)!, userInfo: nil))
            }
        }
    }
    
    func pushSettingsToWatchApp(jsonData:NSData) {
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                let watchSession = WCSession.defaultSession()
                watchSession.delegate = self
                watchSession.activateSession()
                if watchSession.paired && watchSession.watchAppInstalled {
                    do {
                        try watchSession.updateApplicationContext(["jsonGit": jsonData])
                    } catch let error as NSError {
                        print(error.description)
                    }
                }
            }
        }
    }
    
    
    
    /*class func getY(page:Int, onSuccess: (retorno: ItemsRepository) -> Void, onError: (NSError) -> Void) {
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: urlString, code: -999, userInfo: nil))
            return;
        }
        
        Alamofire.request(.GET, String(format: urlString, page)).responseJSON { (responseData) -> Void in
            if let json = responseData.result.value {
                let js = JSON(json)
                print(js)
                let returnList = ItemsRepository(json: js)
                
                onSuccess(retorno: returnList)
                
            } else {
                onError(NSError(domain: urlString, code: (responseData.result.error?.code)!, userInfo: nil))
            }
        }
        
        
        Alamofire.request(.GET, "https://api.github.com/repos/\(creator)/\(repo)/pulls")
            .responseString { (response) in
                if let value = response.result.value {
                    completion(PulllistService(str: value))
                } else {
                    completion(nil)
                }
        }
    }
    controller.creator = item.owner?.login
    controller.repo = item.name */
}
