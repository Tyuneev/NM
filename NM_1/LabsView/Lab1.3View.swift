//
//  Lab1.3View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 13.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_3View: View {
    @State var accuracy = 1.0
    @ObservedObject var A = ObservableMatrix(Matrix([[-6,5,0,0,0],
                                                     [-1,13,6,0,0],
                                                     [0,-9,-15,-4,0],
                                                     [0,0,-1,-7,1,],
                                                     [0,0,0,9,-18]]))
    @ObservedObject var B = ObservableMatrix(Matrix([[51,100,-12,47,-90]]).Transpose())
    enum SLAEMethod {
        case simpleIteration, zendel
    }
    @State var method: SLAEMethod = .simpleIteration
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Система линейных алгебраических уравнений:").font(.title).padding(.horizontal)
                ScrollView(.horizontal){
                    HStack(){
                        ChangeableMatrixView()
                            .environmentObject(A)
                            .padding()
                        Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                        Text("X")
                            .frame(width: 30, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.3)))
                            .padding()
                        Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                        ChangeableMatrixView()
                            .environmentObject(B)
                            .padding()
                        
                    }.frame(maxWidth: .infinity)
                }
                
                Text("Метод решения:").font(.title).padding(.leading)
                
                Picker("Метод: ", selection: self.$method){
                    Text("простых итераций").tag(SLAEMethod.simpleIteration)
                    Text("Зенделя").tag(SLAEMethod.zendel)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Text("Точность решения:").font(.title).padding(.leading)
                HStack{
                    Text("\(1/accuracy) ").padding(.leading)
                    Slider(value: $accuracy, in: 10...10000, step: 10).padding([.horizontal])
                }
                Text("Решение системы:").font(.title).padding(.leading)
                HStack{
                    Text("X")
                        .frame(width: 30, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.3)))
                        .padding()
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                    self.ResultMatrix()
                }
            }
        }
    }
    func ResultMatrix() -> AnyView {
        var res: ([Double]?, Int) = (nil, 1)
        switch self.method {
        case .simpleIteration:
            res =  SolveSLAE_SimpleIterationMethod(A: self.A.WarpedMatrix, B: self.B.WarpedMatrix.Transpose().elements.first, Accuracy: 1/self.accuracy)
        case .zendel:
            res = SolveSLAE_ZendelMethod(A: self.A.WarpedMatrix, B: self.B.WarpedMatrix.Transpose().elements.first, Accuracy: 1/self.accuracy)
        }
        guard let result = res.0 else {
            return AnyView(Text("Ошибка")
                .foregroundColor(Color.red)
                    .padding())
        }
        return AnyView(
            HStack{
                UnchangeableMatrixView(matrix: Matrix([result]).Transpose())
                Text("итераций: \(res.1)").padding()
            }
        )
    }
}

struct Lab1_3View_Previews: PreviewProvider {
    static var previews: some View {
        Lab1_3View()
    }
}
