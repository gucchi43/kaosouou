//
//  BirthdaySelectViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/12/12.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import ADDatePicker

class BirthdaySelectViewController: UIViewController {
    
    @IBOutlet weak var datePicker: ADDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        customDatePicker1()
    }
    
    
    func customDatePicker1(){
        datePicker.yearRange(inBetween: 1890, end: 2022)
        datePicker.selectionType = .circle
        datePicker.bgColor = .black
        datePicker.deselectTextColor = .white
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .white
        datePicker.selectedTextColor = selectedKeyColor()
        datePicker.intialDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
    }
    
    func selectedKeyColor() -> UIColor {
        var selectColor: UIColor!
        if let currentUser = AccountManager.shared.currentUser {
            if currentUser.gender == 2{
                selectColor = UIColor.girlBrandColor()
            } else {
                selectColor = UIColor.boyBrandColor()
            }
//            return selectColor
        } else {
            selectColor = UIColor.girlBrandColor()
        }
        return selectColor
    }
    
    func getBirthdayString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        let birthdayString = dateformatter.string(from: datePicker.getSelectedDate())
        
        print("birthdayString",birthdayString)
        
        return birthdayString
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        next()
    }
    
    func next() {
        let birthdayString = getBirthdayString()
        if let currentUser = AccountManager.shared.currentUser {
            currentUser.birthday = birthdayString
            currentUser.update({ (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("birthday設定成功")
                    AppDelegate.shared.rootViewController.showOnboardScreen()
                }
            })
        } else {
            print("currentUser ")
        }
    }
    
    
}
