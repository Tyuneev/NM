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
    
    let minX: Double
    let maxX: Double
    let maxY: Double
    let minY: Double
    
    
    init(graphs: [Graph], points: [Point] = [],  markOnX: Double = 1, markOnY: Double = 1){
        self.graphs = graphs
        self.points = points
        self.markOnX = markOnX
        self.markOnY = markOnY
        
        var tmpMinX = min(markOnX, graphs.reduce(0){
            min($0, $1.points.reduce(0){
                min($0, $1.0)
            })
        })
        var tmpMaxX = max(markOnX, graphs.reduce(0){
            max($0, $1.points.reduce(0){
                max($0, $1.0)
            })
        })
        var tmpMaxY = max(markOnY, graphs.reduce(0){
            max($0, $1.points.reduce(0){
                max($0, $1.1)
            })
        })
        var tmpMinY = min(markOnY, graphs.reduce(0){
            min($0, $1.points.reduce(0){
                min($0, $1.1)
            })
        })
        
        if -tmpMinX < tmpMaxX/9{
            tmpMinX = -tmpMaxX/9
        }
        if -tmpMinY < tmpMaxY/9{
            tmpMinY = -tmpMaxY/9
        }
        if tmpMaxX < -tmpMinX/9{
            tmpMaxX = -tmpMinX/9
        }
        if tmpMaxY < -tmpMinY/9{
            tmpMaxY = -tmpMinY/9
        }
        
//        if tmpMinX == markOnX{
//            tmpMinX = markOnX - (tmpMaxY - tmpMinX)/9
//        }
//        if tmpMinY == markOnY{
//            tmpMinX = markOnY - (tmpMaxY - tmpMinY)/9
//        }
        if tmpMaxX < markOnX + (tmpMaxX - tmpMinX)/9{
            tmpMaxX = markOnX + (tmpMaxX - tmpMinX)/9
        }
        if tmpMaxY < markOnY + (tmpMaxY - tmpMinY)/9{
            tmpMaxY = markOnY + (tmpMaxY - tmpMinY)/9
        }


        
        self.minX = tmpMinX
        self.maxX = tmpMaxX
        self.maxY = tmpMaxY
        self.minY = tmpMinY
        
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
    var InterpolationMethod: interpolate? = nil
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
    
    init(interpolatePoints: [(Double, Double)], method: interpolationMethod, step: Double, pow: Int? = nil, color: Color = .black) {
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
        let lastPoint = interpolatePoints.last ?? (0.0, 0.0)
        var x = (interpolatePoints.first ?? (0.0, 0.0)).0
        while x < lastPoint.0{
            points.append((x, self.InterpolationMethod!.GetPoint(x)))
            x += step
        }
        points.append((lastPoint.0,
                       self.InterpolationMethod!.GetPoint(lastPoint.0)))
        self.color = color
    }
    init(_ points: [(Double, Double)], color: Color = .black){
        self.points = points
        self.color = color
    }
    init(function f:  @escaping ((Double) -> Double), from: Double, to: Double, step: Double, color: Color = .black) {
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
        self.color = color
    }
}

