//
//  Lab1.4View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 20.10.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab1_4View: View {
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
                    Text(String(pow(0.1, numbersAfterPoint))).padding(.leading)
                    Slider(value: $numbersAfterPoint, in: 1...20, step: 10).padding([.horizontal])
                }
                self.Result()
            }
        }
    }
    func Result() -> AnyView {
        if let res = EigenValueAndVectorsRM(A: self.matrix.WarpedMatrix, Accuracy: pow(0.1, self.numbersAfterPoint)){
            let eigenValues = res.0
            let eigenVectors = res.1
            let iteration = res.2
            return AnyView(
                VStack{
                    Text("Собственные значения:").padding()
                    Text(((eigenValues.reduce(""){$0 + (String($1) + "; ") }).dropLast())).padding()
                    ScrollView(.horizontal){
                        HStack{
                            Text("Собственные векторы: ").padding(.horizontal)
                            ForEach(0..<eigenVectors.count, id: \.self){ i in
                                UnchangeableMatrixView(matrix: eigenVectors[i]).padding(.horizontal)
                            }
                        }
                    }
                    Text("Итераций проведено: \(iteration)").padding(.horizontal)

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
