//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import SwiftyJSON


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var session = WCSession.defaultSession()

    @IBOutlet var table: WKInterfaceTable!
    var listRepository = [ItemRepository]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.activateWatch()
        if (table.numberOfRows == 0) {
            table.setNumberOfRows(1, withRowType: "rowEmpty")
            return;
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: TableDelegate
    func tableRefresh(){
        
        table.setNumberOfRows(listRepository.count, withRowType: "row")
        
        for index in 0 ..< table.numberOfRows {
            let item    = listRepository[index]
            let row     = table.rowControllerAtIndex(index) as! ItemRepositoryWK
            row.nameRepository.setText(item.name)
            row.lblFork.setText("\(item.fork!)")
            row.lblStar.setText("\(item.star!)")
        }
        
    }
    
    // MARK: WCSessionDelegate
    internal func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let jsonData = applicationContext["jsonGit"] as! NSData
        listRepository = ItemsRepository(json: JSON(NSKeyedUnarchiver.unarchiveObjectWithData(jsonData)!)).listRepository
        tableRefresh()
    }
    
    // MARK: Watch config
    internal func activateWatch() {
        isWatchSupported()
    }
    
    internal func isWatchSupported() -> Bool {
        let supported = WCSession.isSupported()
        if supported {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        return supported
    }

}
