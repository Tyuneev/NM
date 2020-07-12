//
//  MenuView.swift
//  NM
//
//  Created by Алексей Тюнеев on 28.03.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI
struct MenuView: View {
    var body: some View {
        NavigationView {
            List{
                NavigationLink(destination:
                        SummarizeMatrixView(
                        A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])),
                        B: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))){
                    Text("Сумма матриц")
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
//                NavigationLink(destination:
//                            SLAEView(
//                        A: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]]))){
//                    Text("Решение СЛАУ")
//                }

                NavigationLink(destination:
                    DataView(data: MatrixArr)){
                        Text("Сохраненные матрицы")
                }
            }.navigationBarTitle(Text("Варианты") .font(.title))
            }
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
