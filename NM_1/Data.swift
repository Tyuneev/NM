//
//  Data.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

struct SavedMatrix: Identifiable {
    var id = UUID()
    var name: String
    var matrix: Matrix
}

var MatrixArr = [SavedMatrix(name: "M1", matrix: Matrix([[1,2,3],[1,2,3],[1,2,3]])),
                 SavedMatrix(name: "M2", matrix: Matrix([[1,1,1],[1,1,1],[1,1,1]])),
                 SavedMatrix(name: "M3", matrix: Matrix([[1,2,3],[1,2,3]])),
                 SavedMatrix(name: "M4", matrix: Matrix([[1,1],[1,1],[1,1]]))]

var Data: [String : Matrix] = ["M1" : Matrix([[1,2,3],[1,2,3],[1,2,3]]), "M2" : Matrix([[1,1,1],[1,1,1],[1,1,1]]),"M3" : Matrix([[1,2,3],[1,2,3]]), "M4" : Matrix([[1,1],[1,1],[1,1]])]
