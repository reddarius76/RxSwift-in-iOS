//
//  URL+Extension.swift
//  WeatherRX
//
//  Created by Oleg Krikun on 24.05.2021.
//

import Foundation

extension URL {
    static func urlForOpenWeatherAPI(city: String) -> URL? {
         return URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=539a1232e52fd50dd6986a8dd65074fc&units=metric")
    }
}
