//
//  Matrix.swift
//  LM_LA
//
//  Created by Алексей Тюнеев on 04.03.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation
import Darwin

struct Matrix {
    var elements: [[Double]] = []
    var rows: Int, columns: Int

    subscript(x:Int, y:Int) -> Double {
        get { return (x<rows && y<rows && x>=0 && y>=0) ? elements[x][y] : 0.0 }
        set(val) { (x<rows && y<rows && x>=0 && y>=0) ? elements[x][y] = val : ()}
    }
    
    func InverseMatrix() -> Matrix?{
        guard let LU = LUdecomposition() else{
            return nil
        }
        let n = rows
        var Clomns: [[Double]] = []
        for i in 0..<n{
            var row = [Double](repeating: 0.0, count: n)
            row[i] = 1
            guard let Clumn = SolveSLAE(LUdecomposition: LU, B: row) else {
                return nil
            }
            Clomns.append(Clumn)
        }
        let InverseTranspose = Matrix(Clomns)
        return InverseTranspose.Transpose()
    }
    
    func Determinant() -> Double? {
        guard let LU = LUdecomposition() else{
            return nil
        }
        var Result = 1.0
        for i in 0..<columns{
            Result *= LU.0[i,i]*LU.1[i,i]
        }
        return ((LU.2.count/2)%2 == 1 ? -Result : Result)
    }
    
    init<T: DoubleConvertible>(rows: Int, columns: Int, defaultValue: T){
        self.rows = rows
        self.columns = columns
        elements = [[Double]](repeating: [Double](repeating: defaultValue.ConvertToDouble(), count: columns), count: rows)
    }
    
    init<T: DoubleConvertible>(rows: Int, _ numbers: [T]){
        self.rows = rows
        self.columns = 1
        for i in numbers{
            elements.append([i.ConvertToDouble()])
        }
    }
    
    init<T: DoubleConvertible>(_ numbers: [[T]]){
        self.rows = numbers.count
        self.columns = (rows == 0 ? 0 : numbers[0].count)
        for i in numbers{
            elements.append([])
            for j in i{
                elements[elements.count - 1].append(j.ConvertToDouble())
            }
        }
    }
    
    init<T: DoubleConvertible>(column: [T]){
        self.rows = column.count
        self.columns = 1
        for i in column{
            elements.append([i.ConvertToDouble()])
        }
    }
    
    init(IdentityWithSize: Int){
        self.rows = IdentityWithSize
        self.columns = IdentityWithSize
        elements = [[Double]](repeating: [Double](repeating: 0.0, count: columns), count: rows)
        for i in 0..<columns{
           elements[i][i] = 1.0
        }
    }
    
    init(rows: Int, columns: Int,  X: Matrix, Instruction: (Int, Int, Matrix) -> Double){
        self.rows = rows
        self.columns = columns
        elements = [[Double]](repeating: [Double](repeating: 0.0, count: columns), count: rows)
        for i in 0..<rows{
            for j in 0..<columns{
                elements[i][j] = Instruction(i, j, X)
            }
        }
    }
    
    func Transpose() -> Matrix{
        var ResultElements = [[Double]](repeating: [Double](repeating: 0.0, count: rows), count: columns)
        for i in 0..<rows{
            for j in 0..<columns{
                ResultElements[j][i] = elements[i][j]
            }
        }
        return Matrix(ResultElements)
    }
    
    func IsSquare() -> Bool{
        return self.columns == self.rows
    }
    
    func SLUdecomposition() -> (Matrix, Matrix, Matrix)? {
        guard let LUs = self.LUdecomposition() else {
            return nil
        }
        var S = Matrix(IdentityWithSize: self.rows)
        var i = 0
        while i < LUs.2.count{
            S.SwapRows(LUs.2[i], LUs.2[i+1])
            i = i+2
        }
        return (S, LUs.0, LUs.1)
    }
    
    func LUdecomposition() -> (Matrix, Matrix, [Int])? {
        guard self.IsSquare() else {
            return nil
        }
        var U = self
        let n = self.columns
        var swaps : [Int] = []
        var L = Matrix(IdentityWithSize: n)
        for i in 1..<n{
            var M = Matrix(IdentityWithSize: n)
            for k in i..<n{
                if U[i-1,i-1] == 0.0 {
                    var j = 0
                    while U[i+j,i-1] == 0.0 && i+j < n{
                        j += 1
                    }
                    if i+j == n{
                        return nil
                    }
                    U.SwapRows(i-1, i+j)
                    swaps += [i-1, i+j]
                }
                M[k,(i-1)] = -U[k,i-1]/U[i-1,i-1]
                L[k,(i-1)] = -M[k,(i-1)]
            }
            U = M * U
        }
        return (L, U, swaps)
    }
    
    func QRdecomposition() -> (Matrix, Matrix)?{
        let n = self.columns
        var Q = Matrix(IdentityWithSize: n)
        var R = self
        for i in 0..<n-1{
            var v = [Double](repeating: 0.0, count: n)
            for j in i..<n{
                v[j] = (i == j ? 0 : R[j, i])
                v[i] += R[j,i]*R[j,i]
            }
            v[i] = sqrt(v[i])
            if R[i,i] < 0{
                v[i] *= -1.0
            }
            v[i] += R[i,i]
            let H = Matrix(IdentityWithSize: n) - (2/(Matrix([v])*Matrix(column: v))[0,0])*(Matrix(column: v)*Matrix([v]))
            R = H*R
            Q = Q*H
        }
//        print("QR:")
//        R.printMatrix()
//        Q.printMatrix()
//        (Q*R).printMatrix()
//        self.printMatrix()
        return (Q, R)
    }
    
