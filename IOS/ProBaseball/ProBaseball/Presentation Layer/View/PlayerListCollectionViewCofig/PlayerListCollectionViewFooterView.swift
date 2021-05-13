//
//  PlayerListCollectionViewFooterView.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/13.
//

import UIKit

class PlayerListCollectionViewFooterView: UICollectionReusableView {
    @IBOutlet weak var baLabel: UILabel!
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing: PlayerListCollectionViewFooterView.self)
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
