//
//  ItemsRepository.swift
//  Desafio_concrete
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON


class ItemsRepository: NSObject {

    var listRepository: [ItemRepository]
    
    init(json: JSON){
        
        listRepository = []
        
        let list: Array<JSON> = json["items"].arrayValue
        
        for  item in list {
            listRepository.append(ItemRepository(json: item))
        }
    }

}
