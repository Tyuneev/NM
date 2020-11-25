//
//  Lab3.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI



struct Lab3_1View: View {
    struct function: Identifiable {
        let id = UUID()
        let f: ((Double)->Double)
        let f_image: Image
        let name: String
    }
    enum Method {
        case Lagrange, Newton
    }
    @State var method: Method = .Lagrange
    var functions: [function]
    var interpolet: interpolate{
        get {
            if method == .Lagrange{
                return Lagrange(Points: makePointsPair())
            }
            return Newton(Points: makePointsPair())
        }
    }
    var interpolateValue: String {
        Settings.numberFormater.string(from: NSNumber(value: interpolet.GetPoint(X))) ?? ""
    }
    var Y: String {
        Settings.numberFormater.string(from: NSNumber(value: functions[indexSelectFunction].f(X))) ?? ""
    }
    var delta: String{
        Settings.numberFormater.string(from: NSNumber(value: (interpolet.GetPoint(X) - functions[indexSelectFunction].f(X)))) ?? ""
    }
    @State var indexSelectFunction = 0
    @EnvironmentObject var Settings: UserSettings
    @ObservedObject var pointsX = ObservableMatrix(Matrix([[-2.0, -1.0, 0.0, 1.0]]).Transpose(), unchangingNumberOfColumns: true)
    @State var X = -0.5
    init(){
        self.functions = [
            function(f: {exp($0)+$0},
                     f_image: Image("f.3.1.17"),
                     name: "Вариант 17"),
            function(f: {sin($0)},
                     f_image: Image("f.3.1.1"),
                     name: "Вариант 1"),
            function(f: {exp($0)},
                     f_image: Image("f.3.1.6"),
                     name: "Вариант 6"),
            function(f: {pow($0, 0.5)+$0},
                     f_image: Image("f.3.1.18"),
                     name: "Вариант 18"),
            function(f: {pow($0, -2)},
                     f_image: Image("f.3.1.24"),
                     name: "Вариант 24")
        ]
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5){
                Group{
                    Text("Функция:")
                        .font(.title)
                    ChengeIndexView(index: $indexSelectFunction, images: functions.map{$0.f_image})
                        .frame(height: 50)
                    Text("Точки x и y(x):")
                        .font(.title)
                    HStack{
                        ChangeableMatrixView().environmentObject(pointsX)
                        UnchangeableMatrixView(matrix: Matrix([applyFunction()]).Transpose())
                    }
                    Text("Метод")
                        .font(.title)
                    Picker("", selection: self.$method){
                        Text("Лагранжа").tag(Method.Lagrange)
                        Text("Нтютона").tag(Method.Newton)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Group{
                    Text("Интерполяционный многочлен:")
                        .font(.title)
                    ScrollView(.horizontal){
                        Text(interpolet.GetPolynomial(Settings.maximumFractionDigits))
                            .font(.system(size: CGFloat(Settings.fontSize)))
                            .bold()
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.4))
                            )
                            .padding(.vertical, 10)
                    }
                    Text("Погрешность в точке: ")
                        .font(.title)
                        .padding(.vertical)
                    HStack{
                        Text("x = ")
                            .font(.system(size: CGFloat(Settings.fontSize)))
                            .bold()
                        TextField("\(X)", value: self.$X, formatter: self.Settings.numberFormater)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 50)
                    }
                }
                Group {
                    Text("y(x) = " + Y)
                        .font(.system(size: CGFloat(Settings.fontSize)))
                        .bold()
                    Text((method == .Lagrange ? "L" : "N")+"(x) = "+interpolateValue)
                        .font(.system(size: CGFloat(Settings.fontSize)))
                        .bold()
                    Text((method == .Lagrange ? "∆(L(x)) = " : "∆(N(x)) =" )+delta)
                        .font(.system(size: CGFloat(Settings.fontSize)))
                        .bold()
                }
                Text("График ")
                    .font(.title)
                GraphView(graphs: Graphs(graphs: [
                    Graph(function: functions[indexSelectFunction].f, from: minX(), to: maxX(), step: 0.05, color: Color.red),
                    Graph(interpolatePoints: makePointsPair(), method: (self.method == .Lagrange ? .lagrange : .newton), step: 0.1, color: Color.green)
                ]))
                .padding(5)
                .background(Color.gray.opacity(0.17))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: .infinity, height: 350)
                
            }
            .padding(.horizontal)
        }
    }
    func applyFunction()->[Double]{
        makePointsPair().map{$0.1}
    }
    func  makePointsPair()-> [(Double, Double)]{
        pointsX.WarpedMatrix.Transpose().elements[0].map{($0, self.functions[indexSelectFunction].f($0))}
    }
    func  minX()-> Double{
        pointsX.WarpedMatrix.Transpose().elements[0].first ?? -1
    }
    func  maxX()-> Double{
        pointsX.WarpedMatrix.Transpose().elements[0].last ?? 1
    }
    
}

struct Lab3_1View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_1View()
    }
}
