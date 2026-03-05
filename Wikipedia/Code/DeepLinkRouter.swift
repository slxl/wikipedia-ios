/*
 Parses wikipedia:// URLs and returns a DeepLinkAppRoute when valid.
 Supports: wikipedia://places?lat=52.37&lon=4.90&name=Amsterdam
 Validation: lat in [-90, 90], lon in [-180, 180]; lat and lon required; name optional.
 */

import Foundation

enum DeepLinkRouter {

    private static let scheme = "wikipedia"
    private static let hostPlaces = "places"
    private static let queryLat = "lat"
    private static let queryLon = "lon"
    private static let queryName = "name"

    private static let validLatRange: ClosedRange<Double> = -90 ... 90
    private static let validLonRange: ClosedRange<Double> = -180 ... 180

    /// Parses a URL and returns a deep link route if it is a valid wikipedia://places URL with valid coordinates.
    /// Returns nil for non-places URLs or invalid/missing parameters (graceful fallback).
    static func parse(_ url: URL) -> DeepLinkAppRoute? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.scheme?.lowercased() == scheme,
              components.host?.lowercased() == hostPlaces else {
            return nil
        }

        guard let queryItems = components.queryItems else { return nil }

        let dict = Dictionary(queryItems.compactMap { item -> (String, String)? in
            guard let value = item.value else { return nil }
            return (item.name, value)
        }, uniquingKeysWith: { _, last in last })

        guard let latString = dict[queryLat],
              let lonString = dict[queryLon],
              let lat = Double(latString),
              let lon = Double(lonString),
              validLatRange.contains(lat),
              validLonRange.contains(lon) else {
            return nil
        }

        let name = dict[queryName]
        return .places(lat: lat, lon: lon, name: name?.isEmpty == true ? nil : name)
    }
}
