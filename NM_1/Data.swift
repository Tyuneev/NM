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


var MatrixArr = [
        SavedMatrix(name: "M1", matrix:
            Matrix([[1,-1,1,-2],
                    [-9,-1,1,8],
                    [-7,0,8,-6],
                    [3,-5,1,-6]])),
        SavedMatrix(name: "M2", matrix:
            Matrix([[-20,60,-60,-44]]).Transpose()),
        SavedMatrix(name: "M3", matrix:
            Matrix([[8,-2,0,0,0],
                    [7,-19,9,0,0],
                    [0,-4,21,-8,0],
                    [0,0,7,-23,9],
                    [0,0,0,4,-7]])),
        SavedMatrix(name: "M4", matrix:
            Matrix([[-14,-55,49,86,8]]).Transpose()),
        SavedMatrix(name: "M5", matrix:
            Matrix([[18,8,-3,4],
                    [-7,15,-5,-2],
                    [-4,0,13,4],
                    [-8,-8,-6,31]])),
        SavedMatrix(name: "M6", matrix:
            Matrix([[-84,-5,-38,263]]).Transpose()),
        SavedMatrix(name: "M7", matrix:
            Matrix([[2,8,7],
                    [8,2,7],
                    [2,7,-8]])),
        SavedMatrix(name: "M8", matrix:
            Matrix([[-2,7,-6],
                    [-1,9,-4],
                    [-1,8,-3]]))
]

//var Data: [String : Matrix] = [
//    "M1" : Matrix([[1,-1,1,-2],
//                   [-9,-1,1,8],
//                   [-7,0,8,-6],
//                   [3,-5,1,-6]]),
//    
//    "M2" : Matrix([[-20,60,-60,-44]]).Transpose(),
//    
//    "M3" : Matrix([[8,-2,0,0,0],
//                   [7,-19,9,0,0],
//                   [0,-4,21,-8,0],
//                   [0,0,7,-23,9],
//                   [0,0,0,4,-7]]),
//    
//    "M4" : Matrix([[-14,-55,49,86,8]]).Transpose(),
//    
//    "M5" : Matrix([[18,8,-3,4],
//                  [-7,15,-5,-2],
//                  [-4,0,13,4],
//                  [-8,-8,-6,31]]),
//    
//    "M6" : Matrix([[-84,-5,-38,263]]).Transpose(),
//    
//    "M7" : Matrix([[2,8,7],
//                   [8,2,7],
//                   [2,7,-8]]),
//    
//    "M8" : Matrix([[-2,7,-6],
//                   [-1,9,-4],
//                   [-1,8,-3]])
//]
