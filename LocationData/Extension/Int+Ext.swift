import Foundation

extension Int {
    func formatToIDR() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
