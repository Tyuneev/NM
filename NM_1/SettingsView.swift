//
//  OptionsView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 29.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView{
            HStack{
                Text("Отображать знаков после запятой: \(settings.maximumFractionDigits)")
                Stepper("",
                onIncrement: {
                    settings.addFractionDigits()
                    
                }, onDecrement: {
                    settings.removeFractionDigits()
                    
                })
            }.padding()
            

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
