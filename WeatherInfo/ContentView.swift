//
//  ContentView.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/8.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weather: WeatherInfo = WeatherInfo()
    @State private var showDailySheet = false
    @State private var showAqinInfoSheet = false
    let bgGrav = Color(red: 212.0 / 255.0, green: 207.0 / 255.0, blue: 206.0 / 255.0)
    let bgBlue = Color(red: 140.0 / 255.0, green: 170.0 / 255.0, blue: 226.0 / 255.0)
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                    VStack{
                        HStack(){
                            Text("\(weather.cityWeather["temp"]!)")
                                .font(Font.system(size: 100))
                            Text("℃")
                        }
                        Text("\(weather.cityWeather["weather"]!) ")
                            .font(Font.system(size: 20))
                        HStack {
                            Image("leaf")
                            Text("空气\(weather.aqiInfo["quality"]!)\(weather.aqiInfo["aqi"]!)")
                        }
                        .gesture(TapGesture().onEnded {
                            self.showAqinInfoSheet.toggle()
                        })
                        .sheet(isPresented: $showAqinInfoSheet) {AqiInfoView(weather: self.weather)}
                        .padding(.horizontal, 7)
                        .background(bgGrav)
                        .cornerRadius(30)
                    }.frame(height: 330)
                .padding(100)
                HStack() {
                    Image("\(weather.today.dayImg)")
                    if weather.today.dayWeather == weather.today.nightWeather {
                        Text("今天·\(weather.today.dayWeather)")
                    } else {
                        Text("今天·\(weather.today.dayWeather)转\(weather.today.nightWeather)")
                    }
                    Spacer()
                    Text("\(weather.today.tempHigh)℃  / \(weather.today.tempLow)℃")
                }
                .padding()
                HStack() {
                    Image("\(weather.tomorrow.dayImg)")
                    if weather.tomorrow.dayWeather == weather.tomorrow.nightWeather {
                        Text("明天·\(weather.tomorrow.dayWeather)")
                    } else {
                        Text("明天·\(weather.tomorrow.dayWeather)转\(weather.tomorrow.nightWeather)")
                    }
                    Spacer()
                    Text("\(weather.tomorrow.tempHigh)℃  / \(weather.tomorrow.tempLow)℃")
                }
                .padding()
                HStack() {
                    Image("\(weather.afterTomorrow.dayImg)")
                    if weather.afterTomorrow.dayWeather == weather.afterTomorrow.nightWeather {
                        Text("后天·\(weather.afterTomorrow.dayWeather)")
                    } else {
                        Text("后天·\(weather.afterTomorrow.dayWeather)转\(weather.afterTomorrow.nightWeather)")
                    }
                    Spacer()
                    Text("\(weather.afterTomorrow.tempHigh)℃  / \(weather.afterTomorrow.tempLow)℃")
                }
                .padding()
                HStack {
                    Button(action: {
                        self.showDailySheet.toggle()
                    }) {
                        Spacer()
                        Text("查看最近七日天气")
                        Spacer()
                    }
                    .padding(15)
                    .foregroundColor(.black)
                    .background(bgGrav)
                    .cornerRadius(50)
                    .sheet(isPresented: $showDailySheet) {
                        DailyWeatherView(weather: self.weather)
                    }
                }.padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(weather.hourly, id: \.time) { item in
                            VStack {
                                Text("\(item.time)")
                                    .foregroundColor(Color.gray)
                                Text("\(item.temp)℃")
                                Image("\(item.img)")
                            }.padding(5)
                        }
                    }
                }.padding()
                Text("———————————————————————")
                    .foregroundColor(Color.gray)
                HStack {
                    Image("sunrise")
                    Text("日出")
                    Text("\(weather.today.sunRise)")
                        .padding(.trailing, 5)
                    Image("sunset")
                    Text("日落")
                    Text("\(weather.today.sunSet)")
                    Spacer()
                }.padding()
                HStack {
                    VStack {
                        Text("\(weather.cityWeather["windpower"]!)")
                        Text("\(weather.cityWeather["winddirect"]!)")
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    VStack {
                        Text("\(weather.cityWeather["windspeed"]!)m/s")
                        Text("风速")
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    VStack {
                        Text("\(weather.cityWeather["humidity"]!)")
                        Text("湿度")
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                    VStack {
                        Text("\(weather.cityWeather["pressure"]!)hPa")
                        Text("气压")
                            .foregroundColor(Color.gray)
                    }
                }.padding()
                HStack {
                    GeometryReader { geometry in
                        self.generateContent(in: geometry)
                    }
                    .frame(height: 220)
                        .background(bgBlue)
                    .cornerRadius(20)
                }.padding()
            }
            .onAppear(perform: {
                self.loadData(cityId: self.weather.cityid)
            })
                .navigationBarTitle("\(weather.cityWeather["city"]!)", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink("切换", destination: ProvinceListView(weather: self.weather)))
        }
    }
    func loadData(cityId: Int) {
        let url = URL(string: "https://jisutqybmf.market.alicloudapi.com/weather/query?cityid=\(cityId)")!
        var request = URLRequest(url: url)
        request.addValue("APPCODE testtest", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let decodeResponse = try? JSONDecoder().decode(WeatherInfo.self, from: data) {
                    DispatchQueue.main.sync {
                        self.weather.cityWeather = decodeResponse.cityWeather
                        self.weather.daily = decodeResponse.daily
                        self.weather.today = decodeResponse.today
                        self.weather.tomorrow = decodeResponse.tomorrow
                        self.weather.afterTomorrow = decodeResponse.afterTomorrow
                        self.weather.hourly = decodeResponse.hourly
                        self.weather.aqiInfo = decodeResponse.aqiInfo
                        self.weather.index = decodeResponse.index
                    }
                    return
                }
            }
        }.resume()
    }
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(self.weather.index, id: \.iName) { platform in
                VStack {
                    Text("\(platform.iName)")
                    Text("\(platform.iValue)")
                }
                .frame(width: 150, height: 40)
                    .padding()
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform.iName == "穿衣指数" {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform.iName == "穿衣指数" {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
