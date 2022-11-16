import UIKit
import CoreLocation
import MapKit

class GeocodingViewController: UIViewController {
    
    private let reverseGeocodingStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reverse Geocoding"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
        
    }()
    private let suggestionLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 12))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Did you mean ..."
        label.textColor = .systemGray4
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
        
    }()
    private let suggestionButton: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Use Suggestion", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private var addressTextField: MyUITextField = {
        let textField: UITextField = MyUITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 4
        textField.font = UIFont.systemFont(ofSize: 12)
        return textField as! MyUITextField
    }()
    private let getCoorinateButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitle("Get Coordinate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    private let geocodingStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    private let bottomLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Geocoding"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
        
    }()
    private var latTextField: MyUITextField =  {
        let textField: UITextField = MyUITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Latitude"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 4
        textField.font = UIFont.systemFont(ofSize: 12)
        return textField as! MyUITextField
    }()
    private var longTextField: MyUITextField =  {
        let textField: UITextField = MyUITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Longitude"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 4
        textField.font = UIFont.systemFont(ofSize: 12)
        return textField as! MyUITextField
    }()
    private let getAddressButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitle("Get Address", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let locationManager = CLLocationManager()
    private var currentRegion: MKCoordinateRegion?
    private var currentPlace: CLPlacemark?
    private let completer = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureTextFields()
        completer.delegate = self
        setupButtons()
        attemptLocationAccess()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        addBottomStackView()
        addTopStackView()
    }
    
    private func addTopStackView() {
        view.addSubview(reverseGeocodingStackView)
        reverseGeocodingStackView.addArrangedSubview(titleLabel)
        reverseGeocodingStackView.addArrangedSubview(addressTextField)
        reverseGeocodingStackView.addArrangedSubview(suggestionLabel)
        reverseGeocodingStackView.addArrangedSubview(suggestionButton)
        reverseGeocodingStackView.addArrangedSubview(getCoorinateButton)
        NSLayoutConstraint.activate([
            reverseGeocodingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reverseGeocodingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reverseGeocodingStackView.topAnchor.constraint(equalTo: geocodingStackView.bottomAnchor, constant: 120),
            addressTextField.leadingAnchor.constraint(equalTo: reverseGeocodingStackView.leadingAnchor, constant: 32),
            addressTextField.trailingAnchor.constraint(equalTo: reverseGeocodingStackView.trailingAnchor, constant: -32),
            suggestionLabel.leadingAnchor.constraint(equalTo: reverseGeocodingStackView.leadingAnchor, constant: 16),
            suggestionLabel.trailingAnchor.constraint(equalTo: reverseGeocodingStackView.trailingAnchor, constant: -16),
            getCoorinateButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func addBottomStackView() {
        view.addSubview(geocodingStackView)
        geocodingStackView.addArrangedSubview(bottomLabel)
        geocodingStackView.addArrangedSubview(latTextField)
        geocodingStackView.addArrangedSubview(longTextField)
        geocodingStackView.addArrangedSubview(getAddressButton)
        NSLayoutConstraint.activate([
            geocodingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            geocodingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            geocodingStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            longTextField.widthAnchor.constraint(equalToConstant: 120),
            latTextField.widthAnchor.constraint(equalToConstant: 120),
            getAddressButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureTextFields() {
        addressTextField.delegate = self
        latTextField.delegate = self
        longTextField.delegate = self
        
        addressTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        
        guard let query = field.contents else {
            if completer.isSearching {
                completer.cancel()
            }
            return
        }
        
        completer.queryFragment = query
    }
    
    func setupButtons() {
        reverseGeocodingStackView.isUserInteractionEnabled = true
        
        getCoorinateButton.isUserInteractionEnabled = true
        getCoorinateButton.addTarget(self, action: #selector(getCoordinate), for: .touchUpInside)
        
        suggestionButton.isUserInteractionEnabled = true
        suggestionButton.addTarget(self, action: #selector(updateAddressTextField), for: .touchUpInside)
        
        getAddressButton.isUserInteractionEnabled = true
        getAddressButton.addTarget(self, action: #selector(getAddress), for: .touchUpInside)
    }
    
    @objc func updateAddressTextField() {
        addressTextField.text = suggestionLabel.text ?? ""
    }
    
    @objc func getCoordinate() {
        geocoder(from: addressTextField.text ?? "")
    }
    
    @objc func getAddress() {
        guard let lat = latTextField.text, let long = longTextField.text else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(long) ?? 0)
        reverseGeocoder(from: coordinate)
    }
    
    func geocoder(from address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: Locale.current) { [weak self] placemarks, error in
            guard let self else { return }
            guard error == nil else { return }
            guard let placemark = placemarks?.first else  { return }
            self.latTextField.text = String(placemark.location?.coordinate.latitude ?? 0)
            self.longTextField.text = String(placemark.location?.coordinate.longitude ?? 0)
        }
    }
    
    func reverseGeocoder(from coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.current) { [weak self] placemarks, error in
            guard let self else { return }
            guard error == nil else { return }
            guard let placemark = placemarks?.first else  { return }
            self.suggestionLabel.text = "\(placemark.name ?? "Unrecognized Place")\n\(placemark.thoroughfare ?? "Unrecognized Street")"
        }
    }
    
}

extension GeocodingViewController: UITextFieldDelegate {
    
    private func attemptLocationAccess() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if completer.isSearching {
            completer.cancel()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension GeocodingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        
        let commonDelta: CLLocationDegrees = 25 / 111 // 1/111 = 1 latitude km
        let span = MKCoordinateSpan(latitudeDelta: commonDelta, longitudeDelta: commonDelta)
        let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)
        
        currentRegion = region
        completer.region = region
        
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            guard let firstPlace = places?.first, self.addressTextField.contents == nil else {
                return
            }
            
            self.currentPlace = firstPlace
            self.addressTextField.text = firstPlace.abbreviation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error requesting location: \(error.localizedDescription)")
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension GeocodingViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let firstResult = completer.results.first else {
            return
        }
        suggestionLabel.text = "\(firstResult.title)\n\(firstResult.subtitle)"
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error suggesting a location: \(error.localizedDescription)")
    }
}

class MyUITextField: UITextField {
    // Whatever you like
    let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16);
    // Paddging for place holder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    // Padding for text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    // Padding for text in editting mode
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField {
    var contents: String? {
        guard
            let text = text?.trimmingCharacters(in: .whitespaces),
            !text.isEmpty
        else {
            return nil
        }
        
        return text
    }
}

extension CLPlacemark {
    var abbreviation: String {
        if let name = self.name {
            return name
        }
        
        if let interestingPlace = areasOfInterest?.first {
            return interestingPlace
        }
        
        return [subThoroughfare, thoroughfare].compactMap { $0 }.joined(separator: " ")
    }
}
