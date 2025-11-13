import SwiftUI
import MapKit
import CoreLocation
import Combine

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var locationName: String
    @Binding var latitude: Double?
    @Binding var longitude: Double?

    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedLocation: MKMapItem?
    @State private var cameraPosition: MapCameraPosition
    @StateObject private var locationManager = LocationManager()

    init(locationName: Binding<String>, latitude: Binding<Double?>, longitude: Binding<Double?>) {
        self._locationName = locationName
        self._latitude = latitude
        self._longitude = longitude

        // Initialize camera position
        if let lat = latitude.wrappedValue, let lon = longitude.wrappedValue {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
        } else {
            _cameraPosition = State(initialValue: .userLocation(fallback: .automatic))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Map(position: $cameraPosition) {
                    if let selectedLocation = selectedLocation {
                        Marker(selectedLocation.name ?? "Selected Location", coordinate: selectedLocation.location.coordinate)
                            .tint(.red)
                    }
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .frame(height: 300)
                .onAppear {
                    locationManager.requestLocation()
                }

                List {
                    Section {
                        ForEach(searchResults, id: \.self) { item in
                            Button {
                                selectLocation(item)
                            } label: {
                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search for location")
                .onChange(of: searchText) { _, newValue in
                    searchLocation(query: newValue)
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let selectedLocation = selectedLocation {
                            locationName = selectedLocation.name ?? ""
                            latitude = selectedLocation.location.coordinate.latitude
                            longitude = selectedLocation.location.coordinate.longitude
                        }
                        dismiss()
                    }
                    .disabled(selectedLocation == nil)
                }
            }
        }
    }

    private func searchLocation(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                searchResults = []
                return
            }
            searchResults = response.mapItems
        }
    }

    private func selectLocation(_ item: MKMapItem) {
        selectedLocation = item
        cameraPosition = .region(MKCoordinateRegion(
            center: item.location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        let status = manager.authorizationStatus
        authorizationStatus = status

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            // Location access denied
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}