protocol interpolate {
    var Points: [(Double, Double)] { get }
    func GetPoint(_ x: Double) -> Double
    func GetPolynomial(_ numbrAfterPoint: Int)->String
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
    func GetPolynomial(_ numbrAfterPoint: Int = 5) -> String {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = numbrAfterPoint
        func toString(_ n: Double)->String{
            nf.string(from: NSNumber(value: n)) ?? ""
        }
        
        var result = ""
        guard Points.count != 0 else{
            return ""
        }
        for i in 0..<Points.count{
            var k = 1.0
            var tmp = ""
//            if result != "", Points[i].1 > 0{
//                result+="+"
//            }
            
            for j in 0..<Points.count{
                if i != j{
                    if Points[j].0 == 0 {
                        tmp = "x"+tmp
                    } else if Points[j].0 > 0{
                        tmp += "(x-"+toString(Points[j].0)+")"
                    } else{
                        tmp += "(x+"+toString(-Points[j].0)+")"
                    }
                    k /= Points[i].0 - Points[j].0
                }
            }
            if k > 0, result != ""{
                result += "+"+toString(k) + tmp
            } else {
                result += ""+toString(k) + tmp
            }
        }
        return "L(x)="+result
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
    func GetPolynomial(_ numbrAfterPoint: Int = 5) -> String {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = numbrAfterPoint
        func toString(_ n: Double)->String{
            nf.string(from: NSNumber(value: n)) ?? ""
        }
        var result = ""
        for i in 0..<Points.count {
            var tmp = ""
            if i != 0 {
                for j in 0..<i {
                    if Points[j].0 > 0 {
                        tmp += "(x-"+toString(Points[j].0)+")"
                    } else if Points[j].0 < 0{
                        tmp += "(x"+toString(Points[j].0)+")"
                    } else {
                        tmp  = "x" + tmp
                    }
                }
            }
            if Table[i][0] > 0, result != ""{
                result += "+"+toString(Table[i][0])+tmp
            } else if Table[i][0] < 0 || result == "" {
                result += toString(Table[i][0])+tmp
            }
        }
        return "N(x)=" + result
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
    func GetPolynomial(_ numbrAfterPoint: Int = 5) -> String {
        guard Points.count > 1 else {
            return ""
        }
        let nf = NumberFormatter()
        nf.maximumFractionDigits = numbrAfterPoint
        func toString(_ n: Double)->String{
            nf.string(from: NSNumber(value: n)) ?? ""
        }
        var result = [String](repeating: "", count: Points.count)
        for i in 1..<Points.count {
            if a[i] != 0{
                result[i] += toString(a[i])
            }
            if b[i] != 0{
                if b[i] > 0, result[i] != "" {
                    result[i] += "+"+toString(b[i])
                } else  {
                    result[i] += ""+toString(b[i])
                }
                if Points[i-1].0 > 0 {
                    result[i] += "(x"+toString(-Points[i-1].0)+")"
                } else if Points[i-1].0 < 0{
                    result[i] += "(x+"+toString(Points[i-1].0)+")"
                } else {
                    result[i] += "x"
                }
            }
            if c[i] != 0 {
                if c[i] > 0, result[i] != "" {
                    result[i] += "+"+toString(c[i])
                } else  {
                    result[i] += ""+toString(c[i])
                }
                if Points[i-1].0 > 0 {
                    result[i] += "(x"+toString(-Points[i-1].0)+")^2"
                } else if Points[i-1].0 < 0{
                    result[i] += "(x+"+toString(Points[i-1].0)+")^2"
                } else {
                    result[i] += "x^2"
                }
            }
            if d[i] != 0 {
                if d[i] > 0, result[i] != "" {
                    result[i] += "+"+toString(d[i])
                } else  {
                    result[i] += ""+toString(d[i])
                }
                if Points[i-1].0 > 0 {
                    result[i] += "(x"+toString(-Points[i-1].0)+")^3"
                } else if Points[i-1].0 < 0{
                    result[i] += "(x+"+toString(Points[i-1].0)+")^3"
                } else {
                    result[i] += "x^3" + "  "
                }
            }
        }
        var Result = ""
        for i in result.dropFirst().enumerated(){
            Result += "f"+toString(Double(i.offset))+"(x)="
            Result += i.element
            Result += " "
        }
        return Result
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
struct integralResult{
    let methodH1: Double
    let methodH2: Double
    let errorMethodH1: Double
    let errorMethodH2: Double
    let RRR: Double
    let errorRRR: Double
}
struct integrals{
    let f: ((Double)->Double)
    let x1: Double
    let x2: Double
    func Points(h: Double)->[(Double, Double)]{
        var points = [(Double, Double)]()
        var X = x1
        repeat {
            points.append((X, f(X)))
            X += h
        } while X <= x2
        return points
    }
    func rectangleMethod(h: Double) -> Double{
        let x = Points(h: h).map{$0.0}
        return zip(x.dropLast(), x.dropFirst()).map({h*f(($0+$1)/2)}).reduce(0.0){$0+$1}
    }
    
    func trapezeMethod(h: Double) -> Double{
        let y = Points(h: h).map{$0.1}
        return  zip(y.dropLast(), y.dropFirst()).map({($0+$1)*h}).reduce(0.0,{($0+$1)})/2
    }
    
    func simpsonMethod(h: Double) -> Double{
        let y = Points(h: h).map{$0.1}
        return h/3*(y.dropFirst().dropLast().enumerated().reduce(0.0, {$0+($1.element * (($1.offset % 2 != 0) ? 2 : 4))}) + y.first! + y.last!)
    }
    
    func  rungeRombergMethod(k: Int, p: Int, F1: Double, F2: Double) -> Double{
        return (F1 + (F1-F2)/(pow(Double(k), Double(p)) - 1))
    }
}

struct derivatives{
    let Points: [(Double, Double)]
    let derivatives1: [Double]
    let derivatives2: [Double]
    
    init(points: [(Double, Double)]){
        Points = points
        derivatives1 = zip(points.dropLast(), points.dropFirst()).map{
            ($1.1 - $0.1)/($1.0-$0.0)
        }
        
        var tmp: [Double] = []
        for i in 1..<Points.count - 1{
            tmp.append(2*(derivatives1[i] - derivatives1[i-1])/(points[i+1].0 - points[i-1].0))
        }
        derivatives2 = tmp
    }
    func interval(x: Double)->Int{
        guard
            x>=Points.first!.0, x<=Points.last!.0 else {
            return -1
        }
        for i in 0..<Points.count - 1{
            if Points[i].0 <= x, x <= Points[i + 1].0{
                return i
            }
        }
        return Points.count-2
    }
    
    func dir2(_ x: Double)->Double?{
        let i = interval(x: x)
        guard i != -1 else {
            return nil
        }
        guard i < derivatives2.count else {
            return derivatives2.last
        }
        return derivatives2[i]
    }
    
    func dir1(_ x: Double)->Double?{
        var i = interval(x: x)
        guard i != -1 else {
            return nil
        }
        if i > derivatives2.count - 2{
           i = derivatives2.count-2
        }
        
        return (derivatives2[i] + (derivatives2[i+1] - derivatives2[i])/(Points[i+2].0-Points[i].0)*(2*x - Points[i+1].0-Points[i].0))
    }
    
    
    func derivative(_ x: Double, pow: Int = 1, accuracy: Int = 1) -> (Double, Double?){
        var i = 0
        for j in 0..<Points.count - 1 {
            if Points[j+1].0  >= x {
                if pow == 1, accuracy == 1{
                    if Points[j+1].0 == x, j+2<Points.count {
                        return (derivatives1[j],  derivatives1[j+1])
                    }
                    return (derivatives1[j], nil)
                }
                i = j
            }
        }
        if pow == 2{
            if i == Points.count - 2{
                i -= 1
            }
            return (derivatives2[i], nil)
        }
        i += 1
        return  (pow == 1 ? ((derivatives2[i-1] + (derivatives2[i] - derivatives2[i-1])/(Points[i+1].0-Points[i-1].0)*(2*x - Points[i].0-Points[i-1].0)), nil) : (derivatives2[i-1], nil))
    }
}


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
    func GetPolynomial(_ numbrAfterPoint: Int = 5) -> String {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = numbrAfterPoint
        func toString(_ n: Double)->String{
            nf.string(from: NSNumber(value: n)) ?? ""
        }
        var result = ""
        for i in 0..<a.count{
            if a[i] != 0{
                if a[i] > 0, result != ""{
                    result += "+"+toString(a[i])
                } else {
                    result += ""+toString(a[i])
                }
                if i == 1{
                    result += "x"
                } else if i > 1 {
                    result += "x^"+toString(Double(i))
                }
            }
        }
        return "F(x)=" + result
    }
}


