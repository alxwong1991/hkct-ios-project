//
//  ForecastModel.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import Foundation



enum Event: String {
    case event1 = "Red Lights"
    case event2 = "The Age Of Love"
    case event3 = "DANCE4LIFE"
    case event4 = "Exploration Of Space"
    case event5 = "Reach Out"
    case event6 = "LSR/CITY"
    case event7 = "Inner Peace"
}

struct Forecast: Identifiable {
    var id = UUID()
    var date: Date
    var event: Event
    var probability: Int
    var eventdata: Int
    var start: String
    var end: String
    var price: String
    
    var icon: String {
        switch event {
        case .event1:
            return "1"
        case .event2:
            return "2"
        case .event3:
            return "3"
        case .event4:
            return "4"
        case .event5:
            return "5"
        case .event6:
            return "6"
        case .event7:
            return "7"
        }
    }
}

extension Forecast {
    
    static let cities: [Forecast] = [
        Forecast(date: .now, event: .event1, probability: 0, eventdata: 18, start: "1200", end: "1530", price: "Free"),
        Forecast(date: .now, event: .event2, probability: 0, eventdata: 23, start: "1845", end: "2100", price: "320"),
        Forecast(date: .now, event: .event3, probability: 0, eventdata: 23, start: "1200", end: "2100", price: "Free"),
        Forecast(date: .now, event: .event4, probability: 0, eventdata: 26, start: "1800", end: "2000", price: "200")
    ]
}
