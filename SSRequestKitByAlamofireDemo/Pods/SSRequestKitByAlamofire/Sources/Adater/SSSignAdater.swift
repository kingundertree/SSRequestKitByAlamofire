//
//  SSSignAdater.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import Alamofire

public class SSSignAdater: RequestAdapter {
    
    public init() {
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard
            let method = urlRequest.httpMethod,
            let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return urlRequest
        }
        
        let queryAndBodyString: String = self.queryWithBodyString(urlRequest)
        let path = components.percentEncodedPath
        let token = urlRequest.value(forHTTPHeaderField: "Authorization") ?? ""
        let secret = SSRequestKitConfig.defaultConfig.secret ?? ""
        let needSignString = "\(method)\(path)?\(queryAndBodyString)\(secret)\(token)"
        let sign = needSignString.MD5String().lowercased()
        guard sign.isEmpty == false else {
            return urlRequest
        }
        if let c = components.appending(query: URLQueryItem(name: "sign", value: sign)) {
            var request = urlRequest
            request.url = c.url
            return request
        } else {
            return urlRequest
        }
    }
    
    private func queryWithBodyString(_ urlRequest: URLRequest) -> String {
        guard
            let method = urlRequest.httpMethod,
            let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return ""
        }

        // query
        var reval = self.unencodedItems(fromPercentEncodedQuery: components.percentEncodedQuery ?? "")
        // body
        switch method {
        case "POST", "PUT":
            let contentEncoding = urlRequest.value(forHTTPHeaderField: "Content-Encoding") ?? ""
            guard !contentEncoding.contains("gzip") else {
                break
            }
            guard let contentType = urlRequest.value(forHTTPHeaderField: "Content-Type") else {
                break
            }
            if contentType.contains("application/x-www-form-urlencoded") {
                if let data = urlRequest.httpBody,
                    let string = String(data: data, encoding: .utf8) {
                    reval.append(contentsOf: self.unencodedItems(fromPercentEncodedQuery: string))
                }
            } else if contentType.contains("application/json") {
                if let data = urlRequest.httpBody,
                    let string = String(data: data, encoding: .utf8) {
                    reval.append("jsonBody=\(string)")
                }
            }
        default:
            break
        }
        return reval.sorted().joined(separator: "&")
    }
    
    private func unencodedItems(fromPercentEncodedQuery query: String) -> [String] {
        return query.split(separator: "&").compactMap({ $0.removingPercentEncoding })
    }
    
//    private func unencodedItemsAndRemoveEmpty(fromPercentEncodedQuery query: String) -> [String] {
//        return query.split(separator: "&").compactMap({ subString -> String? in
//            let keyValue = subString.split(separator: "=")
//            guard keyValue.count == 2 else {
//                return nil
//            }
//            if let value = keyValue[1].removingPercentEncoding,
//                value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                return nil
//            }
//            return subString.removingPercentEncoding
//        })
//    }
}

extension URLComponents {
    func appending(query: URLQueryItem) -> URLComponents? {
        guard let name = query.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let newQ: String?
        let value = query.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let q = self.percentEncodedQuery, !q.isEmpty {
            newQ = q + "&\(name)=\(value)"
        } else {
            newQ = "\(name)=\(value)"
        }
        var c = self
        c.percentEncodedQuery = newQ
        return c
    }
}
