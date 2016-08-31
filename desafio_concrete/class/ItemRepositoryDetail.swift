//
//  ItemRepositoryDetail.swift
//  Desafio_concrete
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemRepositoryDetail: NSObject {

    var title: String?
    var createdAt: String?
    var body: String?
    var ownerRepository: OwnerRepository?
    var htmlURL: String?
    var user:User?
    
    
    init(json: JSON){
        
        title           = UtilShared.jsonStringValue(json, attribute: "title")
        createdAt       = UtilShared.jsonStringValue(json, attribute: "created_at")
        body            = UtilShared.jsonStringValue(json, attribute: "body")
        htmlURL         = UtilShared.jsonStringValue(json, attribute: "html_url")
        user            = User(json: json["user"])
        ownerRepository = OwnerRepository(json: json["owner"])
        
    }
}
