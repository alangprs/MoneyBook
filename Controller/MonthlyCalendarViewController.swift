//
//  MonthlyCalendarViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/21.
// 首頁 顯示月曆

import UIKit
import CoreData

//要顯示的section數量
class MonthlyCalendarViewController: UIViewController,NSFetchedResultsControllerDelegate{
    
    //下方tableview
    @IBOutlet weak var monthlyCalendarTableView: UITableView!
    //日期
    @IBOutlet weak var monthlyCalendarDatePicker: UIDatePicker!
    
    var date:Date?
    var container:NSPersistentContainer! //使用coredata存檔功能
    var fetchResultController: NSFetchedResultsController<ArchiveData>! //資料監控
    var archiveDataArray = [ArchiveData]() //存檔資料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upDataUI()
    }
    func upDataUI(){
        date = monthlyCalendarDatePicker.date
        getArchiveData() //讀取存檔
        
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
        //有取得add頁面填入的資料
        if let controller = unwindSegue.source as? AddExpenseItemTableViewController,
           let expenseItem = controller.archiveData{
            
            let context = controller.container?.viewContext
            if monthlyCalendarTableView.indexPathsForSelectedRows != nil{
                print("修改資料 回來")
            }else{
                //將回來的資料 加回這頁array
                archiveDataArray.append(controller.archiveData!)
                context?.insert(expenseItem)
                print("新增資料 回來")
            }
            //存檔
            container.saveContext()
            //刷新頁面
            monthlyCalendarTableView.reloadData()
        }
    }
    //讀存檔資料
    func getArchiveData(){
        let context = container?.viewContext
        do {
            archiveDataArray = try context?.fetch(ArchiveData.fetchRequest()) as! [ArchiveData]
        } catch {
            print("讀取資料失敗")
        }
        
    }
    
    //準備資料去 add頁面 判斷是 新增 or 修改
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //如果是按＋ 新增資料 取得UINavigationController的AddExpenseItemTableViewController內容
        if segue.identifier == "addNewData"{
            
            if let navController = segue.destination as? UINavigationController,
               let controller = navController.topViewController as? AddExpenseItemTableViewController{
                //將選到的日期 傳給add頁面
                controller.date = date
                //將存檔功能傳下去
                controller.container = container
            }
            
        }else if segue.identifier == "esitData"{ //傳修改資料
            //取得 navController的add頁面，有取得選到的row
            if let navController = segue.destination as? UINavigationController,
               let controller = navController.topViewController as? AddExpenseItemTableViewController,
               let row = monthlyCalendarTableView.indexPathForSelectedRow?.row{
                
                //將選到的日期 傳給add頁面
                controller.date = date
                //選到的資料傳下去
                controller.archiveData = archiveDataArray[row]
                //將存檔功能傳下去
                controller.container = container
            }
        }
    }
}
//擴充tableview功能
extension MonthlyCalendarViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveDataArray.count
    }
    //cell要顯示的內容 （從額外寫的cell讀資料）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MonthlyCalendarViewController.self)", for: indexPath) as? MonthlyCalendarCellTableViewCell else {return UITableViewCell()}
        let row = archiveDataArray[indexPath.row]
        //顯示種類
        cell.MonthlyCellKindLabel.text = row.category
        cell.MonthlyCellKindImage.image = UIImage(named: "\(String(describing: row.category!))")
        //付款種類
        cell.payIngKindLabel.text = row.account
        cell.MonthlyCellSumMoneyLabel.text = "\(row.sum)"
        return cell
    }
    //刪除選到的cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = container?.viewContext
        let row = archiveDataArray[indexPath.row]
        //移除array裡面資料
        archiveDataArray.remove(at: indexPath.row)
        //刪除coredata裡面資料
        context?.delete(row)
        //存檔
        container?.saveContext()
        //刪除畫面上選到的cell
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}
