//
//  MatrixView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI


struct ChangeableMatrixView: View {
    enum ActivSheetView {
        case EditView, SaveMatrixView, ChoosSavedMatrixView, No
    }
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var matrix: ObservableMatrix
    @State private var showActionSheet = false
    @State private var showSeetView = false
    @State private var activSheet: ActivSheetView = .No
    @State private var ShowEditor = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 10){
            ForEach(0..<self.matrix.WarpedMatrix.columns, id: \.self){ j in
                VStack(alignment: .center, spacing: 10) {
                    ForEach(0..<self.matrix.WarpedMatrix.rows, id: \.self){ i in
                        let nf = self.settings.numberFormater
                        Text(nf.string(from: NSNumber(value: self.matrix.WarpedMatrix[i, j])) ?? "")
                            //.bold()
                            .font(.system(size: CGFloat(settings.fontSize)))
                        //.frame(height: 35.0)
                            //.frame(minWidth: 40)
                            .layoutPriority(1)
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.3)
            )
        )
        .onTapGesture {
            self.showActionSheet = true
            //self.activSheet = .EditView
            //self.showSeetView = true
        }
        .sheet(isPresented: $showSeetView){
            self.SheetView()
        }
//        .onLongPressGesture {
//            self.showActionSheet = true
//        }
        .actionSheet(isPresented: $showActionSheet){
            self.actionSheet()
        }
    }
    
    func actionSheet() -> ActionSheet{
        return ActionSheet(title: Text("Действия").font(.title),
                buttons: [
                    .cancel(),
//                    .default(Text("Изменить"), action: {
//                        self.showSeetView = true
//                        self.activSheet = .EditView
//                    }),
                    .default(Text("Сохранить"), action: {
                        UIApplication.shared.windows.first?.rootViewController?.present(self.SavingAlert(), animated: true)
                        //self.showSaveMatrixView = true
                        
                    }),
                    .default(Text("Изменить"), action: {
                        self.activSheet = .EditView
                        self.showSeetView = true
                    }),
                    .default(Text("Выбрать из сохраненных"), action: {
                        self.activSheet = .ChoosSavedMatrixView
                        self.showSeetView = true
                    })
                ])
    }
    func SheetView() -> AnyView {
        switch self.activSheet {
        case .EditView:
            return AnyView(InputView(matrix, numberFormatter: settings.numberFormater, fontSize: settings.fontSize))

//            return AnyView(TmpEditView().environmentObject(matrix))
        case .SaveMatrixView:
            return AnyView(SaveMatrixView(matrix: self.matrix.WarpedMatrix))
        case .ChoosSavedMatrixView:
            return AnyView(DataForChoosView().environmentObject(matrix))
        case .No:
            return AnyView(EmptyView())
        }
    }
    func SavingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Сохранение матрицы", message: "", preferredStyle: .alert)
        alert.addTextField(){ (text) in
            text.placeholder = "имя матрицы"
        }
        let saving = UIAlertAction(title: "Сохранить", style: .default) {_ in
            let name = alert.textFields![0].text ?? ""
            if name != "" {
                let realmeManager = RealmManager()
                realmeManager.addMatrix(matrix: self.matrix.WarpedMatrix, withName: name)
            }
            
        }
        alert.addAction(saving)
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        return alert
    }
}

struct UnchangeableMatrixView: View {
    @EnvironmentObject var settings: UserSettings
    let matrix: Matrix
    @State private var showActionSheet = false
    @State private var showSaveMatrixView = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10){
            ForEach(0..<self.matrix.columns, id: \.self){ j in
                VStack(alignment: .center, spacing: 10) {
                    ForEach(0..<self.matrix.rows, id: \.self){ i in
                        Text(toString(self.matrix[i, j]))
                            .font(.system(size: CGFloat(settings.fontSize)))
                            //.bold()
                            //.frame(height: 35.0)
                            //.frame(minWidth: 40)
                            //.padding(4)
                    }
                }
                //.frame(maxWidth: .infinity)
                //.layoutPriority(2)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.4)))
        .onTapGesture {self.showActionSheet = true}
        .sheet(isPresented: $showSaveMatrixView, content: { SaveMatrixView(matrix: self.matrix)})
        .actionSheet(isPresented: $showActionSheet, content: {
            ActionSheet(title: Text("Действия").font(.title), buttons: [
                .cancel(),
                .default(Text("Сохранить"), action: {
                    UIApplication.shared.windows.first?.rootViewController?.present(self.SavingAlert(), animated: true)
                    //self.showSaveMatrixView = true
                    
                }),
                .default(Text("Применить другой алгоритм"), action: {
                    
                })
            ])
        })
    }
    func toString(_ n: Double) -> String{
        return self.settings.numberFormater.string(for: NSNumber(value: n)) ?? ""
    }
    func SavingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Сохранение матрицы", message: "", preferredStyle: .alert)
        alert.addTextField(){ (text) in
            text.placeholder = "имя матрицы"
        }
        let saving = UIAlertAction(title: "Сохранить", style: .default) {_ in
            let name = alert.textFields![0].text ?? ""
            if name != "" {
                let realmeManager = RealmManager()
                realmeManager.addMatrix(matrix: self.matrix, withName: name)
            }
        }
        alert.addAction(saving)
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        return alert
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
                            .font(.system(size: 15))
                            .frame(height: 35.0)
                            .frame(minWidth: 40)
                            .padding(4)
                    }
                }
            }
        }.background(RoundedRectangle(cornerRadius: 10)
        .fill(Color.blue.opacity(0.3)))
    }
}

struct MatrixView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Text("Изменяемая:")
            UnchangeableMatrixView(matrix: (Matrix([[1.0,2.0,3.0,4.0]])))
//            ScrollView(.horizontal){
//            ChangeableMatrixView(matrix: ObservableMatrix(Matrix([[1,2,3,4]])))
//            }
//            ScrollView(.horizontal){
//            ChangeableMatrixView(matrix: ObservableMatrix(Matrix([[10000000,1000000,0,10000],[0,0,10000,0],[0,0,1000,0]])))
//            }
//            Text("Неизменяемая:")
//            UnchangeableMatrixView(matrix: Matrix([[0,0,0],[0,0,0],[0,0,0]]))
        }
    }
}
