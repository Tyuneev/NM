//
//  InputView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 21.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct MatrixEditView: View {
    @ObservedObject var model: ObservableMatrixForEditing
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack{
            HStack{
                VStack(spacing: 0){
                    HStack(spacing: 0) {
                        ForEach(0..<model.newMatrix.WarpedMatrix.columns, id: \.self) { j  in
                            VStack(alignment: .center, spacing: 0){
                                ForEach(0..<model.newMatrix.WarpedMatrix.rows, id: \.self) { i in
                                    item(i,j)
                                }
                            }
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.4)))
                
                VStack(alignment: .center, spacing: 0){
                    Image(systemName: "plus.circle")
                        .font(.system(size: 18))
                        .foregroundColor(Color.green)
                        .onTapGesture {model.addColumn()}
                    Spacer()
                        .frame(height: 18)
                    Image(systemName: "minus.circle")
                        .font(.system(size: 18))
                        .foregroundColor(Color.red)
                        .onTapGesture { model.removeColumn() }
                }
            }
            HStack(alignment: .center, spacing: 0){
                Image(systemName: "minus.circle")
                    .font(.system(size: 18))
                    .foregroundColor(Color.red)
                    .onTapGesture {model.removeRow()}
                Spacer()
                    .frame(width: 18)
                Image(systemName: "plus.circle")
                    .font(.system(size: 18))
                    .foregroundColor(Color.green)
                    .onTapGesture {model.addRow()}
                Spacer()
                    .frame(width: 20)
            }.padding(.vertical, 4)
        }
        .frame(minWidth: UIApplication.shared.windows[0].frame.width - 30,
               minHeight: UIApplication.shared.windows[0].frame.width - 30, alignment: .center)
    }
    func item(_ i: Int, _ j: Int) -> AnyView{
        let size = CGFloat(model.fontSize)
        if i == model.I, j == model.J {
            return AnyView(
                Text(model.editingNumber)
                    .lineLimit(1)
                    .font(.system(size: size))
                    .padding(15)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))

            )
        } else {
            let nf = model.nf
            return AnyView(
                Text(nf.string(from: NSNumber(value: (model.newMatrix.WarpedMatrix[i,j]))) ?? "")
                    .lineLimit(1)
                    .font(.system(size: size))
                    .padding(15)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        model.changeIndex(i, j)
                    }
            )
        }
    }
}

struct NumPadView: View {
    var model: ObservableMatrixForEditing
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(){
            HStack{
                Button(action: {model.addNumber(1)}){
                    Image(systemName: "1.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                        .shadow(radius: 10)
                }
                Button(action: {model.addNumber(2)}){
                    Image(systemName: "2.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.addNumber(3)}){
                    Image(systemName: "3.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.deliltNumbers()}){
                    Image(systemName: "multiply.circle")
                        .font(.system(size:65))
                        .foregroundColor(.red)
                }
            }
            HStack{
                Button(action: {model.addNumber(4)}){
                    Image(systemName: "4.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.addNumber(5)}){
                    Image(systemName: "5.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.addNumber(6)}){
                    Image(systemName: "6.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.deliltNumber()}){
                    Image(systemName: "delete.left")
                        .font(.system(size:63))
                        .foregroundColor(.orange)
                }
            }
            HStack{
                Button(action: {model.addNumber(7)}){
                    Image(systemName: "7.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.addNumber(8)}){
                    Image(systemName: "8.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.addNumber(9)}){
                    Image(systemName: "9.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.cancel()}){
                    Image(systemName: "arrow.uturn.backward.circle")
                        .font(.system(size:65))
                        .foregroundColor(.yellow)
                }
            }
            HStack{
                Button(action: {model.changePlusMinus()}){
                    Image(systemName: "plusminus.circle")
                        .font(.system(size:65))
                        .foregroundColor(.gray)
                }
                Button(action: {model.addNumber(0)}){
                    Image(systemName: "0.circle")
                        .font(.system(size:65))
                        .foregroundColor(.black)
                }
                Button(action: {model.addDecimalPoint()}){
                    Image(systemName: "smallcircle.fill.circle")
                        .font(.system(size:65))
                        .foregroundColor(.gray)
                }
                Button(action: {
                    model.endEditind()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "checkmark.circle")
                        .font(.system(size:65))
                        .foregroundColor(.green)
                }
            }
        }
    }
}


struct InputView: View {
    let model: ObservableMatrixForEditing

    init(_ m: ObservableMatrix, numberFormatter nf: NumberFormatter, fontSize: Int){
        model = ObservableMatrixForEditing(m, numberFormater: nf, fontSize: fontSize)
    }
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                ScrollView(.vertical){
                    MatrixEditView(model: model)
                        .padding()
                }
            }
            Spacer()
            NumPadView(model: model)
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(ObservableMatrix(Matrix([[1,2,3],[0.123,1241252.0000001, 0]])), numberFormatter: NumberFormatter(), fontSize: 10)
    }
}
