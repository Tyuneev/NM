//
//  Lab3.2View.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 13.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct Lab3_2View: View {
    @ObservedObject var columnX = ObservableMatrix(
        Matrix([[0.0, 1.7, 3.4, 5.1, 6.8, 8.5]]).Transpose())
    @ObservedObject var columnY = ObservableMatrix(
        Matrix([[0.0, 3.0038, 5.2439, 7.3583, 9.4077, 11.415]]).Transpose())
    var body: some View {
        GraphView(graphs:
            Graphs(
                graphs: [
                    Graph(interpolatePoints: makePointsPair(), method: .msm, step: 0.01)
                ],
                markOnX: 1,
                markOnY: 1)
        ).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    func makePointsPair()-> [(Double, Double)]{
        zip(columnX.WarpedMatrix.Transpose().elements[0],
            columnY.WarpedMatrix.Transpose().elements[0]).map{($0,$1)}
    }
}

struct Lab3_2View_Previews: PreviewProvider {
    static var previews: some View {
        Lab3_2View()
    }
}
