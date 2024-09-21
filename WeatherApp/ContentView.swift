//
//  ContentView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import SwiftUI

struct ContentView: View {
    
    let apiService = APIService.sharedInstance
    let locationService = LocationService.sharedInstance
    
    @State var lat: Double
    @State var lon: Double


    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                fetchData()
            }, label: {
                Text("Button")
            })
        }
        .padding()
    }
    
    func fetchData() {
        
        locationService.getCoordinates(from: "Jersey City") { (result: Result<Coordinates, CustomError>) in
            switch result {
            case .success(let data):
                lat = data.lat
                lon = data.lon
            case .failure(let failure):
                switch failure {
                case .error(let errorString):
                    print(errorString)
                }
            }
        }
        
        apiService.getData(from: "https://api.openweathermap.org/data/2.5/weather?lat=\($lat)&lon=\($lon)&appid=3f605b4d76506707219e34688a1229b6") { (result: Result<WeatherModel, CustomError>) in
            switch result {
            case .success(let data):
                let dateFormatter = DateFormatter()
                dateFormatter.shortHandDateE_MMM_d()
                print(dateFormatter.string(from: data.dt ?? Date()))
            case .failure(let failure):
                switch failure {
                case .error(let errorString):
                    print(errorString)
                }
            }
        }
    }
}

#Preview {
    ContentView(lat: 30.264264, lon: -97.747502)
}
