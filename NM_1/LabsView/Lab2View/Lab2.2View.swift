//
//  Lab2.2View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 19.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab2_2View: View {
    enum Method {
        case simpleIteration, Newton
    }
    @EnvironmentObject var Settings: UserSettings
    @State var accuracy = 0.1
    @State var method: Method = .simpleIteration
    @State var x0 = [1.0, 1.0]
    
    @State var IndexSelectFunction = 0
    let functions: [ststemOfFunction]
    init(){
        let f1_1: ([Double])->Double = {(pow($0[0],3) - 2*pow($0[0], 2) - 10*$0[0] + 15)}
        let df1_1_1: ([Double])->Double = {(3*pow($0[0], 2) - 4*$0[0] - 10)}
        let p1_1_1: ([Double])->Double = {(pow($0[0],3) - 2*pow($0[0], 2) + 15)/10}
        let s1 = ststemOfFunction(
            size: 1,
            f: [f1_1],
            df: [[df1_1_1]],
            p: [p1_1_1],
            fImage: Image("f.2.1.5"),
            dfImage: Image("df.2.1.5"),
            pImage: Image("p.2.1.5"),
            graph: Image("g.2.1.5")
        )
        
        let f2_1: ([Double])->Double = {4*$0[0]-cos($0[1])}
        let f2_2: ([Double])->Double = {4*$0[1]-exp($0[0])}
        let f2: [([Double])->Double] = [f2_1, f2_2]
        
        let df2_1_1: ([Double])->Double = {_ in 4.0}
        let df2_1_2: ([Double])->Double = {sin($0[1])}
        let df2_2_1: ([Double])->Double = {-exp($0[0])}
        let df2_2_2: ([Double])->Double = {_ in 4.0}
        
        let df2: [[([Double])->Double]] = [[df2_1_1, df2_1_2],
                                           [df2_2_1, df2_2_2]]
        let p2: [([Double])->Double] = [
            {cos($0[1])/4},
            {exp($0[0])/4}
        ]
        let s2 = ststemOfFunction(
            size: 2,
            f: f2,
            df: df2,
            p: p2,
            fImage: Image("f.2.2.18"),
            dfImage: Image("df.2.2.18"),
            pImage: Image("p.2.2.18"),
            graph: Image("g.2.2.18")
        )
        self.functions = [s1, s2]
    }
    var body: some View {
        ScrollView(){
            VStack(alignment: .leading){
                Group{
                    HStack{
                        Text("Решение уравниния")
                            .font(.title)
                        Image("f0")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 95)
                            .clipped()
                    }
                    ChengeIndexView(index: $IndexSelectFunction,
                                    images: functions.map{$0.fImage})
                    .frame(height: 100)
                }
                Group{
                    functions[IndexSelectFunction].graph
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .padding(.horizontal)
                }
                Text("Метод")
                    .font(.title)
                    .padding(.vertical)
                Picker("", selection: self.$method){
                    Text("простых итераций").tag(Method.simpleIteration)
                    Text("Нтютона").tag(Method.Newton)
                }.pickerStyle(SegmentedPickerStyle())
                (self.method == .simpleIteration ?
                    functions[IndexSelectFunction].pImage
                    : functions[IndexSelectFunction].dfImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 300)
                    .padding(.vertical)
                HStack{
                    Text("Начальное приближение :")
                    VStack{
                        ForEach(0..<functions[IndexSelectFunction].size, id: \.self){ i in
                            TextField("\(x0[i])", value: self.$x0[i], formatter: self.Settings.numberFormater)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 50)
                        }
                    }
                }
                AccuracyView(accuracy: $accuracy)
                    .padding(.vertical)
                self.result()
            }
            .padding(.horizontal)
        }
    }
//    func graph() -> AnyView {
//        var graphs: [Graph] = []
//        for g in functions[IndexSelectFunction].f{
//            graphs.append(
//                Graph(function: {x in g([x])}, from: -2, to: 2, step: 0.01)
//            )
//        }
//        return AnyView(
//            GraphView(graphs: Graphs(graphs: graphs,  markOnX: 1.0, markOnY: 1.0))
//        )
//    }
    func result() -> AnyView {
        var result = ([0.0], -1)
        if self.method == Method.simpleIteration{
            result = functions[IndexSelectFunction].NiewtonsMethod(x: x0.dropLast(x0.count-functions[IndexSelectFunction].size), acurcy: accuracy)
        } else {
            result = functions[IndexSelectFunction].SimpleIterationMethod(x: x0.dropLast(x0.count-functions[IndexSelectFunction].size), acurcy: accuracy)
        }
        guard result.1 > 0 else {
            return AnyView(Text("Ошибка"))
        }
        return AnyView(
            VStack(alignment: .leading){
                HStack{
                    Text("x = ")
                    VStack{
                        ForEach(result.0, id: \.self){ res in
                            Text("\(res)")
                        }
                    }
                }
                Text("Итераций проведено: \(result.1)")
            }
        )
    }
}

struct Lab2_2View_Previews: PreviewProvider {
    static var previews: some View {
        Lab2_2View()
    }
}
