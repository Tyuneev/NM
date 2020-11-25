//
//  ChengeIndexView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 23.11.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct ChengeIndexView: View {
    @Binding var index: Int
    let images: [Image]
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(0..<images.count){ i in
                    images[i]
                        .resizable()
                        .aspectRatio(contentMode: .fit)//обрезка по фигуре
                        
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke((i==index ? Color.red : Color.gray), lineWidth: 3))
                        .padding(10)
                        .onTapGesture {index = i}
                        //.shadow(radius: 8)
                }
            }
        }
    }
}

//struct ChengeIndexView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChengeIndexView(index: Binding<Int>(1), images: [
//            Image("4.1.1"),
//            Image("4.2.17"),
//            Image("4.2.17")
//        ])
//    }
//}
