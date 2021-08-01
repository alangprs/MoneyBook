//
//  ExpenseItemData.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/23.
//定義要顯示的資料

import Foundation
import UIKit
//定義費用
struct Expense {
    //使用static 產生支出、收戶、帳戶 類別。 static不能複製、複寫要注意
    //支出類別
    static var expenseCategories:[ExpenseCategory] {
        ExpenseCategory.allCases
    }
    //收入
    static var incomeCategories:[IncomeCategory]{
        IncomeCategory.allCases
    }
    //帳戶
    static var accounts:[Account]{
        Account.allCases
    }
}
