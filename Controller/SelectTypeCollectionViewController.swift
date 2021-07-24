//
//  SelectTypeCollectionViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/23.
//類別選擇

import UIKit

private let reuseIdentifier = "\(TypeViewCellCollectionViewCell.self)"

class SelectTypeCollectionViewController: UICollectionViewController {
    
    var isExpenseCategory:Bool? //控制是收入還是支出類別
    init?(coder:NSCoder,isExpenseCategory:Bool){
        self.isExpenseCategory = isExpenseCategory
        super .init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var row:Int? //存 選到的第幾個照片(row)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    //準備要回傳給AddExpenseItemTableViewController選到的row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        row = collectionView.indexPathsForSelectedItems?.first?.row
        print("選到的內容",row)
    }
   
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //選擇支出、收入 要顯示的section數量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //如果選擇到是支出 回傳定義支出的enum內容
        if isExpenseCategory == true{
            print("支出")
            return Expense.expenseCategories.count
        }else{
            print("收入")
            return Expense.incomeCategories.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //轉型成自定義的cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TypeViewCellCollectionViewCell else{return UICollectionViewCell()}
        
        //設定cell 要顯示的內容
        //如果是選到 支出
        if isExpenseCategory == true{
            let expenseCategories = Expense.expenseCategories[indexPath.row]
            cell.typeImageView.image = UIImage(named: "\(expenseCategories.rawValue)")
            cell.typeNameLabel.text = expenseCategories.rawValue
        }else{
            //選到的是 收入
            let incomeCategories = Expense.incomeCategories[indexPath.row]
            cell.typeImageView.image = UIImage(named: "\(incomeCategories.rawValue)")
            cell.typeNameLabel.text = incomeCategories.rawValue
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
