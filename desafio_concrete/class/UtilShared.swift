//
//  UtilShared.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import SwiftyJSON

class UtilShared: NSObject {
    class func jsonStringValue(json:JSON ,attribute: String) -> String {
        return json[attribute].string ?? ""
    }
}
