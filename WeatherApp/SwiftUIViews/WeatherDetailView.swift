import SwiftUI

struct WeatherDetailView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    @State private var showAlert = false
    @State private var searchText = ""
    @State private var keyboardHeight: CGFloat = 0
    
    init(weatherVM: WeatherViewModel) {
        self.weatherVM = weatherVM
    }
    
    var body: some View {
        ZStack {
            if Helpers.isNight {
                NightGradientView()
            } else {
                DayGradientView()
            }
            
            VStack {
                if weatherVM.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .tint(.white)
                        .foregroundStyle(.white)
                } else if let errorMessage = weatherVM.errorMessage {
                    ErrorView(
                            errorImage: Image(systemName: "exclamationmark.triangle.fill"),
                            errorTitle: "Weather Fetch Error",
                            errorDescription: errorMessage, onRetry: {
                                weatherVM.fetchData(onRetry: true)
                            }
                    )
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
                                    showAlert.toggle()
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
        .overlay(
            GeometryReader { geometry in
                if showAlert {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            Text("Search City")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            
                            SearchBarView(searchText: $searchText) {
                                weatherVM.cityName = searchText
                                weatherVM.fetchData(currentLocation: false)
                                showAlert.toggle()
                                searchText = ""
                            }
                            
                            HStack {
                                Button(action: {
                                    showAlert.toggle()
                                    searchText = ""
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                
                                Button(action: {
                                    weatherVM.cityName = searchText
                                    weatherVM.fetchData(currentLocation: false)
                                    showAlert.toggle()
                                    searchText = ""
                                }) {
                                    Text("Search")
                                        .foregroundColor(.blue)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                .disabled(searchText.isEmpty) 
                                .padding(.trailing, 8)
                            }
                            .font(.headline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .offset(y: -keyboardHeight / 2)
                        .animation(.easeInOut, value: showAlert)
                    }
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                keyboardHeight = keyboardFrame.height
                            }
                        }
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                            keyboardHeight = 0
                        }
                    }
                    .onDisappear {
                        // Stop observing keyboard changes
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                    }
                }
            }
        )
        .onAppear {
            if weatherVM.cityName == nil {
                weatherVM.fetchData(currentLocation: true)
            } else {
                weatherVM.fetchData()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension WeatherDetailView {
    private var topView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(weatherVM.location)
                .font(.headline)
                .padding(.top, 16)
            CacheAsyncImage(url: weatherVM.weatherModel?.weather?.first?.iconURL) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipped()
                } else if case .empty = phase {
                    ProgressView()
                        .frame(width: 48, height: 48)
                }
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
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
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
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
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
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
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
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
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
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
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
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.bannerView)
    }
    
    
    private var gridView: some View {
        VStack {
            Text(weatherVM.date)
                .font(.caption)
                .foregroundStyle(.white)
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

struct CardViewStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
            configuration.content
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
        .padding()
        .background(Color(.init(white: 1.0, alpha: 0.2)), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BannerViewStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
            configuration.content
        }
        .padding()
        .background(Color(.init(white: 1.0, alpha: 0.2)), in: RoundedRectangle(cornerRadius: 12))
    }
}


extension GroupBoxStyle where Self == CardViewStyle {
    static var cardView: CardViewStyle { .init() }
}

extension GroupBoxStyle where Self == BannerViewStyle {
    static var bannerView: BannerViewStyle { .init() }
}

#Preview {
    WeatherDetailView(weatherVM: WeatherViewModel(cityName: "Hudson"))
}
