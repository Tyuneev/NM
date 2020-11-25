//
//  DifferentialEquations.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 17.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

struct BoundaryProblem{
    enum Method{
        case finiteDifference, shooting
    }
    // y" + p(x)y' + q(x)y = f(x)
    // a1*y'(x0) +  b1*y(x0) =  c1
    // a2*y'(x1) +  b2*y(x1) =  c2
    // y'(x1) = y1 =  c - b*y(x1)
    
    let p: ((Double)->Double)
    let q: ((Double)->Double)
    let f: ((Double)->Double)
    
    let a1: Double
    let b1: Double
    let c1: Double
    let a2: Double
    let b2: Double
    let c2: Double
    let x0: Double
    let x1: Double
    
    func table(h: Double, accuracy: Double = 0.01, method: Method) -> ([Double], [Double],  Int){
        switch method {
        case .finiteDifference:
            let res = FiniteDifference(h: h)
            return (res.0, res.1, 1)
        case .shooting:
            return ShootingMethod(accuracy: accuracy, h: h)
        }
    }
    
    func ShootingMethod(accuracy e: Double, h: Double) -> ([Double], [Double], Int){
        var nOld = 1.0
        var result =
            CauchyProblem(p: p, q: q, f: f, x0: x0, x1: x1, y0: (b1 == 0.0 ? nOld : (c1-a1*nOld)/b1), dy0: (a1 == 0 ? nOld : (c1-b1*nOld)/a1))
            .table(method: .Eiler, h: h)
        var Fold: Double = (a2*result.1.last![1] + b2*result.1.last![0] - c2)
        var  F = Fold
        var n = 0.8
        var count = 1
        repeat {
            result =
                CauchyProblem(p: p, q: q, f: f, x0: x0, x1: x1, y0: (b1 == 0.0 ? n : (c1-a1*n)/b1), dy0: (a1 == 0 ? n : (c1-b1*n)/a1))
                    .table(method: .Eiler, h: h)
            F = (a2*result.1.last![1] + b2*result.1.last![0] - c2)
            let nNew  =  n - (n-nOld)/(F-Fold)*F
            Fold = F
            nOld = n
            n = nNew
            print(F)
            count += 1
        } while F > e || -F > e
        print(F)
        return (result.0, result.1.compactMap{$0.first}, count)

    }
    
    func FiniteDifference(h: Double) -> ([Double], [Double]){
        var x = [x0]
        while (x.last! < x1) {
            x.append(x.last! + h)
        }
        let N = x.count - 1
        
        var A: [Double] = [0.0]
        var B: [Double] = [(b1*h-a1)]
        var C: [Double] = [(a1)]
        var D: [Double] = [(c1*h)]
        
        for i in 1...N-1{
            A.append(1-p(x[i])*h/2)
            B.append(-2+h*h*q(x[i]))
            C.append(1+p(x[i])*h/2)
            D.append(h*h*f(x[i]))
        }
        A.append(-a2)
        B.append(b2*h+a2)
        C.append(0.0)
        D.append(c2*h)
        let y = (SolveSALE(a: A, b: B, c: C, d: D) ?? [])
        return (x, y)
    }
}


struct CauchyProblem {
    enum methods{
        case Eiler, RK, Adams
    }
    let dy: [((Double, [Double])->Double)]
    let y0: [Double]
    let x0: Double
    let x1: Double
    
    init(p: @escaping ((Double) -> Double), q: @escaping ((Double) -> Double), f: @escaping ((Double) -> Double), x0: Double, x1: Double,  y0: Double, dy0: Double){
        dy = [{$1[1]},
              {f($0)-p($0)*$1[1]-q($0)*$1[0]}]
        self.x0 = x0
        self.x1 = x1
        self.y0 = [y0, dy0]
    }
    
    func table(method: methods, h: Double) -> ([Double], [[Double]]){
        var x = [x0]
        var y = [y0]
        if(method == .Adams){
            for _ in 0...2{
                let xNew = ((x.last! + h) > x1 ? x1 : (x.last! + h))
                y.append(RK(xNew: xNew, x: x.last!, y: y.last!))
                x.append(xNew)
            }
        }
        while (x.last! < x1) {
            let xNew = ((x.last! + h) > x1 ? x1 : (x.last! + h))
            switch method {
            case .Eiler:
                y.append(Eiler(xNew: xNew, x: x.last!, y: y.last!))
            case .RK:
                y.append(RK(xNew: xNew, x: x.last!, y: y.last!))
            case .Adams:
                y.append(Adams(xNew: xNew, x: x.suffix(4), y: y.suffix(4)))
            }
            x.append(xNew)
        }
        return (x, y)
    }
    
    func Eiler(xNew: Double, x: Double, y: [Double]) -> [Double]{
        let h = xNew - x
        return zip(y, dy).map{($0+h*$1(x, y))}
    }
    
    func RK(xNew: Double, x: Double, y: [Double]) -> [Double]{
        let h = xNew - x
        let Y = Matrix(column: y)
        
        let K1 = Matrix(column: dy.map{h*$0(x,y)})
        let K2 = Matrix(column: dy.map({h*$0(x+0.5*h, (Y+0.5*K1).VectorAsArray())}))
        let K3 = Matrix(column: dy.map({h*$0(x+0.5*h, (Y+0.5*K2).VectorAsArray())}))
        let K4 = Matrix(column: dy.map({h*$0(x+h, (Y+K3).VectorAsArray())}))
        
        let Δ = (1/6)*(K1 + 2*K2 + 2*K3 + K4)
        return (Y + Δ).VectorAsArray()
    }
    
    func Adams(xNew: Double, x: [Double], y: [[Double]]) -> [Double]{
        let h = xNew - x[3]
        let Y = Matrix(column: y[3])
        let f = (0...3).map{ i in
            Matrix(column: dy.map({$0(x[i], y[i])}))
        }
        
        return (Y + (h/24)*(55*f[3] - 59*f[2] + 37*f[1] - 9*f[0]) ).VectorAsArray()
    }
}


