//
//  ProvinceListView.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/13.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct ProvinceListView: View {
    let cities: [Province.City] = Bundle.main.decode("cities.json")
    @State private var cityid = 0
    @ObservedObject var weather: WeatherInfo
    @Environment(\.presentationMode) var prsenteationMode
    
    var provinces: [Province] {
        var provinces = [Province]()
        for member in cities {
            if member.parentid == 0 {
                provinces.append(Province(id: member.cityid, cityName: member.city, cityList: cities))
            }
        }
        return provinces
    }
    
    var body: some View {
        Form {
            ForEach(provinces, id: \.id) { item in
                Picker(item.city, selection: self.$cityid) {
                    ForEach(item.cities, id: \.cityid) { cc in
                        Text(cc.city)
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button("确定") {
            UserDefaults.standard.set(self.cityid, forKey: "CityId")
            self.weather.cityid = self.cityid
            self.prsenteationMode.wrappedValue.dismiss()
        })
            .navigationBarTitle(Text("选择城市"), displayMode: .inline)
    }
}
struct ProvinceListView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceListView(weather: WeatherInfo())
    }
}
