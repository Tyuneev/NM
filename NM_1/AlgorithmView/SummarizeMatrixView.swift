//
//  SummarizeMatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI
struct SummarizeMatrixView: View {
    @EnvironmentObject var A: ObservableMatrix
    @EnvironmentObject var B: ObservableMatrix
    var body: some View {
        ScrollView(.vertical){
            ScrollView(.horizontal){
                HStack{
                    ChangeableMatrixView()                        .environmentObject(A)
                        .padding()
                    Image(systemName: "plus").font(.system(size: 16, weight: .regular))
                    ChangeableMatrixView()
                        .environmentObject(B)
                        .padding()
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                }
            }
            ScrollView(.horizontal){
                HStack{
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular)).padding()
                    MatrixOrErorView(matrix:
                        ( (A.WarpedMatrix === B.WarpedMatrix)
                        ? A.WarpedMatrix+B.WarpedMatrix : nil))
                }
            }
        }
    }
}

//struct SummarizeMatrixView_Previews: PreviewProvider {
//    static var previews: some View {
//        SummarizeMatrixView(A: ObservableMatrix(Matrix([[1,1],[1,1]])), B: ObservableMatrix(Matrix([[1,1],[1,1]])))
//    }
//}
