//
//  PlayerListCollectionViewFooterView.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/13.
//

import UIKit

class PlayerListCollectionViewFooterView: UICollectionReusableView {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var baLabel: UILabel!
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing: PlayerListCollectionViewFooterView.self)
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        totalLabel.font = UIFont(name: "AmericanCaptain", size: 25)
        baLabel.font = UIFont(name: "AmericanCaptain", size: 25)
        hLabel.font = UIFont(name: "AmericanCaptain", size: 25)
        outLabel.font = UIFont(name: "AmericanCaptain", size: 25)
    }
}
