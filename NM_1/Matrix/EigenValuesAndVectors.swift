//
//  EigenValuesAndVectors.swift
//  LM_LA
//
//  Created by Алексей Тюнеев on 04.03.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

func EigenValueQRDM(A: Matrix, Accuracy: Double) -> [Complex]?{
    let n = A.columns
    var a = A
    var ComlexValues = [Int: Complex]()
    while true{
        var end = true
        a.printMatrix()
        for i in 0..<n-1{
            var criterion = 0.0
            for j in (i+1)..<n{
                criterion += a[j,i]*a[j,i]
            }
            if sqrt(criterion) < Accuracy {
                ComlexValues[i] = nil
            } else { //возможно комплексная пара
                let NewComlxValue = SolveQuadraticEquation(a: 1.0, b: (-a[i,i]-a[i+1,i+1]), c: (a[i,i]*a[i+1,i+1]-a[i+1,i]*a[i,i+1])).0
                if NewComlxValue.Im != 0.0 {
                    if let OldValue = ComlexValues[i]{ //старое значение есть
                        if ((OldValue - NewComlxValue).Radius > Accuracy) { //критерий остановки не выполнился
                            end = false
                        }
                        ComlexValues[i] = NewComlxValue
                    } else{ //старого корня нет
                        end = false
                        ComlexValues[i] = NewComlxValue
                    }
                }
                else{
                    end = false
                }
            }
        }
        if end{
            break
        }
        guard let QR = a.QRdecomposition() else{
            return nil
        }
        a = QR.1*QR.0
    }
    var EigenValues = [Complex]()
    for i in 0..<n{
        EigenValues.append(Complex(Re: a[i,i], Im: 0.0))
    }
    for i in ComlexValues{
        EigenValues[i.key] = i.value
        EigenValues[i.key+1] = i.value.Conjugate
    }
    return EigenValues
}

func EigenValueAndVectorsRM(A: Matrix, Accuracy: Double) -> ([Double], [[Double]])?{
    guard A == A.Transpose() ||  A.columns != A.rows else{
        return nil
    }
    let n = A.columns
    var a = A
    var EigenvectorsMatric = Matrix(IdentityWithSize: n)
    while true{
        a.printMatrix()
        var max = 0.0; var I = 0; var J = 0; var criterion = 0.0
        for i in 0..<n{
            for j in 0..<i{
                criterion += a[i,j]*a[i,j]
                if abs(a[i,j]) > max{
                    max = abs(a[i,j])
                    I = i
                    J = j
                }
            }
        }
        if sqrt(criterion) < Accuracy{
            print(sqrt(criterion))
            break
        }
        var U = Matrix(IdentityWithSize: n)
        U.printMatrix()
        let f = atan(2*a[I,J]/(a[I,I]-a[J,J]))/2
        U[I,J] = -sin(f)
        U[J,I] = sin(f)
        U[I,I] = cos(f)
        U[J,J] = cos(f)
        U.printMatrix()
        a = (U.Transpose())*a*U
        EigenvectorsMatric = EigenvectorsMatric*U
    }
    var Eigenvalue = [Double]()
    for i in 0..<n{
        Eigenvalue.append(a[i,i])
    }
    return(Eigenvalue, (EigenvectorsMatric.Transpose()).elements)
}
