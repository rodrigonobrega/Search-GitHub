//
//  DetailTableViewController.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import AudioToolbox

class DetailTableViewController: UITableViewController, UIAlertViewDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var listRepository = [ItemRepositoryDetail]()

    var itemRepository: ItemRepository? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func configureView() {
        self.navigationItem.title = itemRepository?.name
        self.refreshControl?.attributedTitle = NSAttributedString.init(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(conectar), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()
        conectar()
    }
    
    func conectar() {
        let creator = itemRepository?.ownerRepository?.username
        let repository = itemRepository?.name
        Connection.loadRepositoryDetail(creator!,repository: repository!, onSuccess: {(retorno) -> Void in
            self.listRepository = retorno.listRepository
            if self.listRepository.count == 0 {
                UIAlertView(title: "GitHub", message: "Pulls not Found to \"\(repository!)\" by \"\(creator!)\"", delegate: nil, cancelButtonTitle: "Ok").show()
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
            
            }, onError: {
                (NSError) -> Void in
                Util.showErrorMessage(NSError)
                self.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRepository.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.itemRepositoryDetail = listRepository[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertView(title: "Open in", message: "You want to open in Safari", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Open")
        alert.tag = indexPath.row
        alert.show()
    }

    // MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        if buttonIndex == 1 {            
            let pull = listRepository[alertView.tag]
            if let requestUrl = NSURL(string: pull.htmlURL!) {
                UIApplication.sharedApplication().openURL(requestUrl)
            }
        }
    }
    

}

