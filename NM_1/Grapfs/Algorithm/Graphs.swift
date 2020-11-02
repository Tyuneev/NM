//
//  Graphs.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 05.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//
import SwiftUI
import Foundation

struct Graphs {
    let graphs: [Graph]
    let points: [Point]
    let markOnX: Double
    let markOnY: Double
    
    var minX: Double
    var maxX: Double
    var maxY: Double
    var minY: Double
    
    var kx = 0.0
    var ky = 0.0
    var height = 0.0
    var width = 0.0
    
    func c
    let kX = Double(g.size.width)/(self.graphs.maxX - self.graphs.minX)
    let kY  = -Double(g.size.height)/(self.graphs.maxY - self.graphs.minY)
    
    
    
    init(graphs: [Graph], points: [Point] = [],  markOnX: Double = 1, markOnY: Double = 1){
        self.graphs = graphs
        self.points = points
        self.markOnX = markOnX
        self.markOnY = markOnY
        self.minX = graphs.reduce(0){
            min($0, $1.points.reduce(0){
                min($0, $1.0)
            })
        }
        self.maxX = graphs.reduce(0){
            max($0, $1.points.reduce(0){
                max($0, $1.0)
                
            })
        }
        self.maxY = graphs.reduce(0){
            max($0, $1.points.reduce(0){
                max($0, $1.1)
            })
        }
        self.minY = graphs.reduce(0){
            min($0, $1.points.reduce(0){
                min($0, $1.1)
            })
        }
    }
}

struct Point: Identifiable {
    let id = UUID()
    var point: (Double, Double)
    var color: Color = Color.black
}

struct Graph: Identifiable {
    let id = UUID()
    var points: [(Double, Double)] = []
    var color: Color = Color.black
    var InterpolationMethod: interpolate?
    var function: ((Double) -> Double?)? = nil
    func GetPoint(_ x: Double) -> Double?{
        if let IM = self.InterpolationMethod,
            let from = IM.Points.first?.0,
            let to = IM.Points.last?.0,
            x <= to, x >= from{
            return IM.GetPoint(x)
        }
        else if let f = function {
            return f(x)
        }
        else {
            return nil
        }
    }
    
    enum interpolationMethod {
        case lagrange
        case newton
        case cubicSpline
        case msm
    }
    
    init(interpolatePoints: [(Double, Double)], method: interpolationMethod, step: Double, pow: Int? = nil) {
        switch method {
        case .lagrange:
            self.InterpolationMethod = Lagrange(Points: interpolatePoints)
        case .newton:
            self.InterpolationMethod = Newton(Points: interpolatePoints)
        case .cubicSpline:
            self.InterpolationMethod = CubicSpline(Points: interpolatePoints)
        case .msm:
            self.InterpolationMethod = MSM(Points: interpolatePoints, pow: pow ?? 1)
        
        }
        
        var x = interpolatePoints.first!.0
        while x < interpolatePoints.last!.0{
            points.append((x, self.InterpolationMethod!.GetPoint(x)))
            x += step
        }
        points.append(interpolatePoints.last!)
        print(points)
        
    }
    
    init(function f:  @escaping ((Double) -> Double), from: Double, to: Double, step: Double) {
        //let f1 = f
        self.function = { x in
            (x<from || x > to) ? nil : f(x)
        }
        var x = from
        while (x < to) {
            self.points.append((x, f(x)))
            x += step
        }
        if x - step < to {
            points.append((to, f(to)))
        }
    }
}

protocol interpolate {
    var Points: [(Double, Double)] { get }
    func GetPoint(_ x: Double) -> Double
}

struct Lagrange: interpolate{
    let Points: [(Double, Double)]
    func GetPoint(_ x: Double) -> Double {
        return Points.reduce(0) { (s, i) in
            s + Points.reduce(i.1){ (m, j) in
                m*((i.0 != j.0) ? (x-j.0)/(i.0-j.0) : 1.0)
            }
        }
    }
}

