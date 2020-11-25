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
    @ObservedObject var A = ObservableMatrix(Matrix([[-19,2,-1,-8],
                                                     [2,14,0,-4],
                                                     [6,-5,-20,-6],
                                                     [-6,4,-2,15]]),
                                             isSquare: true)
    @ObservedObject var B = ObservableMatrix(Matrix([[38,20,52,43]]).Transpose(), unchangingNumberOfColumns: true)
    enum SLAEMethod {
        case simpleIteration, zendel
    }
    @State var method: SLAEMethod = .simpleIteration
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Система линейных алгебраических уравнений:")
                    .font(.title)
                ScrollView(.horizontal){
                    HStack(spacing: 15){
                        ChangeableMatrixView()
                            .environmentObject(A)
                        Image(systemName: "multiply")
                            .font(.system(size: 16, weight: .regular))
                        Text("X")
                            .frame(width: 30, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.4)))
                        Image(systemName: "equal")
                            .font(.system(size: 16, weight: .regular))
                        ChangeableMatrixView()
                            .environmentObject(B)
                    }.frame(maxWidth: .infinity)
                }
                
                Text("Метод решения:")
                    .font(.title)
                Picker("Метод: ", selection: self.$method){
                    Text("простых итераций").tag(SLAEMethod.simpleIteration)
                    Text("Зенделя").tag(SLAEMethod.zendel)
                }.pickerStyle(SegmentedPickerStyle())
                AccuracyView(accuracy: self.$accuracy)
                Text("Решение системы:")
                    .font(.title)
                self.ResultMatrix()
            }
        }.padding(.horizontal)
    }
    func ResultMatrix() -> AnyView {
        var res: (Matrix?, Int) = (nil, 1)
        switch self.method {
        case .simpleIteration:
            res =  SolveSLAE_SimpleIterationMethod(A: self.A.WarpedMatrix, B: self.B.WarpedMatrix, Accuracy: accuracy)
        case .zendel:
            res = SolveSLAE_ZendelMethod(A: self.A.WarpedMatrix, B: self.B.WarpedMatrix, Accuracy: accuracy)
        }
        guard let result = res.0 else {
            return AnyView(Text("Ошибка")
                .foregroundColor(Color.red))
        }
        return AnyView(
            VStack(alignment: .leading, spacing: 15){
                HStack(spacing: 15){
                    Text("X")
                        .frame(width: 30, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.4)))
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                    UnchangeableMatrixView(matrix: result)
                }
                Text("Проведенно итераций: \(res.1)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    }
}

struct Lab1_3View_Previews: PreviewProvider {
    static var previews: some View {
        Lab1_3View()
    }
}
