//
//  ComputerViewController.swift
//  MoneyBook
//
//  Created by 翁燮羽 on 2021/7/24.
//計算機顯示

import UIKit

class ComputerViewController: UIViewController {
    
    //顯示總和
    @IBOutlet weak var sumLabel: UILabel!
    
    //運算前畫面上數字
    var previousNumber = 0
    //目前畫面上數字
    var numberOnScreen = 0
    //存 算式 符號的顯示
    var symbol:String?
    //存目前算式
    var operation:OperationType = .none
    //是否計算中
    var performingMath = false
    //是否要開啟新的計算
    var startNew = true
    //存運算出的結果
    var sum:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    //取得數字
    @IBAction func calculate(_ sender: UIButton) {
        //存每個按鈕 取得的數字
        let number = sender.tag
        //如果有值，代表要增加數字
        if sumLabel.text != nil{
            if startNew == true{
                sumLabel.text = "\(number)"
                startNew = false
            }else{
                if sumLabel.text == "0" ||
                    sumLabel.text == "+" ||
                    sumLabel.text == "-" ||
                    sumLabel.text == "*" ||
                    sumLabel.text == "/" {
                    sumLabel.text = "\(number)"
                }else{
                    sumLabel.text = sumLabel.text! + "\(number)"
                }
            }
            //存入目前畫面上數字
            numberOnScreen = Int(sumLabel.text!) ?? 0
        }
    }
    
    //加
    @IBAction func add(_ sender: UIButton) {
        sumLabel.text = "+"
        operation = .add
        performingMath = true
        //將目前畫面數字 存入計算前數字
        previousNumber = numberOnScreen
    }
    //減
    @IBAction func subtract(_ sender: UIButton) {
        sumLabel.text = "-"
        operation = .subtract
        performingMath = true
        previousNumber = numberOnScreen
    }
    //乘
    @IBAction func multiply(_ sender: UIButton) {
        sumLabel.text = "*"
        operation = .multiply
        performingMath = true
        previousNumber = numberOnScreen
    }
    //除
    @IBAction func divide(_ sender: UIButton) {
        sumLabel.text = "/"
        operation = .divide
        performingMath = true
        previousNumber = numberOnScreen
    }
    //歸零
    @IBAction func clear(_ sender: UIButton) {
        sumLabel.text = "0"
        previousNumber = 0
        numberOnScreen = 0
        performingMath = false
        startNew = true //開啟新計算
    }
    
    //等於
    @IBAction func giveMeAnswer(_ sender: UIButton) {
        if performingMath == true{
            switch operation {
            case .add:
                sumLabel.text = "\(previousNumber + numberOnScreen)"
                numberOnScreen = previousNumber + numberOnScreen
            case .subtract:
                sumLabel.text = "\(previousNumber - numberOnScreen)"
                numberOnScreen = previousNumber - numberOnScreen
            case .multiply:
                sumLabel.text = "\(previousNumber * numberOnScreen)"
                numberOnScreen = previousNumber * numberOnScreen
            case .divide:
                sumLabel.text = "\(previousNumber / numberOnScreen)"
                numberOnScreen = previousNumber / numberOnScreen
            case .none:
                sumLabel.text = "\(0)"
            }
            performingMath = false //結束計算
            startNew = true
        }
    }
    
    //將資料回傳 AddExpenseItemTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sumLabel.text != nil{
            sum = Int(sumLabel.text!)!
        }
    }
    
    
    
}
