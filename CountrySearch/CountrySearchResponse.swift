
import Foundation

struct Country: Codable {
    var name: CountryName?
    var capital: [String]?
    var population: Int
    var flags: Flags?
    var capitalInfo: CapitalInfo?
}

struct CountryName: Codable {
    var official: String?
}

struct Flags: Codable {
    let png: String
    let svg: String
}

struct CapitalInfo : Codable {
    var latlng : [Double]?
}
