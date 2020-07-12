//
//  MultiplyMatrixUIView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct MultiplyMatrixView: View {
    @ObservedObject var A: ObservableMatrix
    @ObservedObject var B: ObservableMatrix
    var body: some View {
        ScrollView(){
            ChangeableMatrixView(matrix: A)
            Image(systemName: "multiply").font(.system(size: 16, weight: .regular))
            ChangeableMatrixView(matrix: B)
            Image(systemName: "equal").font(.system(size: 16, weight: .regular))
            MatrixOrErorView(matrix: (
                (A.WarpedMatrix === B.WarpedMatrix.Transpose())
                    ? A.WarpedMatrix*B.WarpedMatrix : nil))
        }
    }
}

struct MultiplyMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        //MultiplyMatrixUIView()
    }
}
