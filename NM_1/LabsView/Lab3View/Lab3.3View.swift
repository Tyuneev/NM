//
//  Lab3.3View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 02.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab3_3View: View {
    enum SplinePow: Int{
        case one = 1, two, three
    }
    @EnvironmentObject var Settings: UserSettings
    @ObservedObject var pointsXY = ObservableMatrix(Matrix([[0.0, 1.7, 3.4 ,5.1, 6.8],
                                                           [0.0, 3.0038, 5.2439, 7.3583, 9.4077]]).Transpose())
    @State var splinePow: SplinePow = SplinePow.one

    var msm: MSM {
        get{
            MSM(Points: makePointsPair(), pow: (splinePow.rawValue))
        }
    }
    var sse: String{
        get{
            let m = msm
            let res = (pointsXY.WarpedMatrix.elements.map({pow((m.GetPoint($0[0]) - $0[1]),2)})).reduce(0.0){$0+$1}
            return (Settings.numberFormater.string(from: NSNumber(value: res)) ?? "")
        }
    }
    
    @State var X = 1.0
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5) {
                Group{
                    Text("Точки (x, y):")
                        .font(.title)
                        .padding(.bottom)
                    
                    ChangeableMatrixView()
                        .environmentObject(pointsXY)
                    Text("Степень сплайна:")
                        .font(.title)
                        .padding(.vertical)
                    Picker("", selection: self.$splinePow){
                        Text("1").tag(SplinePow.one)
                        Text("2").tag(SplinePow.two)
                        Text("3").tag(SplinePow.three)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("График:")
                        .font(.title)
                        .padding(.vertical)
                    
                    GraphView(graphs: Graphs(graphs: [
                            Graph(makePointsPair()),
                        Graph(interpolatePoints: makePointsPair(), method: .msm, step: 0.1, pow: splinePow.rawValue, color: Color.red)
                        ], markOnX: 1, markOnY: 1)
                    
                    )
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.17))
                    ).frame(minHeight: 350)
                    Text("(Приближающий многочлен - крассный)")
                    
                    Text("Приближающий многочлен:")
                        .font(.title)
                        .padding(.vertical, 10)
                    ScrollView(.horizontal){
                        Text(msm.GetPolynomial(Settings.maximumFractionDigits))
                            .font(.system(size: CGFloat(Settings.fontSize)))
                            .bold()
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.4))
                            )
                            .padding(.vertical, 5)
                    }
                    Text("Значение многочлена в точке:")
                        .font(.title)
                        .padding(.vertical)
                }
                Group{
                    HStack{
                        Text("x = ")
                            .font(.system(size: CGFloat(Settings.fontSize)))
                            .bold()
                        TextField("\(X)", value: self.$X, formatter: self.Settings.numberFormater)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 60)
                    }
                    Text("F(x) = "+(self.Settings.numberFormater.string(from: NSNumber(value: msm.GetPoint(X))) ?? ""))
                        .font(.system(size: CGFloat(Settings.fontSize)))
                        .bold()
                        //.padding(.vertical)
                    
                    Text("Сумма квадратов ошибок:")
                        .font(.title)
                        .padding(.vertical)
                }
                Text("Ф="+sse)
                    .font(.system(size: CGFloat(Settings.fontSize)))
                    .bold()
            }.padding(.horizontal)
        }
    }
    func  makePointsPair()-> [(Double, Double)]{
        pointsXY.WarpedMatrix.elements.map{($0[0], $0[1])}
    }
}

struct Lab3_3View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_3View()
    }
}
