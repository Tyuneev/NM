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
    @State var Deg = "1"
    @State var ResultMatrix: Matrix
    var body: some View {
//        ScrollView(){
//            ScrollView(.horizontal){
//                HStack(){
//                    ChangeableMatrixView(isSquare: true, matrix: A).padding()
//                    VStack(){
//                        TextField("Степень", value: self.$Deg, formatter: NumberFormatter())
//
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.numberPad)
////                            .background(RoundedRectangle(cornerRadius: 10)
////                            .fill(Color.blue.opacity(0.3)))
////                            .onChange(of: Deg) {
////                                self.ResultMatrixView(matrix: self.A.WarpedMatrix, pow: Int(Deg) ?? 1)
//
//                        }
//                        Spacer()
//                    }
//                    Image(systemName: "equal")
//                        .font(.system(size: 16, weight: .regular))
//                }
//            }
//            ScrollView(.horizontal){
//                HStack{
//                    Image(systemName: "equal")
//                        .font(.system(size: 16, weight: .regular))
//                        .padding()
//                    UnchangeableMatrixView(matrix: ResultMatrix)
//                }
//            }
//        }
        Text("Peredelau")
    }
//    func ResultMatrixView(matrix: Matrix, pow: Int){
//        DispatchQueue.main.async {
//            self.ResultMatrix = matrix^pow
//        }
//    }
}

//struct DegreeMatrixView_Previews: PreviewProvider {
//    static var previews: some View {
//        DegreeMatrixView(
//        //A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))
//    }
//}
