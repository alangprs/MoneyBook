//
//  AddExpenseItemTableViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/22.
//費用添加

import UIKit

class AddExpenseItemTableViewController: UITableViewController {
    
    @IBOutlet weak var datePickerTextField: UITextField!
    //收入、支出 選擇
    @IBOutlet weak var SelectTypeSegmented: UISegmentedControl!
    //顯示類別
    @IBOutlet weak var categoryLabel: UILabel!
    //顯示帳戶
    @IBOutlet weak var accountLabel: UILabel!
    
    let datePicker = UIDatePicker()
    var isExpenseCategory:Bool? //控制支出、收入
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatepicker()//初始化datePicker
        upDataUI()
        
    }
    //載入UI畫面
    func upDataUI(){
        //初始化 支出-類別
        categoryLabel.text = Expense.expenseCategories.first?.rawValue
        //初始化 支出-帳戶
        accountLabel.text = Expense.accounts.first?.rawValue
    }
    
    //定義tableview，選到的cell要做的事情
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選到的是必要資料 還是 選填資料
        let dataCategory = DataCategorys.allCases[indexPath.section]
        switch dataCategory {
        //必要資料
        case .neededDatas:
            //定義必要資料裡 每個欄位的資料內容、要做的事情
            let neededDatas = NeededDatas.allCases[indexPath.row]
            switch neededDatas {
            case .date: //日期
                return
            case .amount://金額
                return
            case .category: //類別
                performSegue(withIdentifier: "\(SelectTypeCollectionViewController.self)", sender: nil)
            case .account: //帳戶類別
                performSegue(withIdentifier: "\(AccountTableViewController.self)", sender: nil)
            }
        //選填資料 (功能還未寫完)
        case .additionalDatas:
            let additionalDatas = AdditionalDatas.allCases[indexPath.row]
            switch additionalDatas {
            case .receiptPhoto: //收據照片
                return
            case .memo://備註
                return
            }
        }
    }
    
    //創造一個裝datePicker的容器
    func createToolBar() -> UIToolbar{
        let toolbar = UIToolbar() //創造一個工具功能
        toolbar.sizeToFit()//設定大小
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(pressed)) //設定按鈕
        toolbar.setItems([barButtonItem], animated: true) //將工具加入按鈕
        return toolbar
    }
    //執行按下之後動作
    @objc func pressed(){
        let dateFormatter = DateFormatter() //日期樣式設定
        dateFormatter.dateStyle = .medium //文字顯示：中
        dateFormatter.dateFormat = "yyyy年MM月dd日" //日期顯示方式 年、月、日
        self.datePickerTextField.text = dateFormatter.string(from: datePicker.date)//設定textField顯示點選到的日期
        self.view.endEditing(true)
    }
    //設定datePicker
    func createDatepicker(){
        datePicker.preferredDatePickerStyle = .wheels //設定日期選擇樣式
        datePicker.datePickerMode = .date //只要日期
        datePicker.locale = Locale(identifier: "zh_TW") //設置語言環境：台灣
        datePickerTextField.inputView = datePicker //dateTextfield點下去時跳出datePicker選單
        datePickerTextField.inputAccessoryView = createToolBar() //執行工具
    }
    //選擇類別
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            isExpenseCategory = true
            //顯示 支出 選單-類別的第一個
            categoryLabel.text = Expense.expenseCategories.first?.rawValue
            
        }else{
            isExpenseCategory = false
            //顯示 收入 選單-類別的第一個
            categoryLabel.text = Expense.incomeCategories.first?.rawValue
        }
    }
    
    //傳資料到選類別頁面
    @IBSegueAction func goSelectType(_ coder: NSCoder) -> SelectTypeCollectionViewController? {
        return SelectTypeCollectionViewController(coder: coder, isExpenseCategory: isExpenseCategory ?? true)
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
