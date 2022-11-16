import UIKit
import MapKit

class AnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let value = newValue as? Annotation else { return }
            canShowCallout = true
            detailCalloutAccessoryView = Callout(annotation: value)
        }
    }
}

class Annotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let name: String
    let category: String
    let totalDonation: Int
    
    init(campaign: Feature) {
        coordinate = CLLocationCoordinate2D(latitude: campaign.geometry.coordinates[1], longitude: campaign.geometry.coordinates[0])
        name = campaign.properties.title
        category = campaign.properties.categoryName
        totalDonation = campaign.properties.donationTarget
    }
}

class Callout: UIView {
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let totalDonasiLabel = UILabel(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let annotation: Annotation
    
    init(annotation: Annotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupTitle()
        setupSubtitle()
        setupDonasiLabel()
        setupImageView()
    }
    
    private func setupTitle() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = annotation.name
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupSubtitle() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.text = annotation.category
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupDonasiLabel() {
        totalDonasiLabel.font = UIFont.systemFont(ofSize: 10)
        totalDonasiLabel.textColor = .gray
        totalDonasiLabel.text = "Total Donasi: Rp \(annotation.totalDonation.formatToIDR())"
        addSubview(totalDonasiLabel)
        totalDonasiLabel.translatesAutoresizingMaskIntoConstraints = false
        totalDonasiLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4).isActive = true
        totalDonasiLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        totalDonasiLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupImageView() {
        imageView.image = UIImage(named: "warga") ?? UIImage(systemName: "house.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: totalDonasiLabel.bottomAnchor, constant: 8).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
    }
}
