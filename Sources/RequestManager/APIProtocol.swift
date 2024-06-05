//
//  Created by Sukhaman on 5/19/24.
//


import Foundation

public protocol APIProtocol {
    static var baseUrl: URL {get}
    init(baseUrl: URL)
}

public extension APIProtocol {
    private static var _baseUrl: URL?

    static var baseUrl: URL {
        return _baseUrl ?? URL(string: Bundle.main.infoDictionary?["SERVER_URL"] as! String)!
    }

    init(baseUrl: URL) {
        Self._baseUrl = baseUrl
    }

    init(infoPlistKey: String) {
        guard let urlString = Bundle.main.infoDictionary?[infoPlistKey] as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid URL for key \(infoPlistKey) in Info.plist")
        }
        Self._baseUrl = url
    }
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


