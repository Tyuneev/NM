//
//  Lab3.4View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 07.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI


struct Lab3_4View: View {
    @EnvironmentObject var Settings: UserSettings
    @ObservedObject var pointsXY = ObservableMatrix(Matrix([[-0.2, 0.0, 0.2, 0.4, 0.6],
                                                           [-0.40136, 0.0, 0.40136, 0.81152, 1.2435]]).Transpose())
    @State var x: Double = 1.0

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Таблично заданная функция (x, y):")
                    .font(.title)
                ChangeableMatrixView().environmentObject(pointsXY)
                Text("Производные в точке x:")
                    .font(.title)
                HStack{
                    Text("x = ")
                    TextField("\(x)", value: self.$x, formatter: self.Settings.numberFormater)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 60)
                    
                }
                result()
            }.padding(.horizontal)
            
        }
    }
    func result()->AnyView{
//        let d = derivatives(points: makePointsPair())
//        let dx1_l, dx1_r_tmp) = d.derivative(x, pow: 1, accuracy: 1)
//        let dx1_2 = d.derivative(x, pow: 1, accuracy: 2).0
//        let dx2 = d.derivative(x, pow: 2).0
        
        let d = derivatives(points: makePointsPair())
        guard let dx1 = d.dir1(x),
              let dx2 = d.dir2(x)
        else{
            return AnyView(Text("Ошибка"))
        }
        
        return AnyView(VStack(alignment: .leading){
            Text("Производная первого порядка:")
            Text(Settings.numberFormater.string(for: NSNumber(value: dx1)) ?? "")
            Text("Производная второго порядка:")
            Text(Settings.numberFormater.string(for: NSNumber(value: dx2)) ?? "")
        })
    }
    func  makePointsPair()-> [(Double, Double)]{
        pointsXY.WarpedMatrix.elements.map{($0[0], $0[1])}
    }
}

struct Lab3_4View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_4View()
    }
}
