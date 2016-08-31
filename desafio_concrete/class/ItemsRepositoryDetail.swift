//
//  ItemsRepository.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON


class ItemsRepositoryDetail: NSObject {

    var listRepository: [ItemRepositoryDetail]
    
    init(json: JSON){
        
        listRepository = []
        
        let list: Array<JSON> = json.arrayValue
        
        for  item in list {
            listRepository.append(ItemRepositoryDetail(json: item))
        }
    }

}
