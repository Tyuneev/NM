//
//  Test2UIView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 21.08.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Test2UIView: View {
    var body: some View {
        Text(String(1000000000000000)).frame(maxWidth: .infinity)
    }
}

struct Test2UIView_Previews: PreviewProvider {
    static var previews: some View {
        Test2UIView()
    }
}
