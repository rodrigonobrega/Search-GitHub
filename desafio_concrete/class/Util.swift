//
//  Util.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import AlamofireImage

class Util: NSObject {

    class func isConnectToNetwork() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    class func showErrorMessage(error: NSError) {
        print(error.code)
        UIAlertView(title: "Erro", message: "Make sure your device is connected to the internet", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    //MARK: = Image Caching
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    class func cacheImage(image: Image, urlString: String) {
        imageCache.addImage(image, withIdentifier: urlString)
    }
    
    class func cachedImage(urlString: String) -> Image? {
        return imageCache.imageWithIdentifier(urlString)
    }
    
}
