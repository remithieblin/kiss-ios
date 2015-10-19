//
//  CustomCell.swift
//  Kiss
//
//  Created by thieblin on 3/13/15.
//  Copyright (c) 2015 actimust. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var kissImage: UIImageView!
    
    var name: String = ""
    var countOut: Int = 0
    var lastSend: Int = 0
    var id: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(friend: Friend){
        
        name = friend.name
        countOut = friend.countOut
        lastSend = friend.lastSend
        id = friend.id
        
        let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            
            if data != nil {
                let image = UIImage(data: data)
                self.profileImage.layer.cornerRadius = 25
                self.profileImage.clipsToBounds = true
                self.profileImage.image = image
            }
        }
        
        nameLabel.text = name
        statsLabel.text = "\(countOut)"
        
        let image = UIImage(named: "kiss_test_50.png")
        kissImage.image = image
        kissImage.hidden = true
        
    }

}
