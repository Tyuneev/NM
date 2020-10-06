//
//  SLAE.swift
//  NM
//
//  Created by Алексей Тюнеев on 12.03.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

func SolveSLAE(A: Matrix, B: Matrix) -> Matrix? {
    guard let Res = SolveSLAE(LUdecomposition: A.LUdecomposition(), B: B.Transpose().elements[0]) else{
        return nil
    }
    return Matrix([Res]).Transpose()
}

func SolveSLAE(LUdecomposition: (Matrix, Matrix, [Int])?, B: [Double]) -> [Double]?{
    guard let LU = LUdecomposition else {
        return nil
    }
    let L = LU.0
    let U = LU.1
    let Swaps = LU.2
    let n = L.columns
    guard B.count == n else {
        return nil
    }
    var b = B
    var k = 0
    while k < Swaps.count{
        b.swapAt(Swaps[k], Swaps[k+1])
        k+=2
    }
    var Result = b
    for i in 1..<n{
        for j in 0..<i{
            Result[i] -= L[i,j]*Result[j]
        }
    }
    Result[n-1] /= U[n-1,n-1]
    for i in 1..<n{
        for p in 0...i-1{
            Result[n-1-i] -= U[n-1-i,n-1-p]*Result[n-1-p]
        }
        Result[n-1-i] /= U[n-1-i,n-1-i]
    }
    return Result
}

func SolveSALE<T: DoubleConvertible>(a: [T], b: [T], c: [T], d: [T]) -> [Double]?{
    let n = a.count
    guard (n == b.count) && (n == c.count) && (n == d.count) else{
        return nil
    }
    var P = [-c[0].ConvertToDouble()/b[0].ConvertToDouble()]
    var Q = [d[0].ConvertToDouble()/b[0].ConvertToDouble()]
    for i in 1..<n{ P.append(-c[i].ConvertToDouble()/(b[i].ConvertToDouble()+a[i].ConvertToDouble()*P[i-1]))
        Q.append((d[i].ConvertToDouble()-a[i].ConvertToDouble()*Q[i-1])/(b[i].ConvertToDouble()+a[i].ConvertToDouble()*P[i-1]))
    }
    var Result = Q
    for i in 1..<n{
        Result[n-1-i] = P[n-1-i]*Result[n-i] + Q[n-1-i]
    }
    return Result
}

func SolveSLAE_ZendelMethod<T: DoubleConvertible>(A: Matrix?, B: [T]?, Accuracy: Double) -> ([Double]?, Int){
    guard let A = A else {
        return (nil, 0)
    }
    guard let B = B else {
        return (nil, 0)
    }
    let n = A.columns
    guard A.rows == n && B.count == n else {
        return (nil, 0)
    }
    var b = [Double](repeating: 0.0, count: n)
    var a = Matrix(rows: n, columns: n, defaultValue: 0.0)
    for i in 0..<n{
        b[i] = B[i].ConvertToDouble()/A[i,i]
        for j in 0..<n{
            a[i,j] = (i==j ? 0.0 : -A[i,j]/A[i,i])
        }
    }
    var a1 = a
    for i in 0..<n{
        for j in i..<n{
            a1[i,j] = 0
        }
    }
    let a2 = a - a1
    let k = (a.NormOfMartix1() < 1 ? a2.NormOfMartix1()/(1 - a.NormOfMartix1()) : 1)
    var x = b
    var xNew = b
    var counter = 0
    let E = Matrix(IdentityWithSize: n)
    repeat{
        x = xNew
        xNew = (Matrix([((E-a1).InverseMatrix() ?? E)*a2*x]) + Matrix([((E-a1).InverseMatrix() ?? E)*b])).elements[0]
        x = (Matrix([x]) - Matrix([xNew])).elements[0]
        counter += 1
    } while (k*x.NormOfVector1() > Accuracy)
    return (xNew, counter)
}

func SolveSLAE_SimpleIterationMethod<T: DoubleConvertible>(A: Matrix?, B: [T]?, Accuracy: Double) -> ([Double]?, Int){
    guard let A = A else {
        return (nil, 0)
    }
    guard let B = B else {
        return (nil, 0)
    }
    let n = A.columns
    guard A.rows == n && B.count == n else {
        return (nil, 0)
    }
    var b = [Double](repeating: 0.0, count: n)
    var a = Matrix(rows: n, columns: n, defaultValue: 0.0)
    for i in 0..<n{
        b[i] = B[i].ConvertToDouble()/A[i,i]
        for j in 0..<n {
            a[i,j] = (i==j ? 0.0 : -A[i,j]/A[i,i])
        }
    }
    let NormOfA = a.NormOfMartix1()
    let k = (NormOfA < 1 ? NormOfA/(1-NormOfA) : 1)
    var x = b
    var xNew = b
    var counter = 0
    repeat{
        x = xNew
        xNew = a*x
        for i in 0..<n{
            xNew[i] += b[i]
            x[i] -= xNew[i]
        }
        counter += 1
    } while (k*x.NormOfVector1() > Accuracy)
    return (xNew, counter)
}


func SolveSLAERunMethod(A: Matrix, B: Matrix) -> Matrix? {
    let n = A.columns
    guard n == A.rows, n == B.rows, B.columns == 1 else {
        return nil
    }
    var a: [Double] = []
    var b: [Double] = []
    var c: [Double] = []
    var d: [Double] = []
    var m = Matrix(IdentityWithSize: n)
    for i in 0..<n {
        a.append(A[i, i-1])
        b.append(A[i, i])
        c.append(A[i, i+1])
        d.append(B[i, 0])
        m[i,i-1] = A[i, i-1]
        m[i,i] = A[i, i]
        m[i,i+1] = A[i, i+1]
    }
    guard m == A, let res = SolveSALE(a: a, b: b, c: c, d: d) else {
        return nil
    }
    return Matrix([res]).Transpose()
}
