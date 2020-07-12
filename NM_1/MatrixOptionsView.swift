//
//  MatrixOptionsView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct СhangeableMatrixOptionsView: View {
    var body: some View {
        HStack(){
            Image(systemName: "tray.and.arrow.up.fill")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.white)
                .padding()
                
            Image(systemName: "tray.and.arrow.down.fill")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.white)
                .padding()
            Image(systemName: "arrowshape.turn.up.right.fill")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.white)
                .padding()
            Image(systemName: "pencil")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.white)
                .padding()
        }
        .background(Capsule()
            .fill(Color.blue.opacity(0.9)))
    }
}

struct UnchangeableMatrixOptionsView: View {
    var body: some View {
        HStack(){
            Image(systemName: "tray.and.arrow.up.fill")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.white)
                .padding()
           
            Image(systemName: "arrowshape.turn.up.right.fill")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.white)
                .padding()
        }
        .background(Capsule()
            .fill(Color.blue.opacity(0.9)))
    }
}
struct MatrixOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        СhangeableMatrixOptionsView()
    }
}

