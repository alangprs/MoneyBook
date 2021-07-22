//
//  AddExpenseItemTableViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/22.
//費用添加

import UIKit

class AddExpenseItemTableViewController: UITableViewController {
    
    @IBOutlet weak var datePickerTextField: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatepicker()//初始化datePicker
        
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
