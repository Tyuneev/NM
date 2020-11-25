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
                                                    [0,0,0,9,-18]]),
                                             isSquare: true)
    @ObservedObject var B = ObservableMatrix(Matrix([[51,100,-12,47,-90]]).Transpose(), unchangingNumberOfColumns: true)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15){
                Text("Система линейных алгебраических уравнений:")
                    .font(.title)
                ScrollView(.horizontal){
                    HStack(spacing: 15){
                        ChangeableMatrixView()
                            .environmentObject(A)
                        Image(systemName: "multiply")
                            .font(.system(size: 16, weight: .regular))
                        Text("X")
                            .frame(width: 30, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.4)))
                        Image(systemName: "equal")
                            .font(.system(size: 16, weight: .regular))
                        ChangeableMatrixView()
                            .environmentObject(B)
                        
                    }.frame(maxWidth: .infinity)
                }
                Text("Решение системы:")
                    .font(.title)
                HStack(spacing: 15){
                    Text("X")
                        .frame(width: 30, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.4)))
                    Image(systemName: "equal")
                        .font(.system(size: 16, weight: .regular))
                    MatrixOrErorView(matrix: SolveSLAERunMethod(A: A.WarpedMatrix, B: B.WarpedMatrix))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct Lab1_2View_Previews: PreviewProvider {
    static var previews: some View {
        Lab1_2View()
    }
}
