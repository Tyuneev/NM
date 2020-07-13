//
//  TmpCode.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import Foundation

final class ObservableMatrix: ObservableObject {
    @Published var WarpedMatrix: Matrix
    
    init(_ mtarix: Matrix){
        WarpedMatrix = mtarix
    }
}
