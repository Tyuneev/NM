//
//  Lab1.5View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 20.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_5View: View {
    @State var accuracy = 1.0
    @EnvironmentObject var Settings: UserSettings
    
    @ObservedObject var matrix = ObservableMatrix(Matrix([[-6,1,-4],
                                                          [-6,8,-2],
                                                          [2,-9,5]]))
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Матрица:")
                    .font(.title)
                ScrollView(.horizontal){
                    ChangeableMatrixView()
                        .environmentObject(matrix)
                }
                AccuracyView(accuracy: $accuracy)
                self.Result()
            }.padding(.horizontal)
        }
    }
    func Result() -> AnyView {
        if let res = EigenValueQRDM(A: self.matrix.WarpedMatrix, Accuracy: accuracy){
            let  eigenValues = res.0.map{$0.toString()}
            let iteration = res.1
            return AnyView(
                VStack(alignment: .leading, spacing: 15){
                    Text("Собственные значения:")
                        .font(.title)
                    ForEach(eigenValues, id: \.self){ v in
                        Text(v)
                            .font(.system(size: CGFloat(Settings.fontSize)))
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.4)))
                            //.padding(.vertical, 3)
                    }
                    Text("Итераций проведено: \(iteration)")

                }
            )
        } else {
            return AnyView(Text("Ошибка").foregroundColor(.red))
        }
    }
}

struct Lab1_5View_Previews: PreviewProvider {
    static var previews: some View {
        Lab1_5View()
    }
}
