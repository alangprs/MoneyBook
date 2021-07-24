//
//  AccountCellTableViewCell.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/24.
//

import UIKit

class AccountCellTableViewCell: UITableViewCell {
    //照片
    @IBOutlet weak var accountCellImage: UIImageView!
    //帳戶名稱
    @IBOutlet weak var accountCellLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
