//
//  Bundle-Decodeable.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/8.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation
extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        //1.获取json文件
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find the \(file)")
        }
        //2.Data方式获取指定文件
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load the data from \(file)")
        }
        //3.解析data
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode the data from\(file)")
        }
        return loaded
    }
}
