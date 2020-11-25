//
//  Lab1.4View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 20.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_4View: View {
    @EnvironmentObject var Settings: UserSettings
    @State var accuracy = 1.0
    @ObservedObject var matrix = ObservableMatrix(Matrix([[2,8,7],
                                                          [8,2,7],
                                                          [7,7,-8]]),
                                                  isSquare: true)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15){
                Text("Симетрическая матрица:")
                    .font(.title)
                ScrollView(.horizontal){
                    ChangeableMatrixView()
                        .environmentObject(matrix)
                }
                AccuracyView(accuracy: $accuracy)
                self.Result()
            }
        }.padding(.horizontal)
    }
    func Result() -> AnyView {
        if let res = EigenValueAndVectorsRM(A: self.matrix.WarpedMatrix, Accuracy: accuracy){
            let eigenValues = res.0
            let eigenVectors = res.1
            let iteration = res.2
            return AnyView(
                VStack(alignment: .leading, spacing: 15){
                    Text("Собственные значения:")
                        .font(.title)
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(eigenValues, id: \.self){ v in
                                UnchangeableMatrixView(matrix: Matrix([[v]]))
                            }
                        }
                    }
                    Text("Собственные векторы:")
                        .font(.title)
                    ScrollView(.horizontal){
                        HStack(spacing: 15){
                            ForEach(0..<eigenVectors.count, id: \.self){ i in
                                UnchangeableMatrixView(matrix: eigenVectors[i])
                            }
                        }
                    }
                    Text("Проведенно итераций:")
                        .font(.title)
                    Text("\(iteration)")
                        .font(.system(size: CGFloat(Settings.fontSize)))

                }
            )
        } else {
            return AnyView(Text("Ошибка").foregroundColor(.red))
        }
    }
}

struct Lab1_4View_Previews: PreviewProvider {
    static var previews: some View {
        Lab1_4View()
    }
}
