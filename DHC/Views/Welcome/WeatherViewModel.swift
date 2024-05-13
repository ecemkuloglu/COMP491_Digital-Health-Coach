//
//  WeatherViewModel.swift
//  DHC
//
//  Created by Lab on 13.05.2024.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherModel: WeatherModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var activitySuggestion: String = ""

    private var weatherManager = WeatherManager()

    func fetchWeather() {
        isLoading = true
        weatherManager.fetchWeather { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let weatherData):
                    self?.weatherModel = weatherData
                    self?.activitySuggestion = self?.suggestActivity(basedOn: weatherData) ?? ""
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.weatherModel = nil
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func suggestActivity(basedOn weather: WeatherModel) -> String {
        let temp = weather.tempC
        let condition = weather.condition.text.lowercased()

        switch condition {
        case "rain", "thunderstorm", "drizzle":
            return "It's raining, why not enjoy a movie marathon or dive into a new book at home?"
        case "clear", "sunny":
            if temp > 30 {
                return "It's really hot outside, a perfect day to hit the beach or take a dip in the pool!"
            } else if temp > 25 {
                return "It's warm enough, how about a swimming workout today?"
            } else {
                return "It's a beautiful day, how about a walk or a bike ride in the park?"
            }
        case "cloudy", "overcast":
            return "It's cloudy, a great opportunity for outdoor photography or an outdoor yoga session."
        case "fog":
            return "It's foggy, a mysterious setting for a brisk walk or photography in the early morning."
        case "snow":
            return "It's snowing, perfect for building a snowman or going for a snowshoe hike."
        case "sleet":
            return "Sleet can be tricky, how about catching up with friends over coffee indoors?"
        default:
            if temp < 0 {
                return "It's freezing! Stay warm, perhaps a day for indoor activities like cooking or crafts."
            } else if temp < 5 {
                return "It's quite cold, reading a book with a hot drink might be a good choice."
            } else if temp > 20 {
                return "The weather is mild, it’s a great day for gardening or outdoor sports like tennis."
            } else if temp < 10 {
                return "It's a bit chilly, perfect weather for a brisk walk or a jog to warm up."
            }else if temp < 15 {
                return "The weather is cool, ideal for hiking or cycling through nature."
            }else {
                return "It's pleasantly cool, a great day for a picnic or playing frisbee in the park."
            }
            
        }
    }
}
