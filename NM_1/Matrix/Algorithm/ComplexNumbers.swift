//
//  ComplexNumbers.swift
//  LM_LA
//
//  Created by Алексей Тюнеев on 04.03.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

struct Complex{
    let Re: Double
    let Im: Double
    var Radius : Double {
        get{
            return(sqrt(Re*Re+Im*Im))
        }
    }
    var Conjugate: Complex {
        get{
            return Complex(Re: self.Re, Im: -self.Im)
        }
    }
    static func -(Left: Complex, Right: Complex) -> Complex{
        return Complex(Re: Left.Re - Right.Re, Im: Left.Im - Right.Im)
    }
    func toString() -> String {
        if Im > 0 { return "\(Re) + i*\(Im)"}
        if Im < 0 { return "\(Re) - i*\(-Im)"}
        else  { return "\(Re)"}
    }
    //+,-,<,*,...
}

func SolveQuadraticEquation(a: Double, b: Double, c: Double)-> (Complex, Complex){
    let Discriminant = b*b-4*a*c
    if Discriminant < 0{
        return(Complex(Re: -b/(2*a), Im: sqrt(-Discriminant)/(2*a)), Complex(Re: -b/(2*a), Im: -sqrt(-Discriminant)/(2*a)))
    }
    return (Complex(Re: (-b+sqrt(Discriminant))/(2*a), Im: 0), Complex(Re: (-b-sqrt(-Discriminant))/(2*a), Im: 0))
}


