//
//  MasterTableViewCell.swift
//
//  Created by Rodrigo Nóbrega on 06/16.
//  Copyright © 2016 Foxcode. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class MasterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblRepositoryName: UILabel!
    @IBOutlet weak var lblDescriptionRepository: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblFork: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    
    var itemRepository: ItemRepository! {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        self.lblRepositoryName.text         = itemRepository.name
        self.lblDescriptionRepository.text  = itemRepository.descriptionItem
        self.lblUsername.text               = itemRepository.ownerRepository?.username
        self.lblFullName.text               = itemRepository.fullName
        self.lblFork.text                   = "\((itemRepository.fork)!)"
        self.lblStar.text                   = "\((itemRepository.star)!)"
        self.imageAvatar.image = UIImage(named: "avatar")
        
        if let imgURL = itemRepository.ownerRepository?.avatarURL {
            if let img = Util.cachedImage(imgURL){
                self.imageAvatar.image = img
            } else {
                loadAvatar(imgURL, imgView: self.imageAvatar)
            }
            
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadAvatar(urlString:String, imgView:UIImageView) {
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                if let image = response.result.value {
                    imgView.layer.masksToBounds    = false
                    imgView.layer.borderWidth      = 0.1
                    imgView.layer.cornerRadius     = imgView.frame.height/2
                    imgView.clipsToBounds          = true
                    imgView.image = image
                    Util.cacheImage(image, urlString: urlString)
                }
        }
    }
}
