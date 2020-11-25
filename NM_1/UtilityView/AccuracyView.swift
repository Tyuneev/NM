//
//  Accuracy View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 04.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct AccuracyView: View {
    let q = 0.1
    @Binding var accuracy: Double
    var s: String{
        var tmp = ""
        let count = Int(n)
            for _ in 0..<count {
                tmp += "0"
            }
        
        return ("0." + tmp + "1")
    }
    @State var n = 1.0
    var body: some View {
        VStack(alignment: .leading){
            Text("Точность:")
                .font(.title)
            Text(s)
                .padding(.top, 4)
            Slider(value: $n, in: 1...6){ _ in
                self.accuracy = pow(q, n)
            }
        }
    }
}


