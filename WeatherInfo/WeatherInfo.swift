//
//  WeatherInfo.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/8.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation
class WeatherInfo: ObservableObject, Decodable {
    enum CodingKeys: CodingKey {
        case result
    }
    enum ResultKey: CodingKey {
        case cityid, city, date, week, weather, temp, humidity, pressure, windspeed, winddirect, windpower, temphigh, templow, img, aqi, daily, hourly, index
    }
    enum AqiKey: String, CodingKey {
        case pm25 = "ipm2_5", quality, aqi, pm10, so2, no2, o3, co, timepoint, aqiinfo
    }
    enum AqiInfoKey: CodingKey {
        case affect, measure
    }
    enum DailyKey: CodingKey {
        case date, sunrise, sunset, week, night, day
    }
    enum NightKey: CodingKey {
        case weather, templow, img, winddirect, windpower
    }
    enum DayKey: CodingKey {
        case weather, temphigh, img
    }
    enum HourlyKey: CodingKey {
        case time, weather, temp, img
    }
    enum IndexKey: CodingKey {
        case iname, ivalue, detail
    }
    //每日天气结构体
    struct Daily: Decodable {
        var date: String = ""
        var week: String = ""
        var nightWeather: String = ""
        var tempLow: String = ""
        var nightImg: String = ""
        var dayWeather: String = ""
        var tempHigh: String = ""
        var dayImg: String = ""
        var windDirect: String = ""
        var windPower: String = ""
        var sunRise: String = ""
        var sunSet: String = ""
    }
    //每小时天气结构体
    struct Hourly: Decodable {
        var time: String = ""
        var weather: String = ""
        var temp: String = ""
        var img: String = ""
    }
    //生活指数结构体
    struct Index: Decodable {
        var iName: String = ""
        var iValue: String = ""
        var detail: String = ""
    }
    @Published var cityid: Int {
        didSet {
            UserDefaults.standard.set(cityid, forKey: "CityId")
        }
    }
    //Dictionary<> 字典形的数据
    @Published var cityWeather: Dictionary<String, String> = [
        "city": "",
        "weather": "",
        "temp": "",
        "img": "0",
        "humidity": "",
        "pressure": "",
        "windspeed": "",
        "winddirect": "",
        "windpower": "",
    ]
    //aqi相关信息的字典
    @Published var aqiInfo: Dictionary<String, String> = [
        "pm25": "",
        "quality": "",
        "aqi": "",
        "pm10": "",
        "so2": "",
        "no2": "",
        "o3": "",
        "co": "",
        "timepoint": "",
        "affect": "",
        "measure": ""
    ]
    //存放七天的天气信息变量
    @Published var daily = [Daily]()
    //存放今天的。。。
    @Published var today = Daily(date: "", week: "", nightWeather: "", tempLow: "", nightImg: "", dayWeather: "", tempHigh: "", dayImg: "")
    //明天。。。
    @Published var tomorrow = Daily(date: "", week: "", nightWeather: "", tempLow: "", nightImg: "", dayWeather: "", tempHigh: "", dayImg: "")
    //后天。。。
    @Published var afterTomorrow = Daily(date: "", week: "", nightWeather: "", tempLow: "", nightImg: "", dayWeather: "", tempHigh: "", dayImg: "")
    //存放24小时的天气信息变量
    @Published var hourly = [Hourly]()
    //存放生活指数
    @Published var index = [Index]()
    init() {
        let id = UserDefaults.standard.integer(forKey: "CityId")
        self.cityid = id
    }
    required init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try topContainer.nestedContainer(keyedBy: ResultKey.self, forKey: .result)
        cityid = try container.decode(Int.self, forKey: .cityid)
        cityWeather["city"] = try container.decode(String.self, forKey: .city)
        cityWeather["weather"] = try container.decode(String.self, forKey: .weather)
        cityWeather["temp"] = try container.decode(String.self, forKey: .temp)
        cityWeather["humidity"] = try container.decode(String.self, forKey: .humidity)
        cityWeather["pressure"] = try container.decode(String.self, forKey: .pressure)
        cityWeather["windspeed"] = try container.decode(String.self, forKey: .windspeed)
        cityWeather["winddirect"] = try container.decode(String.self, forKey: .winddirect)
        cityWeather["windpower"] = try container.decode(String.self, forKey: .windpower)
        cityWeather["img"] = try container.decode(String.self, forKey: .img)
        
