//
//  MonthlyCalendarViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/21.
// 首頁 顯示月曆

import UIKit

//要顯示的section數量
class MonthlyCalendarViewController: UIViewController{
    
    //下方tableview
    @IBOutlet weak var monthlyCalendarTableView: UITableView!
    //日期
    @IBOutlet weak var monthlyCalendarDatePicker: UIDatePicker!
    
    var date:Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upDataUI()
        
    }
    func upDataUI(){
        date = monthlyCalendarDatePicker.date
    }
    
    //選擇日期
    @IBAction func selectDate(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy年MM月dd日"
        //存點選到的日期
        date = monthlyCalendarDatePicker.date
    }
    
    
    //讓AddExpenseItemTableViewController 回來
    @IBAction func unwindToMonthlyCalendarViewController(_ unwindSegue: UIStoryboardSegue) {

    }
    
    //傳資料去add頁面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //如果是按＋ 新增資料 取得UINavigationController的AddExpenseItemTableViewController內容
        if segue.identifier == "addNewData"{
            if let navController = segue.destination as? UINavigationController,
               let controller = navController.topViewController as? AddExpenseItemTableViewController{
                //將選到的日期 傳給add頁面
                controller.date = date
            }
            
            
        }
        //傳 要修改資料
//        else if segue.identifier == "editData"{
////
////        }
    }
    
    
}
//擴充tableview功能
extension MonthlyCalendarViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //cell要顯示的內容 （從額外寫的cell讀資料）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MonthlyCalendarViewController.self)", for: indexPath) as? MonthlyCalendarCellTableViewCell else {return UITableViewCell()}
        
        return cell
    }
}
