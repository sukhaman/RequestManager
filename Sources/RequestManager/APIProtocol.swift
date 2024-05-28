//
//  Created by Sukhaman on 5/19/24.
//


import Foundation

public protocol APIProtocol {
    static var baseUrl: URL {get}
}

extension RawRepresentable where RawValue == String, Self: APIProtocol {
   public var url: URL { Self.baseUrl.appendingPathComponent(rawValue)}
}

public extension URL {
    func appending(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: self.absoluteString) else { return self.absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}


