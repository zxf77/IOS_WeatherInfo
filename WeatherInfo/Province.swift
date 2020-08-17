//
//  Province.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/13.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation
struct Province:Identifiable, Codable {
    struct City: Codable {
        let cityid: Int
        let parentid: Int
        let citycode: String?
        let city: String 
    }
    let id: Int
    let city: String
    let cities: [City]
    init(id: Int, cityName: String, cityList: [City]) {
        self.id = id
        self.city = cityName
        //创建一个parentid与传递的id值相等的城市列表数组
        var matches = [City]()
        for member in cityList {
            if member.parentid == id {
                matches.append(member)
            }
        }
        self.cities = matches
    }
}
