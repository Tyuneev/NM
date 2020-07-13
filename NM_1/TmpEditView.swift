//
//  TmpEditView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct TmpEditView: View {
    @ObservedObject var matrix: ObservableMatrix
    var body: some View {
        HStack{
            VStack{
                ForEach(0..<self.matrix.WarpedMatrix.rows, id: \.self){ i in
                    HStack {
                        ForEach(0..<self.matrix.WarpedMatrix.columns, id: \.self){ j in
                            TextField("", value: self.$matrix.WarpedMatrix.elements[i][j], formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                  .keyboardType(.decimalPad)
                        }
                        
                    }
                }
                HStack{
                    Image(systemName: "plus.circle.fill").font(.system(size: 16, weight: .regular))
                        .onTapGesture { self.matrix.WarpedMatrix.AddRow() }
                    Image(systemName: "minus.circle.fill").font(.system(size: 16, weight: .regular))
                        .onTapGesture { self.matrix.WarpedMatrix.RemoveRow()}
                            
                    }
            }
            VStack{
                Image(systemName: "plus.circle.fill").font(.system(size: 16, weight: .regular))
                    .onTapGesture { self.matrix.WarpedMatrix.AddColumn() }
                Image(systemName: "minus.circle.fill").font(.system(size: 16, weight: .regular))
                    .onTapGesture { self.matrix.WarpedMatrix.RemoveColumn()}
                        
            }
        }
    }
}

struct TmpEditView_Previews: PreviewProvider {
    static var previews: some View {
        TmpEditView(matrix:
            ObservableMatrix(
                Matrix([[10,2,3,0,0,0],
                        [3,2.20005,1,0,0,0],
                        [5,6,7,0,0,0]]))
        )
    }
}
