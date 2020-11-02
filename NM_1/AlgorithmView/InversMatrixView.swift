//
//  InversMatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 13.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct InversMatrixView: View {
    @EnvironmentObject var A: ObservableMatrix
    var body: some View {
        ScrollView(.vertical){
            ScrollView(.horizontal){
                HStack{
                    ChangeableMatrixView()
                        .environmentObject(A)
                        .padding()
                    VStack{
                        Text("-1")
                        Spacer()
                    }
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                }
            }
            ScrollView(.horizontal){
                HStack{
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular)).padding()
                    MatrixOrErorView(matrix: A.WarpedMatrix.InverseMatrix()).padding()
                }
            }
        }
    }
}
//
//struct InversMatrixView_Previews: PreviewProvider {
//    static var previews: some View {
//        InversMatrixView(A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))
//    }
//}
