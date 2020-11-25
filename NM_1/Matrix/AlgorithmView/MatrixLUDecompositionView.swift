//
//  MatrixLUDecompositionView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct MatrixLUDecompositionView: View {
    @EnvironmentObject var A: ObservableMatrix
    var body: some View {
        ScrollView(.vertical){
            VStack{
                ScrollView(.horizontal){
                    HStack(){
                        ChangeableMatrixView().environmentObject(A).padding()
                        Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                    }
                }
                DecompositionOrError(A.WarpedMatrix.SLUdecomposition())
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
                        Image(systemName: "equal").font(.system(size: 16, weight: .regular)).padding()
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

//struct MatrixLUDecompositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatrixLUDecompositionView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))
//    }
//}
