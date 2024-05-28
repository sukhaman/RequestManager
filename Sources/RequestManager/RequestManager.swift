

import Foundation
import Combine

public enum NetworkError: Error {
    case statusCode
    case custom(error: Error)
}
public class RequestManager {
    private init() {}
    
    public static func fetchData<T: Decodable>(from request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                return NetworkError.custom(error: error)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let httpResponse = response as? HTTPURLResponse
                    let statusCode = httpResponse?.statusCode
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    throw NSError(domain: "Error", code: statusCode ?? 0, userInfo: json)
                }
                return data
            }
            .flatMap { data -> AnyPublisher<T, Error> in
                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { error in
                        return NetworkError.custom(error: error)
                    }
                    .eraseToAnyPublisher()
                
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public static func fetchNoResponseRequest(from request: URLRequest) -> AnyPublisher<Void,Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ error in
                return error
            })
            .tryMap { data, response in
                guard let httpResponse =  response as? HTTPURLResponse, (200...299)
                    .contains(httpResponse.statusCode) else {
                    let httpResponse = response as? HTTPURLResponse
                    let statusCode = httpResponse?.statusCode
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    throw NSError(domain: "Error", code: statusCode ?? 0, userInfo: json)
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
}

