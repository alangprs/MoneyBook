//
//  MonthlyCalendarViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/21.
// 首頁 顯示月曆

import UIKit

//要顯示的section數量
class MonthlyCalendarViewController: UIViewController,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //cell要顯示的內容 （從額外寫的cell讀資料）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MonthlyCalendarViewController.self)", for: indexPath) as? MonthlyCalendarCellTableViewCell else {return UITableViewCell()}
        cell.MonthlyCellKindLabel.text = "喔"
        return cell
    }
    
    //下方tableview
    @IBOutlet weak var monthlyCalendarTableView: UITableView!
    //選日期
    @IBOutlet weak var monthlyCalendarDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //選擇日期
    @IBAction func selectDate(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy年MM月dd日"
        print(dateValue.string(from: monthlyCalendarDatePicker.date))
    }
    
    
    //讓AddExpenseItemTableViewController 回來
    @IBAction func unwindToMonthlyCalendarViewController(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
//    //使用prepare將這頁tableView cell資料傳到下一頁修改
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //如果有取得上一頁的controller、這頁controller的tableView選中的row有資料，將這頁資料存給下一頁
//        if let controller = segue.destination as? AddExpenseItemTableViewController,
//           let row = self.monthlyCalendarTableView.indexPathForSelectedRow?.row{
//
//            controller.AddExpenseItemData = monthlyCalendarDataArray[row]
//        }
//    }
    
    
    
}
