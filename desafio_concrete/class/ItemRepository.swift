//
//  ItemRepository.swift
//  Desafio_concrete
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemRepository: NSObject {

    
    var id:String?
    var name:String?
    var fullName:String?
    var descriptionItem: String?
    var ownerRepository:OwnerRepository?
    var star:Int?
    var fork:Int?
    var htmlURL:String?
    
    
    init(json: JSON){
        
        id              = UtilShared.jsonStringValue(json, attribute: "id")
        name            = UtilShared.jsonStringValue(json, attribute: "name")
        fullName        = UtilShared.jsonStringValue(json, attribute: "full_name")
        descriptionItem = UtilShared.jsonStringValue(json, attribute: "description")
        htmlURL         = UtilShared.jsonStringValue(json, attribute: "html_url")
        star            = json["stargazers_count"].int
        fork            = json["forks_count"].int
        ownerRepository = OwnerRepository(json: json["owner"])

    }
    
    
}
