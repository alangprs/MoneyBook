//
//  AddExpenseItemTableViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/22.
//費用添加

import UIKit
import CoreData

class AddExpenseItemTableViewController: UITableViewController{
    //日期顯示
    @IBOutlet weak var datePickerTextField: UITextField!
    //輸入金額
    @IBOutlet weak var moneyNumber: UILabel!
    //收入、支出 選擇
    @IBOutlet weak var SelectTypeSegmented: UISegmentedControl!
    //顯示類別
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    //顯示帳戶
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountImage: UIImageView!
    //金額圖片
    @IBOutlet weak var amountImage: UIImageView!
    //收據圖片
    @IBOutlet weak var receiptImage: UIImageView!
    //備註
    @IBOutlet weak var memoTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var isExpenseCategory:Bool? //控制支出、收入
    let imagePickerController = UIImagePickerController()
    var date:String? //存日期
    var selectDatePicker:Date?
    var archiveData:ArchiveData? //存檔資料
    var container:NSPersistentContainer? //使用coredata存檔功能
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upDataUI()
    }
    //載入UI畫面
    func upDataUI(){
        createDatepicker()//初始化datePicker功能
        //初始化日期
        if let selectDatePicker = selectDatePicker{
            datePickerTextField.text = dateFormatter(date: selectDatePicker)
            datePicker.date = selectDatePicker
        }
        
        if let archiveData = archiveData{ //修改資料
            datePickerTextField.text = date
            
            if let date = archiveData.date{
                datePickerTextField.text = date
                
            }
            date = archiveData.date
            moneyNumber.text = "\(archiveData.sum)"
            categoryLabel.text = archiveData.category
            categoryImage.image = UIImage(named: archiveData.category!)
            accountLabel.text = archiveData.account
            accountImage.image = UIImage(named: archiveData.account!)
            memoTextField.text = archiveData.memo
            //收據照片
            if archiveData.photo != nil{
                receiptImage.image = UIImage(data: archiveData.photo!)
                print("add畫面 載入圖片")
            }
            //判斷收入 ＯＲ 支出
            if archiveData.isExpense == false{
                SelectTypeSegmented.selectedSegmentIndex = 1
            }else{
                SelectTypeSegmented.selectedSegmentIndex = 0
            }
            
        }else{ //新增資料
            //初始化 類別
            categoryLabel.text = Expense.expenseCategories.first?.rawValue
            categoryImage.image = UIImage(named: Expense.expenseCategories.first!.rawValue)
            //初始化 帳戶
            accountLabel.text = Expense.accounts.first?.rawValue
            accountImage.image = UIImage(named: "\(Expense.accounts.first!.rawValue)")
        }
        
    }
    //準備回monthly的資料。 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //判斷 回去終點(destination)是不是 Monthly
        if let controller = segue.destination as? MonthlyCalendarViewController,
           let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            //如果存檔沒資料 新增資料
            if archiveData == nil{
                //取得自定義資料
                let expenseItem = ArchiveData(context: appDelegate.persistentContainer.viewContext)
                expenseItem.date = datePickerTextField.text
                expenseItem.sum = Int32(moneyNumber.text!) ?? 0
                expenseItem.category = categoryLabel.text
                expenseItem.isExpense = isExpenseCategory ?? true
                expenseItem.account = accountLabel.text
                //將date日期傳回去
                controller.selectDatePicker = datePicker.date
                //照片
                if let photo = receiptImage.image{
                    expenseItem.photo = photo.pngData()
                    print("add新增照片")
                }
                //備註
                if let memo = memoTextField.text{
                    expenseItem.memo = memo
                }
                archiveData = expenseItem
                
            }else{ //如果有資料
                archiveData?.date = dateFormatter(date: datePicker.date)
                archiveData?.sum = Int32(moneyNumber.text!) ?? 0
                archiveData?.category = categoryLabel.text
                archiveData?.isExpense = isExpenseCategory ?? true
                archiveData?.account = accountLabel.text
                archiveData?.memo = memoTextField.text
                //照片
                if let photo = receiptImage.image?.pngData(){
                    archiveData?.photo = photo
                    print("add有收據照片")
                }
                print("add修改資料")
            }
        }
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
                performSegue(withIdentifier: "\(ComputerViewController.self)", sender: nil)
            case .category: //類別
                performSegue(withIdentifier: "\(SelectTypeCollectionViewController.self)", sender: nil)
            case .account: //帳戶類別
                performSegue(withIdentifier: "\(AccountTableViewController.self)", sender: nil)
            }
        //選填資料
        case .additionalDatas:
            let additionalDatas = AdditionalDatas.allCases[indexPath.row]
            switch additionalDatas {
            case .receiptPhoto: //收據照片
                selectPhotoController()
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
        datePickerTextField.text = dateFormatter(date: datePicker.date)
        //關閉月曆
        self.view.endEditing(true)
        
    }
    func dateFormatter(date:Date) -> String {
        let dateFormatter = DateFormatter() //日期樣式設定
        dateFormatter.dateStyle = .medium //文字顯示：中
        dateFormatter.dateFormat = "yyyy年MM月dd日" //日期顯示方式 年、月、日
        return dateFormatter.string(from: date)
    }
    //設定datePicker
    func createDatepicker(){
        //設定日期選擇樣式
        datePicker.preferredDatePickerStyle = .wheels
        //只要日期
        datePicker.datePickerMode = .date
        //設置語言環境：台灣
        datePicker.locale = Locale(identifier: "zh_TW")
        //dateTextfield點下去時跳出datePicker選單
        datePickerTextField.inputView = datePicker
        datePickerTextField.inputAccessoryView = createToolBar() //執行工具
    }
    //選擇類別
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            isExpenseCategory = true
            //預設顯示 支出 選單-類別的第一個
            categoryLabel.text = Expense.expenseCategories.first?.rawValue
            categoryImage.image = UIImage(named: Expense.expenseCategories.first!.rawValue)
        }else{ //選擇到收入時
            isExpenseCategory = false
            //顯示 收入 選單-類別的第一個
            categoryLabel.text = Expense.incomeCategories.first?.rawValue
            categoryImage.image = UIImage(named: Expense.incomeCategories.first!.rawValue)
        }
        //預設顯示 帳戶 選單的第一個
        accountLabel.text = Expense.accounts.first?.rawValue
        accountImage.image = UIImage(named: "\(Expense.accounts.first!.rawValue)")
    }
    
    //傳資料到選擇類別
    @IBSegueAction func goSelectType(_ coder: NSCoder) -> SelectTypeCollectionViewController? {
        return SelectTypeCollectionViewController(coder: coder, isExpenseCategory: isExpenseCategory ?? true)
    }
    
    //讓 選擇類別、選擇帳戶、填寫金額 回來,再取得選取到的row資料後，顯示在這頁
    @IBAction func unwindToAddExpenseItemTableViewController(_ unwindSegue: UIStoryboardSegue) {
        //如果是從選擇類別回的資料 設定支出、收入類別
        if let categorySource = unwindSegue.source as? SelectTypeCollectionViewController,
           let row = categorySource.row{
            //更新選到的 支出類別
            if SelectTypeSegmented.selectedSegmentIndex == 0{
                let category = Expense.expenseCategories[row].rawValue
                categoryLabel.text = category
                categoryImage.image = UIImage(named: category)
                
            }else{
                //更新選到 收入 類別
                let category = Expense.incomeCategories[row].rawValue
                categoryLabel.text = category
                categoryImage.image = UIImage(named: category)
            }
            
            //如果資料是從 選擇 帳戶 回來
        }else if let accountSource = unwindSegue.source as? AccountTableViewController,
                 let row = accountSource.row{
            
            let account = Expense.accounts[row].rawValue
            accountLabel.text = account
            accountImage.image = UIImage(named: account)
            
            //從計算機回來
        }else if let sumNumber = unwindSegue.source as? ComputerViewController,
                 let sum = sumNumber.sum{
            moneyNumber.text = "\(sum)"
        }
        
    }
    
    //點Ｘ 回monthly頁面
    @IBAction func goBackMonthly(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        print("回上一頁")
    }
    
}

//Delegate 設定ImagePickerController
extension AddExpenseItemTableViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //彈跳出 是要選照片 還是拍照選項
    func selectPhotoController(){
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //相機
        let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in
            self.turnOnTheCamera() //開啟相機
        }
        controller.addAction(cameraAction)
        
        //相簿
        let phoneAction = UIAlertAction(title: "相簿", style: .default) { _ in
            self.trunOnPhone()
        }
        controller.addAction(phoneAction)
        
        //取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    //開啟相簿功能
    func trunOnPhone(){
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    //開啟相機功能
    func turnOnTheCamera(){
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    //讀選到的圖片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //讀取info選到的照片
        receiptImage.image = info[.originalImage] as? UIImage
        //點選完後回原本頁面
        dismiss(animated: true, completion: nil)
    }
    
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

