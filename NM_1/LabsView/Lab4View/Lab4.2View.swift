//
//  Lab4.2View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 19.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI
// y" + p(x)y' + q(x)y = f(x)
// a1*y'(x0) +  b1*y(x0) =  c1
// a2*y'(x1) +  b2*y(x1) =  c2


struct Lab4_2View: View {
    init(){
        let p1: ((Double)->Double) = {($0-3)/($0*$0-1)}
        let q1: ((Double)->Double) = {(-1/($0*$0-1))}
        let d1: ((Double)->Double) = {-3+$0+1/(1+$0)}
        let f1: ((Double)->Double) = {_ in 0.0}
        
        let p2: ((Double)->Double) = {(2/$0)}
        let q2: ((Double)->Double) = {_ in -1.0}
        let d2: ((Double)->Double) = {exp($0)/$0}
        let f2: ((Double)->Double) = {_ in 0.0}
        
        let p3: ((Double)->Double) = {(2/$0)}
        let q3: ((Double)->Double) = {_ in -1.0}
        let f3: ((Double)->Double) = {_ in 0.0}
        let d3: ((Double)->Double) = {exp(-$0)/$0}
        
//        let p4: ((Double)->Double) = {_ in 0.0}
//        let q4: ((Double)->Double) = {-2/($0*$0+1)}
//        let f4: ((Double)->Double) = {_ in 0.0}
//        let d4: ((Double)->Double) = {($0*$0+1)}
//

        
        let p4: ((Double)->Double) = {-2/(exp($0)+1)}
        let q4: ((Double)->Double) = {-exp($0)/(exp($0)+1)}
        let f4: ((Double)->Double) = {_ in 0.0}
        let d4: ((Double)->Double) = {exp($0)-1+1/(exp($0)+1)}
        let c2_4 = pow(exp(1),2)*(exp(1.0)+2)/pow((exp(1)+1),2)
        
        self.variants = [
            variant(p: p1, q: q1, f: f1, a1: 1, b1: 0, c1: 0, a2: 1, b2: 1, c2: -0.75, x0: 0, x1: 1, image: Image("4.2.17"), decision: d1),
            variant(p: p2, q: q2, f: f2, a1: 1, b1: 0, c1: 0, a2: 1, b2: 1.5, c2: exp(2), x0: 1, x1: 2, image: Image("4.2.1"), decision: d2),
            variant(p: p3, q: q3, f: f3, a1: 0, b1: 1, c1: exp(-1), a2: 0, b2: 1, c2: 0.5*exp(-2), x0: 1, x1: 2, image: Image("4.2.2"), decision: d3),
            variant(p: p4, q: q4, f: f4, a1: 1, b1: 0, c1: 0.75, a2: 1, b2: 0, c2: c2_4, x0: 0, x1: 1, image: Image("4.2.13"), decision: d4),
            
        ]
    }
    struct variant{
        let p: ((Double)->Double)
        let q: ((Double)->Double)
        let f: ((Double)->Double)
        let a1: Double
        let b1: Double
        let c1: Double
        let a2: Double
        let b2: Double
        let c2: Double
        let x0: Double
        let x1: Double
        let image: Image
        let decision: ((Double)->Double)
        
    }
    @State var accuracy = 0.001
    @State var method = BoundaryProblem.Method.finiteDifference
    var p: Double{
        self.method == BoundaryProblem.Method.finiteDifference ? 1/(2 - 1) : 1/(16 - 1)
    }
    @State var index = 0
    @State var parts2 = 10
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
                    Text("стрельбы").tag(BoundaryProblem.Method.shooting)
                    Text("конечных разностей").tag(BoundaryProblem.Method.finiteDifference)
                }.pickerStyle(SegmentedPickerStyle())
                Stepper(value: $parts2, in: 4...50) {
                    VStack(alignment: .leading) {
                        Text("N = \(2*parts2)")
                        Text("h = \(h)")
                    }
                }
                if method == BoundaryProblem.Method.shooting{
                    AccuracyView(accuracy: $accuracy)
                }
                result()
            }
        }.padding(.horizontal)
    }
    func result() -> AnyView{
        let  v = variants[index]
        let (x, y, count) = BoundaryProblem(p: v.p, q: v.q, f: v.f, a1: v.a1, b1: v.b1, c1: v.c1, a2: v.a2, b2: v.b2, c2: v.c2, x0: v.x0, x1: v.x1).table(h: h, accuracy: accuracy, method: method)
        let yt = x.map{v.decision($0)}
        let errors = zip(y,yt).map{$0.0-$0.1}
    
        var RR: [[Double]] = [[],[]]
        if method == BoundaryProblem.Method.finiteDifference{
            let (_, y2, _) = BoundaryProblem(p: v.p, q: v.q, f: v.f, a1: v.a1, b1: v.b1, c1: v.c1, a2: v.a2, b2: v.b2, c2: v.c2, x0: v.x0, x1: v.x1).table(h: h2, accuracy: accuracy, method: .finiteDifference)
            for i in 0..<y2.count{
                if i*2 < y.count{
                    RR[0].append(x[i*2])
                    RR[1].append(y[i*2] - y2[i])
                } else {
                    break
                }
            }
        }
        
        return AnyView(
            VStack(alignment: .leading, spacing: 15) {
                Text("График:")
                    .font(.title)
                GraphView(graphs: Graphs(graphs: [
                    Graph(Array(zip(x,yt)), color: Color.red),
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
                if method == BoundaryProblem.Method.finiteDifference{
                    Text("Оцентка точности методом Рунге-Ромберга")
                        .font(.title)
                    Text("x, R")
                    UnchangeableMatrixView(matrix: Matrix(RR).Transpose())
                } else {
                    Text("Итераций: \(count)")
                }
            }
        )
    }
}


struct Lab4_2View_Previews: PreviewProvider {
    static var previews: some View {
        Lab4_2View()
    }
}
