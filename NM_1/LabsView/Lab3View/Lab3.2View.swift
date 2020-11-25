//
//  Lab3.2View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 13.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab3_2View: View {
    @EnvironmentObject var Settings: UserSettings
    @ObservedObject var pointsXY = ObservableMatrix(Matrix([[0.0, 1.7, 3.4 ,5.1, 6.8],
                                                           [0.0, 3.0038, 5.2439, 7.3583, 9.4077]]).Transpose(),
                                                    unchangingNumberOfColumns: true)
    var cs: CubicSpline{
        get {CubicSpline(Points: makePointsPair())}
    }
    @State var X = 1.0
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5) {
                Text("Точки (x, y) и кубический сплайн между ними")
                    .font(.title)
                ScrollView(.horizontal){
                    HStack{
                        ChangeableMatrixView().environmentObject(pointsXY)
                        polinoms()
                    }
                }.padding(.vertical)
                
                GraphView(graphs: Graphs(graphs: [
                    Graph(interpolatePoints: makePointsPair(), method: .cubicSpline, step: 0.1, color: Color.green)
                ]))
                .padding(5)
                .background(Color.gray.opacity(0.17))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: .infinity, height: 350)
                Text("Значение сплайна в точке: ")
                    .font(.title)
                    .padding(.vertical)
                HStack{
                    Text("x = ")
                    TextField("\(X)", value: self.$X, formatter: self.Settings.numberFormater)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 60)
                    
                }
                Text("y = "+(self.Settings.numberFormater.string(from: NSNumber(value: cs.GetPoint(X))) ?? ""))
                    .font(.system(size: CGFloat(Settings.fontSize)))
            }.padding(.horizontal)
        }
    }
    func  makePointsPair()-> [(Double, Double)]{
        pointsXY.WarpedMatrix.elements.map{($0[0], $0[1])}
    }
    func polinoms() -> AnyView{
        let polinoms = cs.GetPolynomial(Settings.maximumFractionDigits).split(separator: " ")
        return AnyView(
            VStack(alignment: .leading, spacing: 10){
                ForEach(polinoms, id: \.self) {p in
                    Text(p).bold()
                }
                .font(.system(size: CGFloat(Settings.fontSize)))
            }.padding(10)
            .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.4))
            )
        )
    }
}

struct Lab3_2View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_2View()
    }
}
