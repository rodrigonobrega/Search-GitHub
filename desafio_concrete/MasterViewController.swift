//
//  MasterViewController.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import Alamofire
import AudioToolbox

class MasterViewController: UITableViewController {

    var detailTableViewController: DetailTableViewController? = nil
    var listRepository = [ItemRepository]()
    var page:Int = 1
    var stopScrool:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(MasterViewController.leftButtonAction))
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailTableViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailTableViewController
        }
        
        self.refreshControl?.attributedTitle = NSAttributedString.init(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(firstLoadRepository), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()
        firstLoadRepository()
    }
    
    func leftButtonAction() {
        UIAlertView(title: "Wait", message: "Waiting definition", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func firstLoadRepository() {
        page = 1
        listRepository = [ItemRepository]()
        loadRepository()
    }
    
    func loadRepository() {
        
        Connection.loadRepository(page, onSuccess: {(retorno) -> Void in
            if retorno.listRepository.count > 0 {
                self.stopScrool = false
                self.listRepository.appendContentsOf(retorno.listRepository)
                self.listRepository.append(ItemRepository(json: ""))    //item add for use in infinite scroll(CellLoading)
            } else {
                self.stopScrool = true
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            }, onError: {
                (NSError) -> Void in
                Util.showErrorMessage(NSError)
                self.refreshControl?.endRefreshing()
                
        })
    }

    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let item = listRepository[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailTableViewController
                controller.itemRepository = item
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRepository.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row + 1 == listRepository.count && !stopScrool { // if last element and can load more items
            let cellLoading = tableView.dequeueReusableCellWithIdentifier("CellLoading", forIndexPath: indexPath)
            page = page + 1
            listRepository.removeLast() //remove last element
            loadRepository()
            return cellLoading
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        
        cell.itemRepository = listRepository[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More\n+" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            let shareMenu = UIAlertController(title: nil, message: "Open in:", preferredStyle: .ActionSheet)
            
            let safariAction = UIAlertAction(title: "Safari", style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                let obj = self.listRepository[indexPath.row]
                
                if let requestUrl = NSURL(string: obj.htmlURL!) {
                    UIApplication.sharedApplication().openURL(requestUrl)
                }
                tableView.setEditing(false, animated: true)

            })
            let copyAction = UIAlertAction(title: "Copy url to clipboard", style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                tableView.setEditing(false, animated: true)
                let obj = self.listRepository[indexPath.row]
                
                if let requestUrl = obj.htmlURL {
                    UIPasteboard.generalPasteboard().string = requestUrl
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                (alert: UIAlertAction!) in
                tableView.setEditing(false, animated: true)
            })
            
            shareMenu.addAction(safariAction)
            shareMenu.addAction(copyAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        shareAction.backgroundColor = view.tintColor
        return [shareAction]
    }

}

