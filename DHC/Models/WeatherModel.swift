//
//  WeatherModel.swift
//  DHC
//
//  Created by Lab on 13.05.2024.
//

import Foundation

struct WeatherModel: Codable {
    var lastUpdated: String
    var tempC: Double
    var isDay: Int
    var condition: Condition
    var windKph: Double
    var humidity: Int
    var uv: Double

    struct Condition: Codable {
        var text: String
        var icon: String
    }

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case humidity
        case uv
    }
    
    enum CurrentKeys: String, CodingKey {
        case current
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentKeys.self)
        let current = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .current)
        lastUpdated = try current.decode(String.self, forKey: .lastUpdated)
        tempC = try current.decode(Double.self, forKey: .tempC)
        isDay = try current.decode(Int.self, forKey: .isDay)
        condition = try current.decode(Condition.self, forKey: .condition)
        windKph = try current.decode(Double.self, forKey: .windKph)
        humidity = try current.decode(Int.self, forKey: .humidity)
        uv = try current.decode(Double.self, forKey: .uv)
    }
}
