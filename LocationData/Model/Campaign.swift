import Foundation

// MARK: - Campaign
struct Campaign: Codable {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let coordinates: [Double]
    let type: String
}

// MARK: - Properties
struct Properties: Codable {
    let title, categoryName: String
    let donationTarget: Int

    enum CodingKeys: String, CodingKey {
        case title
        case categoryName = "category_name"
        case donationTarget = "donation_target"
    }
}
