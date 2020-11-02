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
    private func update(){
        UserDefaults.standard.set(self.maximumFractionDigits, forKey: "digits")
        self.numberFormater.maximumFractionDigits = maximumFractionDigits
    }
    func addFractionDigits() {
        if self.maximumFractionDigits < 10{
            maximumFractionDigits += 1
            update()
        }
        
        
    }
    func removeFractionDigits() {
        if self.maximumFractionDigits > 1{
            maximumFractionDigits -= 1
            update()
        }
    }

    init(){
        let n = UserDefaults.standard.integer(forKey: "digits")
        if n == 0 {
            self.maximumFractionDigits = 3
            UserDefaults.standard.set(3, forKey: "digits")
        } else {
            self.maximumFractionDigits = n
        }
        self.numberFormater = NumberFormatter()
        self.numberFormater.maximumFractionDigits = n
    }
    
}
