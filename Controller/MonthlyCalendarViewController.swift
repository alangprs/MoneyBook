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
    //總收入
    @IBOutlet weak var incomeTotalLabel: UILabel!
    //總支出
    @IBOutlet weak var expensesTotalLabel: UILabel!
    //月餘額
    @IBOutlet weak var monthTotalLabel: UILabel!
    
    var date:String?
    var selectDatePicker:Date?
    var container:NSPersistentContainer! //使用coredata存檔功能
    var fetchResultController: NSFetchedResultsController<ArchiveData>! //資料監控控制器
    var archiveDataArray = [ArchiveData]() //放存檔指定日期資料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upDataUI()
        fetchResultController.delegate = self
    }
    func upDataUI(){
        date = "\(monthlyCalendarDatePicker.date)"
        getArchiveData(date: dateFormatter(date: Date())) 
        getTitleLabel()
        
    }
    //顯示 tabelview 抬頭文字
    func getTitleLabel(){
        //取得當日收入金額
        //reduce=將array裡數量逐一加總 0 = 起始值 $0 = 計算後值 $1 = 下一個從array放入的值
        let expAmount = archiveDataArray.reduce(0, {if $1.isExpense==true {return $0+Int($1.sum)};return $0})
        let incAmount = archiveDataArray.reduce(0, {if $1.isExpense==false {return $0+Int($1.sum) };return $0})
        incomeTotalLabel.text = "收入 \n+\(incAmount)元"
        expensesTotalLabel.textColor = UIColor.red
        expensesTotalLabel.text = "支出 \n-\(expAmount)元"
        
        if incAmount - expAmount < incAmount{
            monthTotalLabel.textColor = UIColor.red
        }
        monthTotalLabel.text = "盈餘 \n\(incAmount - expAmount)元"
        
    }
    //取得core data 選到日期的內容
    func getArchiveData(date:String){
        archiveDataArray.removeAll()
        // 從ArchiveData取得NSFetchRequest
        let fetchRequest: NSFetchRequest<ArchiveData> = ArchiveData.fetchRequest()
        // 讀取出來的物件依照日期降序排列
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //取得資料條件 NSPredicate(過濾條件設定)
        fetchRequest.predicate = NSPredicate(format: "date == %@", dateFormatter(date: monthlyCalendarDatePicker.date))
        // 透過AppDelegate取得資料
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // 建立ManagedObjectContext
            let context = appDelegate.persistentContainer.viewContext
            // 初始化fetchResultController，使用日期作為sectionNameKeyPath
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "date", cacheName: nil)
            // 指定委派為自己來監控資料變化
            fetchResultController.delegate = self
            
            do {
                // 呼叫performFetch()執行讀取結果
                try fetchResultController.performFetch()
                
                // 存取fetchedObjects屬性取得archiveDataArray物件
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    
                    archiveDataArray = fetchedObjects
                    
                }
            } catch {
                
                print("讀取失敗的錯誤訊息：\(error)")
            }
        }
        
    }
    
    //選擇日期
    @IBAction func selectDate(_ sender: UIDatePicker) {
        //點選到的日期
        getArchiveData(date: dateFormatter(date: sender.date))
        date = "\(sender.date)"
        getTitleLabel()
        monthlyCalendarTableView.reloadData()
    }
    func dateFormatter(date:Date)->String {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy年MM月dd日"
        let dateStr = dateValue.string(from: date)
        return dateStr
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
                
                context?.insert(expenseItem)
                print("新增資料 回來")
            }
            //存檔
            container.saveContext()
            getTitleLabel()
            //刷新頁面
            monthlyCalendarTableView.reloadData()
            
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
                controller.selectDatePicker = monthlyCalendarDatePicker.date
            }
            
        }else if segue.identifier == "esitData"{ //傳修改資料
            //取得 navController的add頁面，有取得選到的row
            if let navController = segue.destination as? UINavigationController,
               let controller = navController.topViewController as? AddExpenseItemTableViewController,
               let row = monthlyCalendarTableView.indexPathForSelectedRow?.row{
                
                //將選到的日期 傳給add頁面
                controller.date = date
                controller.selectDatePicker = selectDatePicker
                //選到的資料傳下去
                controller.archiveData = archiveDataArray[row]
            }
        }
    }
    // 準備開始處理內容更變時會被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        monthlyCalendarTableView.beginUpdates()
    }
    // 有任何的內容更變會自動被呼叫：Object
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .insert:
            if let newIndexPath = newIndexPath {
                monthlyCalendarTableView.insertRows(at: [newIndexPath], with: .fade)
                getTitleLabel()
                print("有跑嗎")
            }
            
        case .delete:
            if let indexPath = indexPath {
                monthlyCalendarTableView.deleteRows(at: [indexPath], with: .fade)
                getTitleLabel()
            }
            
        case .update:
            if let indexPath = indexPath {
                monthlyCalendarTableView.reloadRows(at: [indexPath], with: .fade)
                getTitleLabel()
            }
            
        default:
            monthlyCalendarTableView.reloadData()
        }
        // 讀取結果控制器更變後同步records的資料
        if let fetchedObjects = controller.fetchedObjects {
            
            archiveDataArray = (fetchedObjects as! [ArchiveData])
            print("最新的資料：\(archiveDataArray)")
        }
        monthlyCalendarTableView.reloadData()
    }
    // 完成內容更變時會被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        monthlyCalendarTableView.endUpdates()
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
        
        //判斷收入、支出後 顯示不同顏色字體
        if row.isExpense == true{ //支出
            cell.MonthlyCellSumMoneyLabel.textColor = UIColor.red
            cell.MonthlyCellSumMoneyLabel.text = "-\(row.sum)"
            
            
        }else{
            cell.MonthlyCellSumMoneyLabel.textColor = UIColor.black
            cell.MonthlyCellSumMoneyLabel.text = "+\(row.sum)"
            
        }
        
        return cell
    }
    //刪除選到的cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.fetchResultController.object(at: indexPath))
        }
        getTitleLabel()
        //存檔
        container?.saveContext()
        //刷新controller
        self.viewDidLoad()
    }
    
    
}
