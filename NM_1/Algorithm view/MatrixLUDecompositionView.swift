//
//  MatrixLUDecompositionView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct MatrixLUDecompositionView: View {
    @ObservedObject var A: ObservableMatrix
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack(){
                    ChangeableMatrixView(matrix: A).padding()
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                }
            }
            DecompositionOrError(A.WarpedMatrix.LUdecomposition())
        }
    }
    func DecompositionOrError(_ result: (Matrix, Matrix, [Int])?) -> AnyView {
        guard let LU = result else {
            return AnyView(Text("Ошибка").foregroundColor(Color.red))
        }
        return AnyView(
            ScrollView(.horizontal){
            HStack{
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular)).padding()
                    UnchangeableMatrixView(matrix: LU.0).padding()
                    Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                    UnchangeableMatrixView(matrix: LU.1).padding()
                    //Text(swaps) Дописать
                }
            }
        )
    }
}

struct MatrixLUDecompositionView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixLUDecompositionView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))
    }
}
