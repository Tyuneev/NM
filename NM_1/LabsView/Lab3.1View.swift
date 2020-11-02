//
//  Lab3.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab3_1View: View {
    var f: ((Double)->Double) = {exp($0)+$0}
    var fName = "f(x)=x+e^x"
    @EnvironmentObject var Settings: UserSettings
    @ObservedObject var pointsX = ObservableMatrix(Matrix([[-2.0, -1.0, 0.0, 1.0]]))
    var pointsXvarA = [-2.0, -1.0, 0.0, 1.0]
    var pointsXvarB = [-2.0, -1.0, 0.2, 1.0]
    @State var X = -0.5
    var body: some View {
        VStack{
            Text("Функция: \(fName)")
            Text("Точки:")
            ChangeableMatrixView().environmentObject(pointsX)
            UnchangeableMatrixView(matrix:  Matrix([pointsX.WarpedMatrix.elements[0].map{f($0)}]))
//            Text((self.pointsXvarA.reduce(""){$0+String($1)+"  "}))
//            Text((self.pointsXvarB.reduce(""){$0+String($1)+"  "}))
            HStack{
                
                Text("Х = ")
                TextField("\(X)", value: self.$X, formatter: self.Settings.numberFormater)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }

            Text("f(x) = \(f(X) ))")
            Text("Интерполяционный многочлен Ньютона = \(prepearGraphs.graphs[2].GetPoint(X) ?? 0)")
            Text("Интерполяционный многочлен Лагранжа = \(prepearGraphs.graphs[1].GetPoint(X ) ?? 0)")
                    // Text(t())
    
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.blue.opacity(0.3)
//                )
//            )
            
            GraphView(graphs: self.prepearGraphs)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            )
        }
    }
    var prepearGraphs: Graphs{
        Graphs(graphs: [
            Graph(function: f, from: pointsXvarA.first!, to: pointsXvarA.last!, step: 0.1),
                Graph(interpolatePoints: pointsXvarA.map{($0, f($0))}, method: .lagrange, step: 0.1),
                Graph(interpolatePoints: pointsXvarA.map{($0, f($0))}, method: .newton, step: 0.1)
        ], markOnX: 0.1)
    }
    
}

struct Lab3_1View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_1View()
    }
}
