//
//  AqiInfoView.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/28.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct AqiInfoView: View {
    @ObservedObject var weather: WeatherInfo = WeatherInfo()
    struct TextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .foregroundColor(Color.gray)
        }
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                HStack {
                    Text("空气质量")
                        .font(Font.system(size: 40))
                    Spacer()
                }
                HStack {
                    Text("\(self.weather.cityWeather["city"]!) 发布时间:\(self.weather.aqiInfo["timepoint"]!)")
                        .foregroundColor(Color.gray)
                    Spacer()
                }.padding(.bottom)
                HStack {
                    Text("\(self.weather.aqiInfo["aqi"]!)")
                        .font(Font.system(size: 50))
                    Text("\(self.weather.aqiInfo["quality"]!)")
                        .font(Font.system(size: 20))
                    Spacer()
                }
                HStack {
                    Text("\(self.weather.aqiInfo["affect"]!)")
                    Spacer()
                }.padding(.vertical)
                HStack {
                    Text("\(self.weather.aqiInfo["measure"]!)")
                    Spacer()
                }.padding(.vertical)
                HStack {
                    Group {
                        VStack {
                            Text("\(self.weather.aqiInfo["pm25"]!)")
                            Text("PM2.5").modifier(TextStyle())
                        }
                        Spacer()
                        VStack {
                            Text("\(self.weather.aqiInfo["pm10"]!)")
                            Text("PM10").modifier(TextStyle())
                        }
                        Spacer()
                        VStack {
                            Text("\(self.weather.aqiInfo["so2"]!)")
                            Text("SO₂").modifier(TextStyle())
                        }
                    }
                    Spacer()
                    Group {
                        VStack {
                            Text("\(self.weather.aqiInfo["no2"]!)")
                            Text("No₂").modifier(TextStyle())
                        }
                        Spacer()
                        VStack {
                            Text("\(self.weather.aqiInfo["o3"]!)")
                            Text("O₃").modifier(TextStyle())
                        }
                        Spacer()
                        VStack {
                            Text("\(self.weather.aqiInfo["co"]!)")
                            Text("CO").modifier(TextStyle())
                        }
                    }
                    
                }.padding(.vertical)
            }.padding()
            .navigationBarTitle("\(weather.cityWeather["city"]!)", displayMode: .inline)
        }
    }
}


struct AqiInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AqiInfoView()
    }
}
