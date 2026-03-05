/*
 Deep link route for the Wikipedia app.
 Used when parsing wikipedia:// URL scheme (e.g. places?lat=&lon=&name=).
 */

import Foundation

/// Represents a parsed deep link destination. Only places is supported for now.
enum DeepLinkAppRoute: Equatable {
    case places(lat: Double, lon: Double, name: String?)
}
