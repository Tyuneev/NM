//
//  Lab1.5View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 20.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_5View: View {
    @State var numbersAfterPoint = 1.0
    
    @ObservedObject var matrix = ObservableMatrix(Matrix([[2,8,7],
                                                          [8,2,7],
                                                          [7,7,-8]]))
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Система линейных алгебраических уравнений:").font(.title).padding(.horizontal)
                ScrollView(.horizontal){
                    ChangeableMatrixView()
                        .environmentObject(matrix)
                        .padding()
                }
                Text("Точность решения:").font(.title).padding(.leading)
                HStack{
                    Text(String((pow(0.1, numbersAfterPoint)) )).padding(.leading)
                    Slider(value: $numbersAfterPoint, in: 1...20, step: 1).padding([.horizontal])
                }
                self.Result()
            }
        }
    }
    func Result() -> AnyView {
        if let res = EigenValueQRDM(A: self.matrix.WarpedMatrix, Accuracy: pow(0.1, numbersAfterPoint)){
            let eigenValues = res.0.reduce(""){$0+$1.toString()+"\n"}
            let iteration = res.1
            return AnyView(
                VStack{
                    Text("Собственные значения:").padding()
                    Text(eigenValues).padding()
                    Text("Итераций проведено: \(iteration)").padding(.horizontal)

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
