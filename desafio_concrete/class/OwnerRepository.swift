//
//  OwnerRepository.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON

class OwnerRepository: NSObject {

    var avatarURL:String?
    var username:String?
    
    init(json: JSON){
        avatarURL   = UtilShared.jsonStringValue(json, attribute: "avatar_url")
        username    = UtilShared.jsonStringValue(json, attribute: "login")
    }
    
}
