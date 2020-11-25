//
//  Lab4.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 18.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

// y" + p(x)y' + q(x)y = f(x)
// a1*y'(x0) +  b1*y(x0) =  c1
// a2*y'(x1) +  b2*y(x1) =  c2
// y'(x1) = y1 =  c - b*y(x1)
struct Lab4_1View: View {
    init(){
        let v1 = variant(p: {(-$0-1)/$0}, q: {1/$0}, f: {_ in 0.0}, x0: 1, x1: 2, y0: 2+exp(1), dy0: 1+exp(1), image: Image("4.1.1"), decision: {1+$0+exp($0)})
        
        let d2: ((Double)->Double) = {(cos($0)+(11*sin($0)-sin(3*$0))/8)}
        let v2 = variant(p: {_ in 0.0}, q: {_ in 1.0}, f: {sin(3*$0)}, x0: 0, x1: 1, y0: 1, dy0: 1, image: Image("4.1.2"), decision: d2)
        
        self.variants = [v1, v2]
    }
    struct variant{
        let p: ((Double)->Double)
        let q: ((Double)->Double)
        let f: ((Double)->Double)
        let x0: Double
        let x1: Double
        let y0: Double
        let dy0: Double
        let image: Image
        let decision: ((Double)->Double)
    }
    var p: Double{
        method == CauchyProblem.methods.Adams ? 1/(2 - 1) : 1/(16 - 1)
    }
    @State var index = 0
    @State var parts2 = 10
    @State var method = CauchyProblem.methods.Eiler
    var h: Double{
        (variants[index].x1 - variants[index].x0)/(Double(parts2*2))
    }
    var h2: Double{
        (variants[index].x1 - variants[index].x0)/Double(parts2)
    }
    let variants: [variant]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Решение задачи Коши:")
                    .font(.title)
                ChengeIndexView(index: $index, images: variants.map{$0.image})
                    .frame(height: 120)
                Text("Метод решения:")
                    .font(.title)
                Picker("Метод: ", selection: self.$method){
                    Text("Эйлера").tag(CauchyProblem.methods.Eiler)
                    Text("Рунге-Кнуты").tag(CauchyProblem.methods.RK)
                    Text("Адамса").tag(CauchyProblem.methods.Adams)
                }.pickerStyle(SegmentedPickerStyle())
                Stepper(value: $parts2, in: 4...50) {
                    VStack(alignment: .leading) {
                        Text("N = \(2*parts2)")
                        Text("h = \(h)")
                    }
                }
                result()
            }
        }.padding(.horizontal)
    }
    func result() -> AnyView{
        let  v = variants[index]
        let res = CauchyProblem(p: v.p, q: v.q, f: v.f, x0: v.x0, x1: v.x1, y0: v.y0, dy0: v.dy0)
            .table(method: method, h: h)
        let x = res.0
        let y = res.1.map({$0.first ?? 0.0})
        let yt = x.map{v.decision($0)}
        let errors = zip(y,yt).map{$0.0-$0.1}
        
        let res2 = CauchyProblem(p: v.p, q: v.q, f: v.f, x0: v.x0, x1: v.x1, y0: v.y0, dy0: v.dy0)
            .table(method: method, h: h2)
        let y2 = res2.1.map({$0.first ?? 0.0})
        var RR: [[Double]] = [[],[]]
        for i in 0..<y2.count{
            if i*2 < y.count{
                RR[0].append(x[i*2])
                RR[1].append(y[i*2] - y2[i])
            } else {
                break
            }
        }
        return AnyView(
            VStack(alignment: .leading, spacing: 15) {
                Text("График:")
                    .font(.title)
                GraphView(graphs: Graphs(graphs: [
                    Graph(x.map({($0, v.decision($0))}), color: Color.red),
                    Graph(Array(zip(x,y)), color: Color.green)
                ],  markOnX: 1.0, markOnY: 1.0))
                    .padding(5)
                    .background(Color.gray.opacity(0.17))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: .infinity, height: 350)
                HStack {
                    Text("точное решение").foregroundColor(.red)
                    Text("численное решение").foregroundColor(.green)
                }
                Text("Значение в узлах численного и точного решений:")
                    .font(.title)
                Text("x, y(ч.р.), y(т.р.), ∆")
                ScrollView(.horizontal){
                    UnchangeableMatrixView(matrix: Matrix([x, y, yt, errors]).Transpose())
                }
                Text("Оцентка точности методом Рунге-Ромберга")
                    .font(.title)
                Text("x, R")
                UnchangeableMatrixView(matrix: Matrix(RR).Transpose())
            }
        )
    }
}

struct Lab4_1View_Previews: PreviewProvider {
    static var previews: some View {
        Lab4_1View()
    }
}
