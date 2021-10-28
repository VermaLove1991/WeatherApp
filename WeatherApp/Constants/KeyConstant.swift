//
//  KeyConstant.swift
//  WeatherApp
//
//  Created by Apple on 10/28/21.
//

import Foundation

struct KeyConstant {
    enum ApplicationKeys: String {
        case openWeatherAPIKey = "e825bcc98636f9393fa92415d9baadb2"
    }
    
    struct API {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/"
        static let productionUrl = ""
        
        static func forcastAPI(_ lat: Double, long: Double, count: Int)-> String {
            return "\(API.baseUrl)onecall?lat=\(lat)&lon=\(long)&&cnt=\(count)&appid=\(ApplicationKeys.openWeatherAPIKey.rawValue)&units=imperial"
        }
    }
}
