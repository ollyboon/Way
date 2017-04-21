//
//  CustomTableViewCell.swift
//  Way
//
//  Created by Olly Boon on 04/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomIcon: UIImageView!
    var rooms = RoomManager.shared.rooms
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for room in rooms {
            if room.isToilet == true {
                roomIcon.image = #imageLiteral(resourceName: "Toilet Icon")
            }
            
//            if room.isPrinter == true {
//                roomIcon.image = #imageLiteral(resourceName: "printerTable")
//            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
