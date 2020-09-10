//
//  TmpEditView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct TmpEditView: View {
    let EditColumnNumber: Bool
    let EditRowNumber: Bool
    @ObservedObject var matrix: ObservableMatrix
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ScrollView(.vertical){
                ScrollView(.horizontal){
                    HStack{
                        VStack{
                            ForEach(0..<self.matrix.WarpedMatrix.rows, id: \.self){ i in
                                HStack {
                                    ForEach(0..<self.matrix.WarpedMatrix.columns, id: \.self){ j in
                                        TextField("", value: self.$matrix.WarpedMatrix.elements[i][j], formatter: NumberFormatter())
                                            //.frame(width: String(self.matrix.WarpedMatrix.elements[i][j]).count*4)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                            HStack{
                                //Text(String(Int(deviceSize.size.width)))
                                Image(systemName: "minus.circle")
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 5)
                                    .foregroundColor(Color.red)
                                    .onTapGesture {
                                        if self.EditColumnNumber{ self.matrix.WarpedMatrix.RemoveRow()
                                        }
                                    }
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 5)
                                    .foregroundColor(Color.green)
                                    .onTapGesture {
                                        if self.EditColumnNumber {
                                            self.matrix.WarpedMatrix.AddRow()
                                        }
                                    }
                            }

                        }
                        VStack{
                            Image(systemName: "plus.circle")
                                .font(.system(size: 18))
                                .padding(.vertical, 5)
                                .foregroundColor(Color.green)
                                .onTapGesture {
                                    if self.EditRowNumber {
                                        self.matrix.WarpedMatrix.AddColumn()
                                    }
                                }
                            Image(systemName: "minus.circle")
                                .font(.system(size: 18))
                                .padding(.horizontal, 5)
                                .foregroundColor(Color.red)
                                .onTapGesture {
                                    if self.EditRowNumber {
                                        self.matrix.WarpedMatrix.RemoveColumn()
                                    }
                                }
                        }
                    }
                    .frame(height: deviceSize.size.height*0.9)
                        .padding()
                }
                .frame(width: deviceSize.size.width*0.9,
                        height: deviceSize.size.height*0.9)
                Spacer().frame(height: deviceSize.size.height*0.5)
            }
        }
            
    }
}

struct TmpEditView_Previews: PreviewProvider {
    static var previews: some View {
        TmpEditView(
            EditColumnNumber: true,
            EditRowNumber: true,
            matrix: ObservableMatrix(
                Matrix([[10,2,3,0,0,0],
                        [3,2.20005,1,0,0,0],
                        [5,6,7,0,0,0]])
            )
        )
    }
}
