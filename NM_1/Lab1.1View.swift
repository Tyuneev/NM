//
//  Lab1.1View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_1View: View {
    @ObservedObject var A = ObservableMatrix(Matrix([[1,-1,1,-2],
                                                    [-9,-1,1,8],
                                                    [-7,0,8,-6],
                                                    [3,-5,1,-6]]))
    @ObservedObject var B = ObservableMatrix(Matrix([[-20,60,-60,-44]]).Transpose())
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading){
                Text("Система линейных алгебраических уравнений:").font(.title).padding(.horizontal)
                ScrollView(.horizontal){
                    HStack(){
                        ChangeableMatrixView(matrix: A).padding()
                        Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                        Text("X")
                            .frame(width: 30, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.3)))
                            .padding()
                        Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                        ChangeableMatrixView(matrix: B).padding()

                    }
                }
                Text("Решение системы:").font(.title).padding(.leading)
                HStack{
                    Text("X")
                        .frame(width: 30, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.3)))
                        .padding()
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                    MatrixOrErorView(matrix: SolveSLAE(A: A.WarpedMatrix, B: B.WarpedMatrix)).padding()
                }
                
                Text("LU разложение с матрицей перестановок: ").font(.title).padding(.leading)
                DecompositionOrError(A.WarpedMatrix.SLUdecomposition())
                Text("Обратная матрица: ").font(.title).padding(.leading)
                ScrollView(.horizontal){
                    MatrixOrErorView(matrix: A.WarpedMatrix.InverseMatrix()).padding()
                }
                ((A.WarpedMatrix.Determinant() != nil)
                    ? Text("Определитель: " + String(A.WarpedMatrix.Determinant()!))
                    : Text("Определитель не найден")
                ).font(.title).padding(.leading)
            }
        }
    }
    func DecompositionOrError(_ result: (Matrix, Matrix, Matrix)?) -> AnyView {
           guard let sLU = result else {
               return AnyView(Text("Ошибка").foregroundColor(Color.red))
           }
           return AnyView(
               ScrollView(.horizontal){
                   HStack{
                       UnchangeableMatrixView(matrix: sLU.0).padding()
                       Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                       UnchangeableMatrixView(matrix: sLU.1).padding()
                       Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                       UnchangeableMatrixView(matrix: sLU.2).padding()
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



