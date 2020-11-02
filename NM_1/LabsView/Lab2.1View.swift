//
//  Lab2.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 29.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct ststemOfFunction {
    var size: Int
    let f: [([Double])->Double]
    let df: [[([Double])->Double]]
    let p: [([Double])->Double]
    let fImage: Image
    let dfImage: Image
    let pImage: Image
    let graph: Image
    
    func NiewtonsMethod(x: [Double], acurcy: Double = 0.001, count: Int = 1) -> ([Double], Int){
        
        var A = Matrix(rows: size, columns: size, defaultValue: 0)
        var B = Matrix(rows: size, columns: 1, defaultValue: 0)
        for i in 0..<size {
            for j in 0..<size {
                A[i,j] = df[i][j](x)
            }
            B[i,0] = -f[i](x)
        }
        let new_x = (Matrix(column: x) + SolveSLAE(A: A, B: B)!).Transpose().elements[0]
        return (abs((Matrix(column: x) - Matrix(column: new_x)).NormOfMartix1()) > acurcy) ?
            NiewtonsMethod(x: new_x, acurcy: acurcy, count: count+1) :
            (new_x, count)
    }

    func SimpleIterationMethod(x: [Double], acurcy: Double = 0.001, count: Int = 1) -> ([Double], Int){
        let x_new = p.map{$0(x)}
        return abs((Matrix(column: x) - Matrix(column: x_new)).NormOfMartix1()) > acurcy ?
            SimpleIterationMethod(x: x_new, acurcy: acurcy, count: count+1) :
            (x_new, count)
    }

}

struct Lab2_1View: View {
    enum Method {
        case simpleIteration, Newton
    }
    @EnvironmentObject var Settings: UserSettings
    @State var numbersAfterPoint = 1.0
    @State var method: Method = .simpleIteration
    @State var IndexSelectFunction = 1
    @State var x0: [Double] = [1.0, 1.0, 1.0]
    let functions: [ststemOfFunction]
    init(){
        let f1: ([Double])->Double = {(log($0[0]+1) - pow($0[0], 3) + 1)}
        let df1_1_1: ([Double])->Double = {(1/($0[0]+1))-(3*$0[0]*$0[0])}
        let p1_1_1: ([Double])->Double = {pow((log($0[0]+1)+1), 1/3)}
        let s1 = ststemOfFunction(
            size: 1,
            f: [f1],
            df: [[df1_1_1]],
            p: [p1_1_1],
            fImage: Image("f.2.1.18"),
            dfImage: Image("df.2.1.18"),
            pImage: Image("p.2.1.18"),
            graph: Image("g.2.1.18")
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
    func result() -> AnyView {
        var result = ([0.0], -1)
        
        if self.method == Method.simpleIteration{
            result = functions[IndexSelectFunction].NiewtonsMethod(x: x0.dropLast(x0.count-functions[IndexSelectFunction].size), acurcy: pow(0.1, self.numbersAfterPoint))
        } else {
            result = functions[IndexSelectFunction].SimpleIterationMethod(x: x0.dropLast(x0.count-functions[IndexSelectFunction].size), acurcy: pow(0.1, self.numbersAfterPoint))
        }
        guard result.1 > 0 else {
            return AnyView(Text("Ошибка"))
        }
        return AnyView(
            VStack{
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
    var body: some View {
        ScrollView(){
            VStack(alignment: .center){
                Group{
                    HStack{
                        Text("Решение уравниния")
                            .font(.title)
                            .padding(.leading)
                        Image("f0")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 95)
                            .clipped()
                            .padding(.top, 5)
                    }
                    Picker("", selection: self.$IndexSelectFunction){
                        Text("Вариант 2.1.18").tag(0)
                        Text("Вариант 2.2.18").tag(1)
                    }
                    .padding()
                    .frame(height: 80)
                    functions[IndexSelectFunction].fImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                        .clipped()
                    functions[IndexSelectFunction].graph
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .padding(.horizontal)
                }
                Picker("", selection: self.$method){
                    Text("Метод простых итераций").tag(Method.simpleIteration)
                    Text("Метод Нтютона").tag(Method.Newton)
                }.frame(height: 80)
                .padding()
                
                (self.method == .simpleIteration ?
                    functions[IndexSelectFunction].pImage
                    : functions[IndexSelectFunction].dfImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 300)
                    .padding()
                HStack{
                    Text("Начальное приближение :")
                    VStack{
                        ForEach(0..<functions[IndexSelectFunction].size){ i in
                            TextField("\(x0[i])", value: self.$x0[i], formatter: self.Settings.numberFormater)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }

                    }
                }.padding(.horizontal)
                Text("Точность решения:").font(.title).padding(.leading)
                HStack{
                    Text(String(pow(0.1, numbersAfterPoint))).padding(.leading)
                    Slider(value: $numbersAfterPoint, in: 1...10, step: 1).padding([.horizontal])
                }
                self.result()
    
            }
        }
    }
}

struct Lab2_1View_Previews: PreviewProvider {
    static var previews: some View {
        Lab2_1View()
    }
}
