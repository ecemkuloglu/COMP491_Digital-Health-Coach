//
//  WeatherManager.swift
//  DHC
//
//  Created by Lab on 13.05.2024.
//

import Foundation

class WeatherManager {
    func fetchWeather(completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=4c457d8072c441c09ed185211241305&q=Istanbul&aqi=no") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
