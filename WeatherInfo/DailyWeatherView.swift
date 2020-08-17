//
//  DailyWeatherView.swift
//  WeatherInfo
//
//  Created by snow on 2020/5/25.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct DailyWeatherView: View {
    @ObservedObject var weather: WeatherInfo = WeatherInfo()
    
    var body: some View {
        NavigationView{
            
            VStack {
                HStack {
                    Text("七天天气趋势")
                        .font(Font.system(size: 40))
                    Spacer()
                }
                .padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.weather.daily, id: \.date) {item in
                            VStack {
                                Text("\(item.week)")
                                Image("\(item.dayImg)")
                                Text("\(item.dayWeather)")
                                Text("\(item.tempHigh)℃")
                                    .padding(.bottom, 100)
                                Text("\(item.tempLow)℃")
                                Image("\(item.nightImg)")
                                Text("\(item.nightWeather)")
                                    .padding(.bottom, 20)
                                Text("\(item.windDirect)")
                                Text("\(item.windPower)")
                            }.frame(width:100, height: 400)
                            
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("\(weather.cityWeather["city"]!)", displayMode: .inline)
        }
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView()
    }
}
