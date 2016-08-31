//
//  OwnerRepository.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {

    var avatarURL:String?
    var userName:String?
    
    init(json: JSON){
        avatarURL   = UtilShared.jsonStringValue(json, attribute: "avatar_url")
        userName    = UtilShared.jsonStringValue(json, attribute: "login")
    }
    
}
