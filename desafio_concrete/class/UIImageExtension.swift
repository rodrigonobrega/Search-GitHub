//
//  UIImageExtension.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import Alamofire


class UIImageExtension: NSObject {}

extension UIImageView {
    
    public func imageFromUrl(urlString: String) {
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                if let image = response.result.value {
                    self.layer.masksToBounds    = false
                    self.layer.borderWidth      = 0.1
                    self.layer.cornerRadius     = self.frame.height/2
                    self.clipsToBounds          = true
                    self.image = image
                    
                }
        }
    }
}
