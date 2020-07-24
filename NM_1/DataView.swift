//
//  DataView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct DataView: View {
    @State var data: [SavedMatrix]
    var body: some View {
       List {
            ForEach(data) { m in
                Section(header: Text(m.name)) {
                    UnchangeableMatrixView(matrix: m.matrix)
                }
            }
            .onDelete{
                self.data.remove(atOffsets: $0)
                MatrixArr.remove(atOffsets: $0)
            }
       }
    }
}

struct DataForChoosView: View {
    @ObservedObject var matrix: ObservableMatrix
    @State var data: [SavedMatrix]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
           List {
                ForEach(data) { item in
                    Section(header: Text(item.name)) {
                        ChoosMatrixView(matrix: item.matrix)
                    }.onTapGesture {
                        self.matrix.WarpedMatrix = item.matrix
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
}

struct SaveMatrixView: View {
    let matrix: Matrix
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var name = ""
    var body: some View {
        VStack{
            Text("Имя матрицы:").padding()
            TextField("Имя матрицы", text: $name).padding()
            Button(action: {
                MatrixArr.append(SavedMatrix(name: self.name, matrix: self.matrix))
                self.presentationMode.wrappedValue.dismiss()
            },
             label: { Text("Готово")}).padding()
        }
    }
}


struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(data: MatrixArr)
    }
}
