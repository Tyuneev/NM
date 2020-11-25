//
//  MultiplyMatrixUIView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct MultiplyMatrixView: View {
    @EnvironmentObject var A: ObservableMatrix
    @EnvironmentObject var B: ObservableMatrix
    var body: some View {
        ScrollView(.vertical){
            ScrollView(.horizontal){
                HStack{
                    ChangeableMatrixView()
                        .environmentObject(A)
                        .padding()
                    Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                    ChangeableMatrixView()
                        environmentObject(B)
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                }
            }
            ScrollView(.horizontal){
                HStack{
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular)).padding()
                    MatrixOrErorView(matrix:
                        ( (A.WarpedMatrix === B.WarpedMatrix)
                        ? A.WarpedMatrix*B.WarpedMatrix : nil))
                }
            }
        }
    }
}

//struct MultiplyMatrixView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiplyMatrixView(
//        A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])),
//        B: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))
//    }
//}
