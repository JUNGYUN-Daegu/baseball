//
//  PlayerListCollectionViewHeaderView.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/13.
//

import UIKit

class PlayerListCollectionViewHeaderView: UICollectionReusableView {
    
    @IBOutlet var labelCollection: [UILabel]!
    
    static var reuseIdentifier: String {
        return String(describing: PlayerListCollectionViewHeaderView.self)
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelCollection.forEach { (label) in
            label.font = UIFont(name: "AmericanCaptain", size: 25)
        }
    }
}
