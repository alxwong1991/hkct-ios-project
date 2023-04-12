//
//  EventCard.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI

struct EventCard: View {
    var forecast: Forecast
    
    var body: some View {

            ZStack(alignment: .bottom) {
                // MARK: Trapezoid
                Trapezoid()
                    .fill(Color.eventCardBackground)
                    .frame(width: 342, height: 174)
                
                // MARK: Content
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        // MARK: Forecast eventdata
                        HStack{
                            Text("\(forecast.eventdata)")
                                .font(.system(size: 64))
                            Text("May")
                                .font(.system(size: 15))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            // MARK: Forecast Temperature Range
                            Text("Time \(forecast.start) - \(forecast.end)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            
                            // MARK: Forecast Location
                            Text(forecast.event.rawValue)
                                .font(.body)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        // MARK: Forecast Large Icon
                        Image("\(forecast.icon) large")
                            .padding(.trailing, 4)
                        
                        // MARK: event
                        Text("$ \(forecast.price)")
                            .font(.footnote)
                            .padding(.trailing, 24)
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom, 20)
                .padding(.leading, 20)
            }
            .frame(width: 342, height: 184, alignment: .bottom)
        }
    }

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(forecast: Forecast.cities[0])
            .preferredColorScheme(.dark)
    }
}

