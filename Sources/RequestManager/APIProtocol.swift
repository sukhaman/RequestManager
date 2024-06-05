//
//  Created by Sukhaman on 5/19/24.
//


import Foundation

public protocol APIProtocol {
    var baseUrl: URL { get }
    var endpoint: String { get }
}

public class BaseAPI {
    static var baseUrl: URL = {
        guard let urlString = Bundle.main.infoDictionary?["SERVER_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("SERVER_URL not set in Info.plist")
        }
        return url
    }()

    public class func setBaseUrl(_ url: URL) {
        self.baseUrl = url
    }

    public class func setBaseUrl(fromKey key: String) {
        guard let urlString = Bundle.main.infoDictionary?[key] as? String,
              let url = URL(string: urlString) else {
            fatalError("URL for key \(key) not set in Info.plist")
        }
        self.baseUrl = url
    }
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


