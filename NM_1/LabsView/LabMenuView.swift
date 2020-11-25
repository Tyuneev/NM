//
//  LabMenuView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 09.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct LabMenuView: View {
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Лрболаторная 1")){
                    NavigationLink(destination: Lab1_1View()){
                        Text("Определитель, обратная матрица, решение СЛАУ при помощи LU разложения")
                    }
                    NavigationLink(destination: Lab1_2View()){
                        Text("Решение СЛАУ методом прогонки")
                    }
                    NavigationLink(destination: Lab1_3View()){
                        Text("Решение СЛАУ методами Зенделя и простых итераций")
                    }
                    NavigationLink(destination: Lab1_4View()){
                        Text("Собственные значения и векторы симетрической матрицы")
                    }
                    NavigationLink(destination: Lab1_5View()){
                        Text("Собственные значения через QR разложение")
                    }
                }
                Section(header: Text("Лрболаторная 2")){
//                    NavigationLink(destination:  Lab2_1View()){
//                        Text("Решение нелинейных уравнеий")
//                    }
                    NavigationLink(destination:  Lab2_2View()){
                        Text("Решение нелинейных уравнеий")
                    }

                    
                }
                Section(header: Text("Лрболаторная 3")){
                    NavigationLink(destination: Lab3_1View()){
                        Text("Интерполяционные многочлены Лагранжа и Ньютона")
                    }
                    NavigationLink(destination: Lab3_2View()){
                        Text("Кубический сплайн")
                    }
                    NavigationLink(destination: Lab3_3View()){
                        Text("Приближающие многочлены")
                    }
                    NavigationLink(destination: Lab3_4View()){
                        Text("Численое диференцирование")
                    }
                    NavigationLink(destination: Lab3_5View()){
                        Text("Численое интегрирование")
                    }
                }
                
                Section(header: Text("Лрболаторная 4")){
                    NavigationLink(destination: Lab4_1View()){
                        Text("Задача Коши ОДУ")
                    }
                    NavigationLink(destination: Lab4_2View()){
                        Text("Краевая задача ОДУ")
                    }
                }
                Section{
                    NavigationLink(destination: DataView()){
                        HStack{
                            Image(systemName: "bookmark.fill")
                            Text("Сохраненные матрицы")
                        }
                    }
                    NavigationLink(destination: SettingsView()){
                        HStack{
                            Image(systemName: "gear")
                            Text("Настройки")
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Лаболаторные"))

        }
    }
}

struct LabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LabMenuView()
    }
}
