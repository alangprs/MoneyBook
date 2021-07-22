//
//  MonthlyCalendarCellTableViewCell.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/22.
//首頁 cell要顯示的內容

import UIKit

class MonthlyCalendarCellTableViewCell: UITableViewCell {
    //種類圖片
    @IBOutlet weak var MonthlyCellKindImage: UIImageView!
    //種類名稱
    @IBOutlet weak var MonthlyCellKindLabel: UILabel!
    //金額
    @IBOutlet weak var MonthlyCellSumMoneyLabel: UILabel!
    //付款種類
    @IBOutlet weak var payIngKindLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
