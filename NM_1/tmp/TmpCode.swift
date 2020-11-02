//
//  TmpCode.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

final class ObservableMatrix: ObservableObject {
    @Published var WarpedMatrix: Matrix
    
    let isSquare: Bool
    let unchangingNumberOfColumns: Bool
    let unchangingNumberOfRows: Bool
    var numberFormater: NumberFormatter
    
    var maximumFractionDigits: Int {
        set {
            self.numberFormater.maximumFractionDigits = newValue
        }
        get{
            self.numberFormater.maximumFractionDigits
        }
    }
    init(_ mtarix: Matrix, isSquare: Bool = false, unchangingNumberOfColumns: Bool = false, unchangingNumberOfRows: Bool = false){
        self.WarpedMatrix = mtarix
        self.isSquare = isSquare
        self.unchangingNumberOfRows = unchangingNumberOfRows
        self.unchangingNumberOfColumns = unchangingNumberOfColumns
        self.numberFormater = NumberFormatter()
        self.numberFormater.maximumFractionDigits = 3
    }
}
//Добавить свойства изменения количества столбцов, ссылки на связаные с кол-вом столбцов матрицы