struct Newton: interpolate{
    let Points: [(Double, Double)]
    let Table: [[Double]]
    init(Points: [(Double, Double)]) {
        self.Points = Points
        var TmpTable: [[Double]] = [[]]
        TmpTable[0] = Points.map{$0.1}
        for column in 1..<Points.count{
            TmpTable.append([])
            for row in 0..<(Points.count-column){
                TmpTable[column].append((TmpTable[column-1][row]-TmpTable[column-1][row+1])/(Points[row].0-Points[row+column].0))
            }
        }
        self.Table = TmpTable
    }
    func GetPoint(_ x: Double) -> Double{
        var result = Table[0][0]
        for i in 1..<Table.count{
            var item = Table[i][0]
            for j in 0..<i{
                item *= x-Points[j].0
            }
            result += item
        }
        return result
    }
}

struct CubicSpline: interpolate {
    let Points: [(Double, Double)]
    var a: [Double]
    var b: [Double]
    var c: [Double]
    var d: [Double]

    init(Points: [(Double, Double)]) {
        self.Points = Points
        self.a = [0]
        self.b = [0]
        self.c = [0, 0]
        self.d = [0]

        let h: [Double] = [0.0] + ((zip(Points, Points.dropFirst())).map{$1.0-$0.0})

        var A: [Double] = []
        var B: [Double] = []
        var C: [Double] = []
        var D: [Double] = []
        
        for i in 2..<Points.count {
            A.append(((i > 2) ? (h[i-1]) : 0))
            B.append(2*(h[i-1]+h[i]))
            C.append(((i != Points.count - 1) ? h[i] : 0))
            D.append((3*(((Points[i].1 - Points[i-1].1)/h[i]) - ((Points[i-1].1 - Points[i-2].1)/h[i-1]))))
        }
        c += (SolveSALE(a: A, b: B, c: C, d: D) ?? [])
        for i in 1..<Points.count {
            a.append(Points[i-1].1)
            if(i != Points.count - 1){
                b.append((Points[i].1 - Points[i-1].1)/h[i] - h[i]*(c[i+1]+2*c[i])/3)
                d.append((c[i+1]-c[i])/(3*h[i]))
            }  else {
                b.append(((Points[i].1 - Points[i-1].1)/h[i]) - (2*h[i]*c[i]/3))
                d.append(-c[i]/(3*h[i]))
            }
        }
    }

    func GetPoint(_ x: Double) -> Double{
        var i = 1
        while !(Points[i-1].0 <= x && Points[i].0 >= x) {
            i += 1
        }
        return    a[i]
                + b[i] * (x-Points[i-1].0)
                + c[i] * pow((x-Points[i-1].0), 2)
                + d[i] * pow((x-Points[i-1].0), 3)
    }
}

//func Test(){
//    let DemoX = [0.1, 0.5, 0.9, 1.3]
//    let xVarA = [-2.0, -1.0, 0.0, 1.0]
//    let xVarB = [-2.0, -1.0, 0.2, 1.0]
//
//    func Y(_ x: Double) -> Double {
//        return (x + exp(x))
//    }
//
//    let DemoL = Lagrange(Points: DemoX.map{($0,log($0))})
//    let La = Lagrange(Points: xVarA.map{($0,Y($0))})
//    let Lb = Lagrange(Points: xVarB.map{($0,Y($0))})
//    print(DemoL.GetPoint(0.8))
//    print(La.GetPoint(-0.5))
//    print(Lb.GetPoint(-0.5))
//}



struct MSM: interpolate {
    let Points: [(Double, Double)]
    var a: [Double]
    func GetPoint(_ x: Double) -> Double {
        return a.enumerated().reduce(0){$0 + $1.element*pow(x, Double($1.offset))}
    }
    init(Points: [(Double, Double)], pow k: Int = 2){
        self.Points = Points
        var A = Matrix(rows: k+1, columns: k+1, defaultValue: 0)
        var B = Matrix(rows: k+1, [Double].init(repeating: 0, count: k+1))
        for i in 0...k {
            for j in 0...k {
                A[i,j] = Points.reduce(0){$0+pow($1.0, Double(i+j))}
            }
            B[i,0] = Points.reduce(0){$0+$1.1*pow($1.0, Double(i))}
        }
        self.a = SolveSLAE(A: A, B: B)!.Transpose().elements[0]
    }
}