        let aqiContainer = try container.nestedContainer(keyedBy: AqiKey.self, forKey: .aqi)
        //因为这个API传过来的aqi数据有时候是整形，有时候是字符串形
        if let aqi = try? aqiContainer.decode(String.self, forKey: .pm25) {
            aqiInfo["pm25"] = aqi
        } else {
            aqiInfo["pm25"] = String(try aqiContainer.decode(Int.self, forKey: .pm25))
        }
        aqiInfo["quality"] = try aqiContainer.decode(String.self, forKey: .quality)
        aqiInfo["aqi"] = try aqiContainer.decode(String.self, forKey: .aqi)
        aqiInfo["pm10"] = try aqiContainer.decode(String.self, forKey: .pm10)
        aqiInfo["so2"] = try aqiContainer.decode(String.self, forKey: .so2)
        aqiInfo["no2"] = try aqiContainer.decode(String.self, forKey: .no2)
        aqiInfo["o3"] = try aqiContainer.decode(String.self, forKey: .o3)
        aqiInfo["co"] = try aqiContainer.decode(String.self, forKey: .co)
        aqiInfo["timepoint"] = try aqiContainer.decode(String.self, forKey: .timepoint)
        let aqiInfoContainer = try aqiContainer.nestedContainer(keyedBy: AqiInfoKey.self, forKey: .aqiinfo)
        aqiInfo["affect"] = try aqiInfoContainer.decode(String.self, forKey: .affect)
        aqiInfo["measure"] = try aqiInfoContainer.decode(String.self, forKey: .measure)
        
        //解析数组类型时候的方案
        var dailyUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .daily)
        var dailyWeatherArray = [Daily]()
        while !dailyUnkeyedContainer.isAtEnd {
            let dailyContainer = try dailyUnkeyedContainer.nestedContainer(keyedBy: DailyKey.self)
            let dailyDate = try dailyContainer.decode(String.self, forKey: .date)
            let dailyWeek = try dailyContainer.decode(String.self, forKey: .week)
            let dailySunRise = try dailyContainer.decode(String.self, forKey: .sunrise)
            let dailySunSet = try dailyContainer.decode(String.self, forKey: .sunset)
            
            //进一步嵌套夜间数据
            let dailyNightContainer = try dailyContainer.nestedContainer(keyedBy: NightKey.self, forKey: .night)
            let nightWeather = try dailyNightContainer.decode(String.self, forKey: .weather)
            let nightTemplow = try dailyNightContainer.decode(String.self, forKey: .templow)
            let nightImg = try dailyNightContainer.decode(String.self, forKey: .img)
            let windDirect = try dailyNightContainer.decode(String.self, forKey: .winddirect)
            let windPower = try dailyNightContainer.decode(String.self, forKey: .windpower)
            
            //嵌套白天数据,和夜间数据关系是平行的
            let dailyDayContainer = try dailyContainer.nestedContainer(keyedBy: DayKey.self, forKey: .day)
            let dayWeather = try dailyDayContainer.decode(String.self, forKey: .weather)
            let dayTemphigh = try dailyDayContainer.decode(String.self, forKey: .temphigh)
            let dayImg = try dailyDayContainer.decode(String.self, forKey: .img)
            dailyWeatherArray.append(Daily(date: dailyDate, week: dailyWeek, nightWeather: nightWeather, tempLow: nightTemplow, nightImg: nightImg, dayWeather: dayWeather, tempHigh: dayTemphigh, dayImg: dayImg, windDirect: windDirect, windPower: windPower, sunRise: dailySunRise, sunSet: dailySunSet))
        }
        daily = dailyWeatherArray
        today = dailyWeatherArray[0]
        tomorrow = dailyWeatherArray[1]
        afterTomorrow = dailyWeatherArray[2]
        //解析24小时的天气信息,同为数组类型
        var hourlyUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .hourly)
        var hourlyWeatherArray = [Hourly]()
        while !hourlyUnkeyedContainer.isAtEnd {
            let hourlyContainer = try hourlyUnkeyedContainer.nestedContainer(keyedBy: HourlyKey.self)
            let hourlyTime = try hourlyContainer.decode(String.self, forKey: .time)
            let hourlyWeather = try hourlyContainer.decode(String.self, forKey: .weather)
            let hourlyTemp = try hourlyContainer.decode(String.self, forKey: .temp)
            let hourlyImg = try hourlyContainer.decode(String.self, forKey: .img)
            
            hourlyWeatherArray.append(Hourly(time: hourlyTime, weather: hourlyWeather, temp: hourlyTemp, img: hourlyImg))
        }
        hourly = hourlyWeatherArray
        var indexUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .index)
        var indexArray = [Index]()
        while !indexUnkeyedContainer.isAtEnd {
            let indexContainer = try indexUnkeyedContainer.nestedContainer(keyedBy: IndexKey.self)
            let indexIName = try indexContainer.decode(String.self, forKey: .iname)
            let indexIValue = try indexContainer.decode(String.self, forKey: .ivalue)
            let indexDetail = try indexContainer.decode(String.self, forKey: .detail)
            indexArray.append(Index(iName: indexIName, iValue: indexIValue, detail: indexDetail))
        }
        index = indexArray
    }
}
