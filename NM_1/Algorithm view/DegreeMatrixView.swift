//
//  DegreeMatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct DegreeMatrixView: View {
    @ObservedObject var A: ObservableMatrix
    @State var Deg = ""
    var body: some View {
        ScrollView(){
            ChangeableMatrixView(matrix: A)
            Text("^").font(.system(size: 16, weight: .regular))
            TextField("Степень", text: self.$Deg).padding()
            Image(systemName: "equal").font(.system(size: 16, weight: .regular))
            MatrixOrErorView(matrix: (
                (A.WarpedMatrix.IsSquare() && (Int(Deg) != nil))
                    ? A.WarpedMatrix^(Int(Deg)!) : nil))
        }
    }
}

struct DegreeMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
