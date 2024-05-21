//
//  
//
//  Created by Sukhaman on 5/18/24.
//
/*
import Foundation

public class RequestBuilder {
    private init() {}
    
    private static func headers(_ token: String) -> [String:String] {
        
        
        let headers: [String: String] = token.isEmpty ? [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "device-type" : "ios"
        ] : [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "device-type" : "ios"
        ]
        return headers
    }
    
    private static func bodyRequest<T>(modelType: T) throws -> Data? where T : Encodable {
        return try? JSONEncoder().encode(modelType)
    }

    public static func buildGetRequest(url: URL,token:String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers(token)
        request.timeoutInterval = 30
        return request
    }
    
    public static func buildDeleteRequest(url: URL, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers(token)
        request.timeoutInterval = 30
        return request
    }
    
    public static func buildPostRequest<T>(url:URL, anyRequest:T, requestMethod:String,token:String) -> URLRequest where T : Encodable {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.httpBody = try? bodyRequest(modelType: anyRequest)
        request.allHTTPHeaderFields = headers(token)
        request.timeoutInterval = 30
        return request
    }
    
    public static func buildRequest<T>(url:URL, anyRequest:T, requestMethod:String) -> URLRequest where T : Encodable {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.httpBody = try? bodyRequest(modelType: anyRequest)
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "device-type" : "ios"
        ]
        request.timeoutInterval = 30
        return request
    }
    
    public static func buildPostRequestWithoutBody(url:URL, requestMethod:String,token:String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.allHTTPHeaderFields = headers(token)
        request.timeoutInterval = 30
        return request
    }
    fileprivate static func createRequestBodyFromObject(_ dataBody: inout Data, _ boundary: String, _ object: Any) {
        let mirror = Mirror(reflecting: object)
        
        for case let (label?, value) in mirror.children {
            dataBody.append("--\(boundary)\r\n")
            dataBody.append("Content-Disposition: form-data; name=\"\(label)\"\r\n\r\n")
            dataBody.append("\(value)\r\n")
        }
    }
    
    fileprivate static func createRequestBodyFromAnyObject<T:Codable>(_ dataBody: inout Data, _ boundary: String, _ object: T, imageData: Data, backImageData: Data?,documentType: String, backDocumentType: String?, mimeType: String, name: String) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let codableObject = object
        do {
            let encodedData = try encoder.encode(codableObject)
            let dictionary = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any] ?? [:]
            
            for (key, value) in dictionary {
                dataBody.append("--\(boundary)\r\n")
                dataBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                if let valueString = value as? String {
                    dataBody.append("\(valueString)\r\n")
                } else if let intValue = value as? Int {
                    dataBody.append("\(intValue)\r\n")
                } else if let boolValue = value as? Bool {
                    dataBody.append("\(boolValue ? "true" : "false")\r\n")
                }
            }
            dataBody.append("--\(boundary)\r\n")
            dataBody.append("Content-Disposition: form-data; name=\"\(documentType)\"; filename=\"\(name)\"\r\n")
            dataBody.append("Content-Type: \(mimeType)\r\n\r\n")
            dataBody.append(imageData)
            dataBody.append("--\(boundary)--\r\n")
            if let backImageData, let backDocumentType {
                let miliiscond = Int64(Date().timeIntervalSince1970 * 1000)
                
                let backFileName = "\(backDocumentType)\(miliiscond).png"
                
                dataBody.append("--\(boundary)\r\n")
                dataBody.append("Content-Disposition: form-data; name=\"\(backDocumentType)\"; filename=\"\(backFileName)\"\r\n")
                dataBody.append("Content-Type: \(mimeType)\r\n\r\n")
                dataBody.append(backImageData)
                dataBody.append("--\(boundary)--\r\n")
            }
            
        } catch {
            print("Error encoding/decoding object: \(error)")
        }
        
    }
    
    public  static func uploadRequest<T: Codable>(url:URL, requestMethod:String, isDocument: Bool = true,document:T,documentData: Data, backImageData: Data? = nil,token:String,documentType: String = "signature", backDocumentType: String? = nil, endExtension: String = ".png", mimeType: String = "image/png",fileName: String = "") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.timeoutInterval = 60
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var dataBody = Data()
        let miliiscond = Int64(Date().timeIntervalSince1970 * 1000)
        
        var name = "\(documentType)\(miliiscond)\(endExtension)"
        if !fileName.isEmpty {
            name =  "\(fileName)\(miliiscond)\(endExtension)"
        }
        
        
        createRequestBodyFromAnyObject(&dataBody, boundary, document, imageData: documentData, backImageData: backImageData, documentType: documentType,backDocumentType: backDocumentType,mimeType: mimeType,name: name)
        request.httpBody = dataBody as Data
        return request
    }
    
    public static func scanUploadRequest(url:URL,token: String, requestMethod:String,frontImageData: Data, backImageData: Data, endExtension: String = ".png", mimeType: String = "image/png") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.timeoutInterval = 60
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var dataBody = Data()
        let miliiscond = Int64(Date().timeIntervalSince1970 * 1000)
        
        let name = "front\(miliiscond)\(endExtension)"
        
        dataBody.append("--\(boundary)\r\n")
        dataBody.append("Content-Disposition: form-data; name=\"front\"; filename=\"\(name)\"\r\n")
        dataBody.append("Content-Type: \(mimeType)\r\n\r\n")
        dataBody.append(frontImageData)
        dataBody.append("--\(boundary)--\r\n")
        
        
        let backFileName = "back\(miliiscond)\(endExtension)"
        
        dataBody.append("--\(boundary)\r\n")
        dataBody.append("Content-Disposition: form-data; name=\"back\"; filename=\"\(backFileName)\"\r\n")
        dataBody.append("Content-Type: \(mimeType)\r\n\r\n")
        dataBody.append(backImageData)
        dataBody.append("--\(boundary)--\r\n")
        
        request.httpBody = dataBody as Data
        return request
    }
    
}

extension URLRequest {
    
    public func curlCommand() -> String {
        guard let url = self.url else {return ""}
        var command = "curl -X \(self.httpMethod ?? "POST") '\(url.absoluteString)' "
        if let headers = self.allHTTPHeaderFields {
            for (key,value) in headers{
                command += "- H '\(key): \(value)'"
            }
        }
        if let httpBody = self.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            command += " -d '\(bodyString)'"
        }
        return command
    }
}

public extension Data {
    
    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}

*/
