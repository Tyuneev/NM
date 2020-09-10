//
//  LabMenuView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct LabMenuView: View {
        var body: some View {
            NavigationView {
                List{
                    NavigationLink(destination: Lab1_1View()){
                        Text("1.1 Определитель, обратная матрица, решение СЛАУ при помощи LU разложения")
                    }
                    NavigationLink(destination:
                                SubtractMatrixView(
                            A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])),
                            B: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))){
                        Text("Разность матриц")
                    }
                    NavigationLink(destination:
                                MultiplyMatrixView(
                            A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])),
                            B: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))){
                        Text("Произведение матриц")
                    }
                    NavigationLink(destination:
                                DegreeMatrixView(
                            A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))){
                        Text("Возведение матрицы в степень")
                    }
                    NavigationLink(destination:
                            SLAEView(A: ObservableMatrix(Matrix([[1,1,1],[1,1,1],[1,1,1]])), B: ObservableMatrix(Matrix([[1,1,1]]).Transpose()))){
                        Text("Решение СЛАУ")
                    }

                    NavigationLink(destination:
                        MatrixLUDecompositionView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))){
                        Text("LU разложение")
                    }
                    NavigationLink(destination:
                        MatrixDeterminantView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))){
                        Text("Определитель матрицы")
                    }
                    NavigationLink(destination:
                        InversMatrixView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))){
                        Text("Обратная матрицa")
                    }
                    NavigationLink(destination:
                        InversMatrixView(A: ObservableMatrix(Matrix([[1,2,1],[1,1,1],[1,1,1]])))){
                        Text("Обратная матрицa")
                    }
                    
                    
                    Divider()
//
//                    NavigationLink(destination:
//                        DataView(data: MatrixArr)){
//                            Text("Сохраненные матрицы")
//                    }
                }
                .navigationBarTitle(Text("Лаболаторные")
                .font(.title))
        }
    }
}

struct LabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LabMenuView()
    }
}
