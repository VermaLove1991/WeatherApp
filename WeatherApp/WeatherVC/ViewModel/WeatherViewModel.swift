//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Apple on 10/28/21.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    
    var weatherModel: WeatherModel?
    var hourlyArray = [Current]()
    var selectedIndex = 0

    func fetchForcastAPI(completionHandler: @escaping () -> Void, failure: @escaping (String) -> Void) {
        let locationManager = CLLocationManager()
        let lat: Double = locationManager.location?.coordinate.latitude ?? 56.1304
        let long: Double = locationManager.location?.coordinate.longitude ?? 106.3468
        let forcastURL = KeyConstant.API.forcastAPI(lat, long: long, count: 5)

        var request = URLRequest(url: URL(string: forcastURL)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { jsonData, response, error -> Void in
            
            do {
                if let resultData = jsonData {
                    let weatherModel = try! JSONDecoder().decode(WeatherModel.self, from: resultData)
                    self.weatherModel = weatherModel
                    print(self.weatherModel)
                    completionHandler()
                } else {
                    failure("Data Not Received")
                }
            } catch {
                print("error")
                failure("Data Not Received")
            }
        })
        task.resume()
    }
    
    func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        var count = self.weatherModel?.daily?.count ?? 0
        count = (count > 5) ? 5 : count

        for i in 0..<count {
            if let model = self.weatherModel?.daily?[i] {
                let date = Date(timeIntervalSince1970: TimeInterval(model.dt))
                let calenderDate = Calendar.current.dateComponents([.day], from: date)
                result.append(PointEntry.init(value: Int(model.temp.day), label: calenderDate.day!.description))
            }
        }
        return result
    }
    
    func getHourlyData()-> [Current] {
        let dailyTimeStamp = self.weatherModel?.daily?[selectedIndex].dt
        let date = Date(timeIntervalSince1970: TimeInterval(dailyTimeStamp ?? 0))
        let dailycalenderDate = Calendar.current.dateComponents([.day, .month], from: date)

        let resultArray = self.weatherModel?.hourly.filter({ model in
            let hourlyDate = Date(timeIntervalSince1970: TimeInterval(model.dt))
            let hourlycalenderDate = Calendar.current.dateComponents([.day, .month], from: hourlyDate)
            
            return (hourlycalenderDate.day == dailycalenderDate.day) && (hourlycalenderDate.hour == dailycalenderDate.hour)
        })
        return resultArray ?? []
    }
    
    func getDate(_ timestamp: Int)-> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calenderDate = Calendar.current.dateComponents([.weekday], from: date)
        
        switch calenderDate.weekday {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Nada"
        }
    }
    
    func getHourlyDate(_ timestamp: Int)-> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calenderDate = Calendar.current.dateComponents([.hour], from: date)
        return calenderDate.hour ?? 0
    }
}
