//
//  ObservableMatrix.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

final class ObservableMatrix: ObservableObject {
    @Published var WarpedMatrix: Matrix
    var WithSameSize: [ObservableMatrix] = []
    var WithInversSize: [ObservableMatrix] = []
    
    let isSquare: Bool
    let unchangingNumberOfColumns: Bool
    let unchangingNumberOfRows: Bool
    
    init(_ mtarix: Matrix, isSquare: Bool = false, unchangingNumberOfColumns: Bool = false, unchangingNumberOfRows: Bool = false){
        self.WarpedMatrix = mtarix
        self.isSquare = isSquare
        self.unchangingNumberOfRows = unchangingNumberOfRows
        self.unchangingNumberOfColumns = unchangingNumberOfColumns
    }
}


final class ObservableMatrixForEditing: ObservableObject {
    let nf: NumberFormatter
    let fontSize: Int
    let oldMatrix: ObservableMatrix
    @Published var kostil =  false
    @Published var newMatrix: ObservableMatrix
    @Published var I: Int
    @Published var J: Int
    @Published var editingNumber: String
    init(_ m: ObservableMatrix, numberFormater: NumberFormatter, fontSize: Int) {
        nf = numberFormater
        oldMatrix = m
        self.fontSize = fontSize
        newMatrix = ObservableMatrix(m.WarpedMatrix)
        I = 0
        J = 0
        editingNumber = numberFormater.string(from: NSNumber(value: m.WarpedMatrix[0,0])) ?? "0"
    }
    func changeIndex(_ i: Int, _ j: Int) {
        newMatrix.WarpedMatrix[I,J] = nf.number(from: editingNumber) as? Double ?? newMatrix.WarpedMatrix[I,J]
        I = i
        J = j
        editingNumber = nf.string(from: NSNumber(value: newMatrix.WarpedMatrix[i,j])) ?? "0"
    }
    func addNumber(_ n: Int) {
        if editingNumber != "0"{
            editingNumber += String(n)
        } else {
            editingNumber = String(n)
        }
    }
    func changePlusMinus() {
        if editingNumber.first == "-" {
            editingNumber = String(editingNumber.dropFirst())
        } else {
            editingNumber = "-" + editingNumber
        }
    }
    func deliltNumber(){
        if editingNumber.count > 1{
            editingNumber = String(editingNumber.dropLast())
        } else {
            editingNumber = "0"
        }
    }
    func deliltNumbers(){
        editingNumber = "0"
    }
    func addDecimalPoint(){
        if let i = editingNumber.firstIndex(of: "."){
            editingNumber.remove(at: i)
        }
        editingNumber += "."
    }
    func cancel(){
        editingNumber = nf.string(from: NSNumber(value: oldMatrix.WarpedMatrix[0,0])) ?? "0"
    }
    func endEditind(){
        newMatrix.WarpedMatrix[I,J] = nf.number(from: editingNumber) as? Double ?? newMatrix.WarpedMatrix[I,J]
        oldMatrix.WarpedMatrix = newMatrix.WarpedMatrix
    }
    func removeRow(){
        if oldMatrix.unchangingNumberOfRows == false {
            newMatrix.WarpedMatrix.RemoveRow()
            if oldMatrix.isSquare{
                newMatrix.WarpedMatrix.RemoveColumn()
            }
            kostil.toggle()
        }
    }
    func addRow(){
        if oldMatrix.unchangingNumberOfRows == false {
            newMatrix.WarpedMatrix.AddRow()
            if oldMatrix.isSquare {
                newMatrix.WarpedMatrix.AddColumn()
            }
            kostil.toggle()
        }
    }
    func addColumn(){
        if oldMatrix.unchangingNumberOfColumns == false {
            newMatrix.WarpedMatrix.AddColumn()
            if oldMatrix.isSquare{
                newMatrix.WarpedMatrix.AddRow()
            }
            kostil.toggle()
        }
    }
    func removeColumn() {
        if oldMatrix.unchangingNumberOfColumns == false {
            if oldMatrix.isSquare{
                newMatrix.WarpedMatrix.RemoveRow()
            }
            newMatrix.WarpedMatrix.RemoveColumn()
            kostil.toggle()
        }
    }
}

//Добавить свойства изменения количества столбцов, ссылки на связаные с кол-вом столбцов матрицы
