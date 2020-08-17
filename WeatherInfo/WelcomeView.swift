//
//  WelcomeView.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/31.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    let cities: [Province.City] = Bundle.main.decode("cities.json")
    @State private var userCity = ""
    @State var showflag = true
    var body: some View {
        ZStack {
            if showflag {
                //打开输入城市的界面
                NavigationView{
                    VStack {
                        HStack {
                            Text("请输入您所在的城市：")
                                .font(Font.system(size: 35))
                            Spacer()
                        }.padding()
                        TextField("添加城市", text: $userCity, onCommit: addCity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        Spacer()
                    }
                    .navigationBarTitle("欢迎使用", displayMode: .inline)
                    .navigationBarItems(trailing: Button("确定") {
                        self.showflag.toggle()
                    })
                }
            }
            else {
                //打开天气信息界面
                ContentView()
            }
        }
    }
    func addCity() {
        for member in self.cities {
            if member.city == userCity {
                //存入缓存
                UserDefaults.standard.set(member.cityid, forKey: "CityId")
            }
        }
        
    }
}
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
