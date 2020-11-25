//
//  SLAEView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct SLAEView: View {
    @EnvironmentObject var A: ObservableMatrix
    @EnvironmentObject var B: ObservableMatrix
    var body: some View {
        ScrollView(.vertical){
            ScrollView(.horizontal){
                HStack(){
                    ChangeableMatrixView()
                        .environmentObject(A)
                        .padding()
                    Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
                    Text("X")
                        .frame(width: 30, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.3)))
                        .padding()
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                    ChangeableMatrixView()
                        .environmentObject(B)
                        .padding()
                    
                }
            }
            HStack{
                Text("X")
                    .frame(width: 30, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.3)))
                    .padding()
                Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                MatrixOrErorView(matrix: SolveSLAE(A: A.WarpedMatrix, B: B.WarpedMatrix)).padding()
            }
            
        }
    }
}

//struct SLAEView_Previews: PreviewProvider {
//    static var previews: some View {
//        SLAEView(A: ObservableMatrix(Matrix([[1,1,1],[1,1,1],[1,1,1]])), B: ObservableMatrix(Matrix([[1,1,1]]).Transpose()))
//    }
//}
