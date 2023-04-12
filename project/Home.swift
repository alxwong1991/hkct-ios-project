//
//  Home.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI

struct Home: View {
    
    @State private var searchText = ""
    
    var searchResults: [Forecast] {
        if searchText.isEmpty {
            return Forecast.cities
        } else {
            return Forecast.cities.filter { $0.event.rawValue.contains(searchText)
                || $0.price.contains(searchText)
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                // MARK: Background
                Color.background
                    .ignoresSafeArea()
                
            
                
                // MARK: event card
                ScrollView(showsIndicators: false) {
                    

                    
                    NavigationLink(
                        destination: DetailView(), label: {
                            VStack(spacing: 20) {
                                ForEach(searchResults) { forecast in
                                    
                                    EventCard(forecast: forecast)
                                }
                            }
                            
                        })
                    
                    .safeAreaInset(edge: .top) {
                        EmptyView()
                            .frame(height: 100)
                    }
                }
                .overlay {
                    // MARK: Navigation Bar
                    NavigationBar(searchText: $searchText)
                }
                .navigationBarHidden(true)
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Home()
                .preferredColorScheme(.dark)
        }
    }
}
