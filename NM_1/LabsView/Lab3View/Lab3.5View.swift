//
//  Lab3.5View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab3_5View: View {
    @EnvironmentObject var Settings: UserSettings
    enum Method{
        case rectangle, trapeze, simpson
    }
    struct variant {
        let f: ((Double)->Double)
        let image: Image
        let F: ((Double)->Double)
    }
    let variants: [variant]
    @State var method = Method.rectangle
    @State var selectVariantsIndex = 0
    @State var k = 2
    @State var part = 4
    @State var x1 = -1.0
    @State var x2 = 1.0
    var h2: Double{
        h1/Double(k)
    }
    var h1: Double{
        (x2-x1)/Double(part)
    }
    init(){

        let y1: ((Double)->Double) = {$0/(2*$0+5)}
        let F1 = {(x: Double)->Double in
            return x*x/4 - 5/4*log(2*x+5)
        }
        let y2: ((Double)->Double) = {$0/(16-pow($0,4))}
        let F2 = {(x: Double)->Double in
            return (log(abs((4+pow(x,2))/(4-pow(x,2))))/16)
        }
        let y3: ((Double)->Double) = {$0/((2*$0+7)*(3*$0+4))}
        let F3 = {(x: Double)->Double in
            return ((7/26*log(abs(2*x+7))) - (4/39*log(abs(3*x+4))))
        }
        let y0: ((Double)->Double) = {$0/pow((3*$0+4), 2)}
        let F0: ((Double)->Double) = {$0}
        variants = [
           // variant(f: y1, image: Image("y1"), F: F1),
            variant(f: y2, image: Image("y2"), F: F2),
            variant(f: y3, image: Image("y3"), F: F3),
            variant(f: y0, image: Image("y0"), F: F0)
        ]
    }
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                Text("Вычисление интеграла:")
                    .font(.title)
                Image("F")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                ChengeIndexView(index: $selectVariantsIndex, images: variants.map{$0.image})
                    .frame(height: 100)

                Text("Границы интегрирования:")
                    .font(.title)
                HStack{
                    Text("X0 = ")
                    TextField("\(x1)", value: self.$x1, formatter: self.Settings.numberFormater)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 60)
                }
                HStack{
                    Text("X1 = ")
                    TextField("\(x2)", value: self.$x2, formatter: self.Settings.numberFormater)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 60)
                }
                Stepper(value: $part, in: 2...50) {
                    Text("Частей в первом разбиени: \(part)")
                }
                Stepper(value: $k, in: 2...4) {
                    Text("Частей во втором разбиени: \(k*part)")
                }
                Group{
                    Text("Вычисление методом:")
                        .font(.title)
                    Picker("", selection: self.$method){
                        Text("Прямоугольников").tag(Method.rectangle)
                        Text("Трапеций").tag(Method.trapeze)
                        Text("Парабол").tag(Method.simpson)
                    }.pickerStyle(SegmentedPickerStyle())
                    result()
                }
            }.padding(.horizontal)
        }
    }
    func result()->AnyView{
        let i = integrals(f: variants[selectVariantsIndex].f,
                          x1: x1, x2: x2)
        var F1: Double
        var F2: Double
        var p: Int
        switch method {
        case .rectangle:
            F1 = i.rectangleMethod(h: h1)
            F2 = i.rectangleMethod(h: h2)
            p = 2
        case .trapeze:
            F1 = i.trapezeMethod(h: h1)
            F2 = i.trapezeMethod(h: h2)
            p = 2
        case .simpson:
            F1 = i.simpsonMethod(h: h1)
            F2 = i.simpsonMethod(h: h2)
            p = 4
        }
        let rrr = i.rungeRombergMethod(k: k, p: p, F1: F2, F2: F1)
        let F = variants[selectVariantsIndex].F
        let error1 = F(x2) - F(x1) - F1
        let error2 = F(x2) - F(x1) - F2
        let errorRRR = F(x2) - F(x1) - rrr
        
        return AnyView(
            VStack(alignment: .leading, spacing: 10){
                Text("С шагом h1 = \(h1)")
                    .font(.title)
                Text("F ≈ \(F1)")
                Text("Абсолютная погрешность = \(error1)")
                Text("С шагом h2 = \(h2)")
                    .font(.title)
                Text("F ≈ \(F2)")
                Text("Абсолютная погрешность = \(error2)")
                Text("Методом Рунге-Ромберга-Ричардсона:")
                    .font(.title)
                Text("F ≈ \(rrr)")
                Text("Абсолютная погрешность = \(errorRRR)")
            }
        )
    }
}

struct Lab3_5View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_5View()
    }
}
