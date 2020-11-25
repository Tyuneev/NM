//
//  Settings.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 30.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation


class UserSettings: ObservableObject {
    let numberFormater: NumberFormatter
    @Published var maximumFractionDigits: Int
    @Published var fontSize: Int

    func addFractionDigits() {
        if self.maximumFractionDigits < 10{
            maximumFractionDigits += 1
            UserDefaults.standard.set(self.maximumFractionDigits, forKey: "digits")
            self.numberFormater.maximumFractionDigits = maximumFractionDigits
        }
    }
    func removeFractionDigits() {
        if self.maximumFractionDigits > 1{
            maximumFractionDigits -= 1
            UserDefaults.standard.set(self.maximumFractionDigits, forKey: "digits")
            self.numberFormater.maximumFractionDigits = maximumFractionDigits
        }
    }
    func incrementFontSize(){
        if fontSize < 40 {
            fontSize += 1
            UserDefaults.standard.set(self.fontSize, forKey: "font")
        }
    }
    func decrementFontSize(){
        if fontSize > 5 {
            fontSize -= 1
            UserDefaults.standard.set(self.fontSize, forKey: "font")
        }
    }

    init(){
        let mfd = UserDefaults.standard.integer(forKey: "digits")
        if mfd == 0 {
            self.maximumFractionDigits = 3
            UserDefaults.standard.set(3, forKey: "digits")
        } else {
            self.maximumFractionDigits = mfd
        }
        self.numberFormater = NumberFormatter()
        self.numberFormater.maximumFractionDigits = mfd
        
        
        let fs = UserDefaults.standard.integer(forKey: "font")
        if fs == 0 {
            self.fontSize = 15
            UserDefaults.standard.set(15, forKey: "font")
        } else {
            self.fontSize = fs
        }
    }
    
}