    func printMatrix(Round: Double = 100){
        for i in 0..<self.rows{
            var Roundet = [Double](repeating: 0.0, count: self.columns)
            for j in 0..<self.columns{
                Roundet[j] = round(elements[i][j]*Round)/Round
            }
            print(Roundet)
        }
        print("")
    }
    mutating func AddRow(){
        self.rows += 1
        self.elements.append([Double](repeating: 0.0, count: self.columns))
    }
    mutating func AddColumn(){
        self.columns += 1
        for i in 0..<self.rows {
            self.elements[i].append(0.0)
        }
    }

    mutating func RemoveRow(){
        if self.rows > 1 {
            self.elements.removeLast()
            self.rows -= 1
        }
    }
    mutating func RemoveColumn(){
        if self.columns > 1 {
            self.columns -= 1
            for i in 0..<self.rows {
                self.elements[i].removeLast()
            }
        }
    }
    mutating func SwapRows(_ n1: Int, _ n2: Int){
        elements.swapAt(n1, n2)
    }
    
    mutating func SwapColums(_ n1: Int, _ n2: Int){
        var M = self.Transpose()
        M.SwapRows(n1, n2)
        M = M.Transpose()
        self.elements = M.elements
    }
    
    static func ==(Left : Matrix, Right : Matrix) -> Bool {
        if Left.columns != Right.columns || Left.rows != Right.rows{
            return false
        }
        for i in 0..<Right.rows{
            for j in 0..<Right.columns{
                if Left[i,j] != Right[i,j]{
                    return false
                }
            }
        }
        return true
    }
    
    static func *(Left : Matrix, Right : Matrix) -> Matrix {
        var ResultElements = [[Double]](repeating : [Double](repeating: 0.0, count: Right.columns), count: Left.rows)
        for i in 0..<Left.rows{
            for j in 0..<Right.columns{
                for k in 0..<Left.columns{
                    ResultElements[i][j] += (Left[i, k] * Right[k, j])
                }
            }
        }
        return Matrix(ResultElements)
    }
    
    static func ^(Left : Matrix, Right : Int) -> Matrix {
        var Result = Left
        for _ in 0..<Right{
            Result = Result * Left
        }
        return Result
    }
    
    static func *(Left : Double, Right : Matrix) -> Matrix {
        var ResultElements = [[Double]](repeating: ([Double](repeating: 0.0, count: Right.columns)), count: Right.rows)
        for i in 0..<Right.columns{
            for j in 0..<Right.rows{
                ResultElements[i][j] += Right[i,j]*Left
            }
        }
        return Matrix(ResultElements)
    }
    
    static func *<T: DoubleConvertible>(Left : Matrix, Right : [T]) -> [Double] {
        var Result = [Double](repeating: 0.0, count: Left.rows)
        for i in 0..<Left.rows{
            for k in 0..<Left.columns{
                Result[i] += (Left[i, k] * Right[k].ConvertToDouble())
            }
        }
        return Result
    }
    
    static func *(Left : Matrix, Right : Double) -> Matrix {
        return Right*Left
    }
    
    static func +(Left : Matrix, Right : Matrix) -> Matrix {
        var ResultElements = [[Double]](repeating: ([Double](repeating: 0.0, count: Left.columns)), count: Left.rows)
        for i in 0..<Left.rows{
            for j in 0..<Left.columns{
                ResultElements[i][j] += Right[i,j] + Left[i,j]
            }
        }
        return Matrix(ResultElements)
    }
    
    static func -(Left : Matrix, Right : Matrix) -> Matrix {
        var ResultElements = [[Double]](repeating: ([Double](repeating: 0.0, count: Left.columns)), count: Left.rows)
        for i in 0..<Left.rows{
            for j in 0..<Left.columns{
                ResultElements[i][j] = Left[i,j] - Right[i,j]
            }
        }
        return Matrix(ResultElements)
    }
    
    static func ===(Left : Matrix, Right : Matrix) -> Bool {
        return (Left.columns == Right.columns && Left.rows == Right.rows)
    }
}

protocol DoubleConvertible {
    func ConvertToDouble() -> Double
}

extension Int: DoubleConvertible {
    func ConvertToDouble() -> Double{
        return Double(self)
    }
}
extension Double: DoubleConvertible {
    func ConvertToDouble() -> Double{
        return self
    }
}

extension Array where Element: DoubleConvertible {
    func NormOfVector1() -> Double {
        var N = 0.0
        for i in self{
            N += abs(i.ConvertToDouble())
        }
        return N
    }
}

extension Matrix{
    func NormOfMartix1() -> Double {
        var N = 0.0
        let m = self.Transpose()
        for i in m.elements{
            var s = 0.0
            for j in i{
                s += abs(j)
            }
            N = max(N, s)
        }
        return N
    }
}
extension Matrix{
    func Round(_ r: Double = 100) -> Matrix{
        var Resulr = self
        for i in 0..<Resulr.rows{
            for j in 0..<Resulr.columns{
                Resulr[i,j] = round(Resulr[i,j]*r)/r
            }
        }
        return Resulr
    }
}
