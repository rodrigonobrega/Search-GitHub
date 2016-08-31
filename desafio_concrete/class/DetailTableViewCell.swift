//
//  MasterTableViewCell.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitlePull: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var lblFork: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    
    var itemRepositoryDetail: ItemRepositoryDetail! {
        didSet {
            self.configureCell()
        }
    }
    
    func configureCell() {
        self.lblTitlePull.text  = itemRepositoryDetail.title
        self.lblBody.text       = itemRepositoryDetail.body
        self.lblUsername.text   = itemRepositoryDetail.user?.userName
        self.lblCreatedAt.text  = itemRepositoryDetail.createdAt?.toDate()
        self.imageAvatar.image = UIImage(named: "avatar")
        if let imgURL = itemRepositoryDetail.user?.avatarURL {
            /*
             Como ja havia utilizado image cache no MasterTableViewCell.swift resolvi aqui usar extension
             somente para demonstração.
             */
            self.imageAvatar.imageFromUrl(imgURL)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
