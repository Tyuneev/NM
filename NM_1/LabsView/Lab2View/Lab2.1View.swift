//
//  Lab2.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 29.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab2_1View: View {
    enum Method {
        case simpleIteration, Newton
    }
    @EnvironmentObject var Settings: UserSettings
    @State var accuracy = 0.1
    @State var method: Method = .simpleIteration
    @State var x0 =  1.0
    @State var IndexSelectFunction = 0
    let functions: [Function]
    init(){
        let f1: (Double)->Double = {(log($0+1) - pow($0, 3) + 1)}
        let df1: (Double)->Double = {((1.0/($0+1.0))-(3.0*$0*$0))}
        let p1: (Double)->Double = {pow((log($0+1)+1), 1/3)}
        let s1 = Function(
            f: f1,
            df: df1,
            p: p1,
            fImage: Image("f.2.1.18"),
            dfImage: Image("df.2.1.18"),
            pImage: Image("p.2.1.18"),
            graph: Image("g.2.1.18")
        )
        
        let p2: (Double)->Double = {(pow($0,3) - 2.0*pow($0,2) + 15.0)/10.0}
        let f2: (Double)->Double = {$0-p2($0)}
        let df2: (Double)->Double = {(3.0*pow($0,2)  - 4.0*$0 - 10.0)}
        let s2 = Function(
            f: f2,
            df: df2,
            p: p2,
            fImage: Image("f.2.1.5"),
            dfImage: Image("df.2.1.5"),
            pImage: Image("p.2.1.5"),
            graph: Image("g.2.1.5")
        )
        

//        let p3_1_1: ([Double])->Double = {(exp($0[0]) - pow($0[0],3) + 3*pow($0[0], 2) - 3)/2}
//        let f3: ([Double])->Double = {$0[0] - p3_1_1($0)}
//        let df3_1_1: ([Double])->Double = {(exp($0[0]) - 3*pow($0[0],2) + 6*$0[0] - 2)}
//
        
//        let f3: ([Double])->Double = {(sin($0[0]) - 2*pow($0[0],2) + 0.5)}
//        let df3_1_1: ([Double])->Double = {(cos($0[0]) - 3*pow($0[0],2) + 6*$0[0] - 2)}
//        let p3_1_1: ([Double])->Double = {(-cos($0[0]) - 4*$0[0])}
//
//        let s3 = ststemOfFunction(
//            size: 1,
//            f: [f3],
//            df: [[df3_1_1]],
//            p: [p3_1_1],
//            fImage: Image("f.2.1.11"),
//            dfImage: Image("df.2.1.11"),
//            pImage: Image("p.2.1.11"),
//            graph: Image("g.2.1.11")
//        )
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
                    .frame(height: 50)
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
                    TextField("\(x0)", value: self.$x0, formatter: self.Settings.numberFormater)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 50)
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
        var (x, count) = (0.0, -1)
        if self.method == Method.simpleIteration{
            (x, count) = functions[IndexSelectFunction].NiewtonsMethod(x: x0, acurcy: accuracy)
        } else {
            (x, count) = functions[IndexSelectFunction].SimpleIterationMethod(x: x0, acurcy: accuracy)
        }
        guard count > 0 else {
            return AnyView(Text("Ошибка"))
        }
        return AnyView(
            VStack(alignment: .leading){
                Text("x = \(x)")
                Text("Итераций проведено: \(count)")
            }
        )
    }
}

struct Lab2_1View_Previews: PreviewProvider {
    static var previews: some View {
        Lab2_1View()
    }
}
