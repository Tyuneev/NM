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
                            TextField("", value: self.$matrix.WarpedMatrix.elements[i][j] , formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                  .keyboardType(.numbersAndPunctuation)
                        }
                        
                    }
                }
                Stepper("",
                    onIncrement: {
                        self.matrix.WarpedMatrix.AddRow()
                    }, onDecrement: {
                        self.matrix.WarpedMatrix.RemoveRow()
                    })
            }
                            Stepper("",
                            onIncrement: {
                                self.matrix.WarpedMatrix.AddColumn()
                            }, onDecrement: {
                                self.matrix.WarpedMatrix.RemoveColumn()
                            }).hueRotation(Angle(degrees: 90))
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
