//
//  MatrixDeterminantView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct MatrixDeterminantView: View {
    @EnvironmentObject var A: ObservableMatrix
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading){
                ScrollView(.horizontal) {
                    ChangeableMatrixView()
                        .environmentObject(A)
                        .padding()
                }
                ((A.WarpedMatrix.Determinant() != nil) ?
                    Text("Определитель:   " + String(A.WarpedMatrix.Determinant() ?? 0)).font(.system(size: 25))
                    :
                    Text("Ошибка").foregroundColor(Color.red)).padding()
            }
        }
    }
}
//
//struct MatrixDeterminantView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatrixDeterminantView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))
//    }
//}
