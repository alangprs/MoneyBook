//
//  ExpenseItemData.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/23.
//放要傳遞、解析資料

import Foundation

//支出類別 、收入類別
enum DataCategorys:String, CaseIterable {
    case neededDatas,additionalDatas
}
//必填資料：時間、類別、金額、帳戶
enum NeededDatas:String, CaseIterable {
    case date, amount, category, account
}
//選填資料： 收據照片、備註
enum AdditionalDatas:String, CaseIterable {
    case receiptPhoto, memo
}

//支出類別
enum ExpenseCategory:String,CaseIterable,Codable{
    case food = "飲食"
    case clothes = "服飾"
    case house = "居家"
    case transportation = "交通"
    case education = "教育"
    case entertainment = "娛樂"
}

//收入類別
enum IncomeCategory:String,CaseIterable,Codable {
    case salary = "薪水"
    case bonus = "獎金"
    case investment = "投資"
}

//帳戶類別
enum Account:String, CaseIterable, Codable {
    case cash = "現金"
    case bank = "銀行"
    case creditCard = "信用卡"
}

