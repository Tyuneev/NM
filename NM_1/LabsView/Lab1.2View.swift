//
//  Lab1.2View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 13.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_2View: View {
    @ObservedObject var A = ObservableMatrix(Matrix([[-6,5,0,0,0],
                                                    [-1,13,6,0,0],
                                                    [0,-9,-15,-4,0],
                                                    [0,0,-1,-7,1,],
                                                    [0,0,0,9,-18]]))
    @ObservedObject var B = ObservableMatrix(Matrix([[51,100,-12,47,-90]]).Transpose())
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Система линейных алгебраических уравнений:").font(.title).padding(.horizontal)
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
                        
                    }.frame(maxWidth: .infinity)
                }
                Text("Решение системы:").font(.title).padding(.leading)
                HStack{
                    Text("X")
                        .frame(width: 30, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.3)))
                        .padding()
                    Image(systemName: "equal").font(.system(size: 16, weight: .regular))
                    MatrixOrErorView(matrix: SolveSLAERunMethod(A: A.WarpedMatrix, B: B.WarpedMatrix)).padding()
                }
            }
        }
    }
}

struct Lab1_2View_Previews: PreviewProvider {
    static var previews: some View {
        Lab1_2View()
    }
}
