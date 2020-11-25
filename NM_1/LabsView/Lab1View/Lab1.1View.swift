//
//  Lab1.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_1View: View {
    @EnvironmentObject var Settings: UserSettings
    @ObservedObject var A = ObservableMatrix(Matrix([[1,-1,1,-2],
                                                    [-9,-1,1,8],
                                                    [-7,0,8,-6],
                                                    [3,-5,1,-6]]),
                                             isSquare: true)
    @ObservedObject var B = ObservableMatrix(Matrix([[-20,60,-60,-44]]).Transpose(), unchangingNumberOfColumns: true)
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 15){
                Text("Система линейных алгебраических уравнений:")
                    .font(.title)
                ScrollView(.horizontal){
                    HStack(spacing: 15){
                        ChangeableMatrixView()
                            .environmentObject(A)
                            .layoutPriority(2)
                        Image(systemName: "multiply")
                            .font(.system(size: CGFloat(Settings.fontSize), weight: .regular))
                        Text("X")
                            .font(.system(size: CGFloat(Settings.fontSize)))
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.4)))
                        Image(systemName: "equal")
                            .font(.system(size: 16, weight: .regular))
                        ChangeableMatrixView()
                            .environmentObject(B)
                    }
                }
                Text("Решение системы:")
                    .font(.title)
                
                HStack{
                    Text("X")
                        .font(.system(size: CGFloat(Settings.fontSize)))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.4)))
                    Image(systemName: "equal")
                        .font(.system(size: 16, weight: .regular))
                    MatrixOrErorView(matrix: SolveSLAE(A: A.WarpedMatrix, B: B.WarpedMatrix))
                }
//
                Text("LU разложение с матрицей перестановок: ")
                    .font(.title)
                DecompositionOrError(A.WarpedMatrix.SLUdecomposition())
                Text("Обратная матрица: ")
                    .font(.title)
                ScrollView(.horizontal){
                    MatrixOrErorView(matrix: A.WarpedMatrix.InverseMatrix())
                }
                determinant()
            }
            .padding(.horizontal)
        }
    }
    func determinant()->AnyView
    {
        guard let d = A.WarpedMatrix.Determinant() else{
            return AnyView(
                Text("Определитель не найден")
            )
        }
        return AnyView (
            VStack(alignment: .leading, spacing: 15){
                Text("Определитель:")
                    .font(.title)
                Text(Settings.numberFormater.string(from: NSNumber(value: d)) ?? "")
                    .font(.system(size: CGFloat(Settings.fontSize)))
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green.opacity(0.4)))
            }
        )
    }
    func DecompositionOrError(_ result: (Matrix, Matrix, Matrix)?) -> AnyView {
           guard let sLU = result else {
               return AnyView(Text("Ошибка").foregroundColor(Color.red))
           }
           return AnyView(
               ScrollView(.horizontal){
                HStack(spacing: 15){
                       UnchangeableMatrixView(matrix: sLU.0)
                       Image(systemName: "multiply")
                        .font(.system(size: 16, weight: .regular))
                       UnchangeableMatrixView(matrix: sLU.1)
                       Image(systemName: "multiply")
                        .font(.system(size: 16, weight: .regular))
                       UnchangeableMatrixView(matrix: sLU.2)
                    }
                }
           )
    }
}

    struct Lab1_1View_Previews: PreviewProvider {
        static var previews: some View {
            Lab1_1View()
        }
    }



