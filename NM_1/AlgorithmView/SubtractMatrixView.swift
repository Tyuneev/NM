//
//  SubtractMatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct SubtractMatrixView: View {
    @ObservedObject var A: ObservableMatrix
    @ObservedObject var B: ObservableMatrix
    var body: some View {
         ScrollView(.vertical){
            ScrollView(.horizontal){
               HStack{
                   ChangeableMatrixView(matrix: A).padding()
                   Image(systemName: "minus").font(.system(size: 16, weight: .regular))
                   ChangeableMatrixView(matrix: B).padding()
                   Image(systemName: "equal").font(.system(size: 16, weight: .regular))
               }
            }
            ScrollView(.horizontal){
               HStack{
                   Image(systemName: "equal").font(.system(size: 16, weight: .regular)).padding()
                   MatrixOrErorView(matrix:
                       ( (A.WarpedMatrix === B.WarpedMatrix)
                       ? A.WarpedMatrix-B.WarpedMatrix : nil))
               }
            }
        }
    }
}

struct SubtractMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        SubtractMatrixView(
        A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])),
        B: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))
    }
}
