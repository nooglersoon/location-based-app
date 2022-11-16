import UIKit
import MapKit


class VisualizationViewController: UIViewController {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        setupViews()
        if let localData = readLocalFile(forName: "campaign") {
            parse(jsonData: localData)
        }
    }
    
    func setupViews() {
        mapView.delegate = self
        mapView.register(AnnotationView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension VisualizationViewController: MKMapViewDelegate {
    
    func parseGeoJSON() -> [MKOverlay] {
        guard let url = Bundle.main.url(forResource: "campaign", withExtension: "geojson") else {
            fatalError("Unable to get geojson")
        }
        
        var geoJson = [MKGeoJSONObject]()
        
        do {
            let data = try Data(contentsOf: url)
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("Unable to decode geojson")
        }
        
        var overlays = [MKOverlay]()
        
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let point = geo as? MKOverlay {
                        overlays.append(point)
                    }
                }
            }
        }
        
        return overlays
        
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let campaigns = try JSONDecoder().decode(Campaign.self, from: jsonData)
            
            let annotations = campaigns.features.map({Annotation(campaign: $0)})
            
            mapView.addAnnotations(annotations)
            
            //            LondonAttraction.allCases.map({ Annotation(attraction: $0) })
            //
            //            for campaign in campaigns.features {
            //
            //                let annotation = MKPointAnnotation()
            //                annotation.title = campaign.properties.title
            //                annotation.subtitle = "\(campaign.properties.categoryName) - Total Donasi: Rp \(campaign.properties.donationTarget.formatToIDR())"
            //                annotation.coordinate = CLLocationCoordinate2D(latitude: campaign.geometry.coordinates[1] , longitude: campaign.geometry.coordinates[0] )
            //                mapView.addAnnotation(annotation)
            //
            //            }
            
            mapView.centerToLocation(CLLocation(latitude: campaigns.features.first?.geometry.coordinates[1] ?? 0, longitude: campaigns.features.first?.geometry.coordinates[0] ?? 0), regionRadius: 5000)
            
        } catch {
            print("decode error")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "donasi"
        var view: MKAnnotationView
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if let annotation = annotation as? Annotation {
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
            annotationView?.image = UIImage(named: "donasi")
            annotationView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        } else {
            view = MKAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        
        return annotationView
    }
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 100000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
