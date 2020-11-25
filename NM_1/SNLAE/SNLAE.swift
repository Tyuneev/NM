//
//  SNLAE.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 18.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation
import SwiftUI

struct ststemOfFunction {
    var size: Int
    let f: [([Double])->Double]
    let df: [[([Double])->Double]]
    let p: [([Double])->Double]
    let fImage: Image
    let dfImage: Image
    let pImage: Image
    let graph: Image
    
    func NiewtonsMethod(x: [Double], acurcy: Double = 0.001, count: Int = 1) -> ([Double], Int){
        guard count < 10000 else {
            return (x, 1000)
        }
        var A = Matrix(rows: size, columns: size, defaultValue: 0)
        var B = Matrix(rows: size, columns: 1, defaultValue: 0)
        for i in 0..<size {
            for j in 0..<size {
                A[i,j] = df[i][j](x)
            }
            B[i,0] = -f[i](x)
        }
        let new_x = (Matrix(column: x) + SolveSLAE(A: A, B: B)!).Transpose().elements[0]
        return ((Matrix(column: x) - Matrix(column: new_x)).NormOfMartix1() > acurcy) ?
            NiewtonsMethod(x: new_x, acurcy: acurcy, count: count+1) :
            (new_x, count)
    }

    func SimpleIterationMethod(x: [Double], acurcy: Double = 0.001, count: Int = 1) -> ([Double], Int){
        guard count < 10000 else {
            return (x, 1000)
        }
        let x_new = p.map{$0(x)}
        return (Matrix(column: x) - Matrix(column: x_new)).NormOfMartix1() > acurcy ?
            SimpleIterationMethod(x: x_new, acurcy: acurcy, count: count+1) :
            (x_new, count)
    }
}

struct Function {
    let f: (Double)->Double
    let df: (Double)->Double
    let p: (Double)->Double
    let fImage: Image
    let dfImage: Image
    let pImage: Image
    let graph: Image
    
    func NiewtonsMethod(x: Double, acurcy: Double = 0.001, count: Int = 1) -> (Double, Int){
        guard count < 10000 else { return (x, 1000) }
        let new_x = x - f(x)/df(x)
        return (abs(x-new_x) > acurcy) ?
            NiewtonsMethod(x: new_x, acurcy: acurcy, count: count+1) :
            (new_x, count)
    }

    func SimpleIterationMethod(x: Double, acurcy: Double = 0.001, count: Int = 1) -> (Double, Int){
        guard count < 10000 else { return (x, 1000) }
        let new_x = p(x)
        return (abs(x-new_x) > acurcy) ?
            SimpleIterationMethod(x: new_x, acurcy: acurcy, count: count+1) :
            (new_x, count)
    }
}

