//
//  WelcomeView.swift
//  DHC
//
//  Created by Lab on 1.05.2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showBalanceView = false
    @ObservedObject var viewModel = BalanceViewModel()
    @State private var showAwardView = false
    @ObservedObject var viewAwardModel = AwardViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    WeatherSection(weatherViewModel: weatherViewModel)
                    
                    if let suggestion = weatherViewModel.activitySuggestion, !suggestion.isEmpty {
                        SuggestionSection(suggestion: suggestion)
                    }
                    
                    NavigationLink(destination: AwardView(viewModel: viewAwardModel), isActive: $showAwardView) {
                        AwardsSection(showAwardView: $showAwardView)
                    }
                    
                    NavigationLink(destination: BalanceView(viewModel: viewModel, isPresented: $showBalanceView), isActive: $showBalanceView) {
                        BalanceTestButton(showBalanceView: $showBalanceView)
                    }
                }
                .onAppear {
                    weatherViewModel.fetchWeather()
                }
                .navigationBarTitleDisplayMode(.inline) // Başlığı navigation bar içinde gösterir
                .padding()
            }
        }
    }
}

struct WeatherSection: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let weather = weatherViewModel.weatherModel {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Weather")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        AsyncImage(url: URL(string: "https:\(weather.condition.icon)")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("Temperature: \(weather.tempC, specifier: "%.1f")°C")
                            Text("Condition: \(weather.condition.text)")
                            Text("Wind Speed: \(weather.windKph, specifier: "%.1f") kph")
                        }
                    }
                    .padding()
                }
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            } else if weatherViewModel.isLoading {
                ProgressView()
            } else if let errorMessage = weatherViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
}

struct SuggestionSection: View {
    var suggestion: String
    
    var body: some View {
        Text(suggestion)
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
    }
}

struct AwardsSection: View {
    @Binding var showAwardView: Bool
    
    var body: some View {
        Button(action: {
            showAwardView = true
        }) {
            Text("Awards")
                .foregroundColor(.white)
        }
        .padding()
        .frame(height: 50)
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
    }
}

struct BalanceTestButton: View {
    @Binding var showBalanceView: Bool
    
    var body: some View {
        Button("You can test your balance from there") {
            showBalanceView = true
        }
        .padding()
        .frame(height: 50)
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
