//
//  MatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

enum ActivSheetView {
    case EditView, SaveMatrixView, ChoosSavedMatrixView, No
}

struct ChangeableMatrixView: View {
        @ObservedObject var matrix: ObservableMatrix
        @State private var showActionSheet = false
        @State private var showSeetView = false
        @State private var activSheet: ActivSheetView = .No
    
        var body: some View {
            HStack(alignment: .bottom, spacing: 0){
                ForEach(0..<self.matrix.WarpedMatrix.columns, id: \.self){ j in
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<self.matrix.WarpedMatrix.rows, id: \.self){ i in
                            Text(String(self.matrix.WarpedMatrix[i, j])).bold()
                                .frame(height: 35.0)
                                .frame(minWidth: 40)
                                .padding(4)
                        }
                    }
                }
            }
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.3)))
            .onTapGesture {
                self.showActionSheet = true
            }
            .sheet(isPresented: self.$showSeetView){
                self.SheetView()
            }
            .actionSheet(isPresented: $showActionSheet, content: {
                ActionSheet(title: Text("Действия").font(.title),
                    buttons: [
                        .cancel(),
                        .default(Text("Изменить"), action: {
                            self.showSeetView = true
                            self.activSheet = .EditView
                        }),
                        .default(Text("Сохранить"), action: {
                            self.activSheet = .SaveMatrixView
                            self.showSeetView = true
                        }),
                        .default(Text("Применить другой алгоритм"), action: {
                        }),
                        .default(Text("Выбрать из сохраненных"), action: {
                            self.activSheet = .ChoosSavedMatrixView
                            self.showSeetView = true
                        })
                    ])
            })
    }
    func SheetView() -> AnyView {
        switch self.activSheet {
        case .EditView:
            return AnyView(TmpEditView(matrix: self.matrix))
        case .SaveMatrixView:
            return AnyView(SaveMatrixView(matrix: self.matrix.WarpedMatrix))
        case .ChoosSavedMatrixView:
            return AnyView(DataForChoosView(matrix: self.matrix, data: MatrixArr))
        case .No:
            return AnyView(EmptyView())
        }
    }
}

struct UnchangeableMatrixView: View {
    let matrix: Matrix
    @State private var showActionSheet = false
    @State private var showSaveMatrixView = false
    var body: some View {
        HStack(alignment: .bottom, spacing: 0){
            ForEach(0..<self.matrix.columns, id: \.self){ j in
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<self.matrix.rows, id: \.self){ i in
                        Text(" " + String(self.matrix[i, j]) + "  ")
                            .bold()
                            .frame(height: 35.0)
                            .frame(minWidth: 40)
                            .padding(4)
                    }
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.5)))
        .onTapGesture {self.showActionSheet = true}
        .sheet(isPresented: $showSaveMatrixView, content: { SaveMatrixView(matrix: self.matrix)})
        .actionSheet(isPresented: $showActionSheet, content: {
            ActionSheet(title: Text("Действия").font(.title), buttons: [
                .cancel(),
                .default(Text("Сохранить"), action: {
                    self.showSaveMatrixView = true}),
                .default(Text("Применить другой алгоритм"), action: {
                    
                })
            ])
        })
    }
}


struct MatrixOrErorView: View {
    var matrix: Matrix?
    @State private var showActionSheet = false
    @State private var showSaveMatrixView = false
    var body: some View {
        guard let matrix = matrix else {
            return AnyView(Text("Ошибка").foregroundColor(Color.red))
        }
        return AnyView(UnchangeableMatrixView(matrix: matrix))
    }
}

struct ChoosMatrixView: View {
    let matrix: Matrix
    var body: some View {
        HStack(alignment: .bottom, spacing: 0){
            ForEach(0..<self.matrix.columns, id: \.self){ j in
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<self.matrix.rows, id: \.self){ i in
                        Text(" " + String(self.matrix[i, j]) + "  ")
                            .frame(height: 35.0)
                            .frame(minWidth: 40)
                            .padding(4)
                    }
                }
            }
        }.background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.3)))
    }
}

struct MatrixView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Text("Изменяемая:")
            ChangeableMatrixView(matrix: ObservableMatrix(Matrix([[0,0,0],[0,0,0],[0,0,0]])))
            Text("Неизменяемая:")
            UnchangeableMatrixView(matrix: Matrix([[0,0,0],[0,0,0],[0,0,0]]))
        }
    }
}
