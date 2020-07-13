//
//  EditMatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 13.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct EditMatrixView: View {
    @ObservedObject var matrix: ObservableMatrix
    @State var CurrentNumberIndex: (Int, Int) = (-1, -1)
    var body: some View {
        VStack{
            HStack(alignment: .bottom, spacing: 0){
                ForEach(0..<self.matrix.WarpedMatrix.columns, id: \.self){ j in
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<self.matrix.WarpedMatrix.rows, id: \.self){ i in
                            Text(String(self.matrix.WarpedMatrix[i, j]))
                                .font(.system(size: 16, weight: .bold))
                                .frame(height: 35.0)
                                .frame(minWidth: 40)
                                .padding(4)
                        }
                    }
                }
            }
        }
    }
}

struct EditMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        EditMatrixView(matrix: ObservableMatrix(Matrix([[1,2,3],[1,2,3],[1,2,3]])))
    }
}

struct NumberView: View {
    @ObservedObject var matrix: ObservableMatrix
    @State var CurrentNumberIndex: (Int, Int) = (-1, -1)
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "1.circle").font(.system(size: 40, weight: .regular))
                Image(systemName: "2.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "3.circle").font(.system(size: 16, weight: .regular))
            }
            HStack{
                Image(systemName: "1.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "2.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "3.circle").font(.system(size: 16, weight: .regular))
            }
            HStack{
                Image(systemName: "1.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "2.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "3.circle").font(.system(size: 16, weight: .regular))
            }
            HStack{
                Image(systemName: "1.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "2.circle").font(.system(size: 16, weight: .regular))
                Image(systemName: "3.circle").font(.system(size: 16, weight: .regular))
            }
        }
    }
}
