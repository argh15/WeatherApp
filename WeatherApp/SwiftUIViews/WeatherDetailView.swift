import SwiftUI

struct WeatherDetailView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    
    init(weatherVM: WeatherViewModel) {
        self.weatherVM = weatherVM
    }
    
    var body: some View {
        ZStack {
            if weatherVM.isDayTime {
                DayGradientView()
            } else {
                NightGradientView()
            }
            
            VStack {
                if weatherVM.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = weatherVM.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if weatherVM.weatherModel != nil {
                    ScrollView(showsIndicators: false) {
                        ZStack(alignment: .top) {
                            VStack {
                                topView
                                gridView
                            }
                            HStack {
                                Button(action: {
                                    weatherVM.fetchData(currentLocation: true)
                                }) {
                                    Text("Reset")
                                        .font(.system(size: 17, weight: .medium))
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 8)
                                        .background(Color(.init(white: 1.0, alpha: 0.3)))
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                                .padding(.top, 16)
                                
                                Spacer()
                                
                                Button(action: {
                                    print("Edit tapped")
                                }) {
                                    Text("Edit")
                                        .font(.system(size: 17, weight: .medium))
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 8)
                                        .background(Color(.init(white: 1.0, alpha: 0.3)))
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                                .padding(.top, 16)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            weatherVM.fetchData()
        }
    }
}

extension WeatherDetailView {
    private var topView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(weatherVM.location)
                .font(.headline)
                .padding(.top, 16)
            AsyncImage(url: weatherVM.weatherModel?.weather?.first?.iconURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 48, height: 48)
            }
            Text(weatherVM.currentTemp)
                .font(.largeTitle)
            Text(weatherVM.overview)
                .font(.caption)
            HStack {
                Text(weatherVM.highTemp)
                    .font(.caption)
                Text(weatherVM.lowTemp)
                    .font(.caption)
            }
            if weatherVM.isRainSnowDataPresent {
                Text(weatherVM.rainOrSnowPrecipitation)
                    .font(.title3)
            }
        }
        .foregroundStyle(.white)
        .padding(.bottom, 40)
    }
    
    private var windCardView: some View {
        GroupBox(label: Label("Wind", systemImage: "wind")) {
            HStack {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack {
                        Text(weatherVM.windSpeed)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("MPH")
                                .font(.caption)
                            Text("Wind")
                                .font(.caption)
                        }
                    }
                    Rectangle()
                        .fill(.secondary)
                        .frame(width: 100, height: 1)
                        .padding(.vertical, 8)
                    HStack {
                        Text(weatherVM.gustSpeed)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("MPH")
                                .font(.caption)
                            Text("Gusts")
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .rotationEffect(Angle(degrees: weatherVM.windDirectionDeg))
                        .foregroundColor(.secondary)
                        .padding()
                    
                    
                    VStack(alignment: .leading) {
                        Text(weatherVM.windDirection)
                            .font(.title)
                        Text("Wind")
                            .font(.caption2)
                        Text("Direction")
                            .font(.caption2)
                    }
                }
            }
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
    }
    
    private var feelsLikeCardView: some View {
        GroupBox(label: Label("Feels Like", systemImage: "thermometer")) {
            VStack(alignment: .leading) {
                Spacer()
                Text(weatherVM.feelsLike)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(weatherVM.feelsLikeVerbiage)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
    }
    
    private var humidityCardView: some View {
        GroupBox(label: Label("Humidity", systemImage: "humidity")) {
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                Text(weatherVM.humidity)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(weatherVM.humidityVerbiage)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
    }
    
    private var cloudsCardView: some View {
        GroupBox(label: Label("Clouds", systemImage: "cloud")) {
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                Text(weatherVM.clouds)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(weatherVM.cloudsVerbiage)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
    }
    
    private var visibilityCardView: some View {
        GroupBox(label: Label("Visibility", systemImage: "eye")) {
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                Text(weatherVM.visibility)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(weatherVM.visibilityVerbiage)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
    }
    
    private var sunCycleView: some View {
        GroupBox {
            HStack {
                Label(weatherVM.sunrise, systemImage: "sunrise.fill")
                    .font(.callout)
                
                Spacer()
                
                Label(weatherVM.sunset, systemImage: "sunset.fill")
                    .font(.callout)
            }
        }
    }
    
    
    private var gridView: some View {
        VStack {
            Text(weatherVM.date)
                .font(.caption)
            sunCycleView
            HStack {
                windCardView
            }
            HStack {
                humidityCardView
                feelsLikeCardView
            }
            HStack {
                cloudsCardView
                visibilityCardView
            }
        }
    }
}

struct DayGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.6, blue: 0.9),
                Color(red: 0.9, green: 0.85, blue: 0.5)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct NightGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.0, green: 0.0, blue: 0.1),
                Color(red: 0.1, green: 0.1, blue: 0.4)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    WeatherDetailView(weatherVM: WeatherViewModel(cityName: "Hudson", isDayTime: true))
}
