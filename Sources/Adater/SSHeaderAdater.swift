//
//  SSHeaderAdater.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import Alamofire

public class SSHeaderAdater: RequestAdapter {
    
    public init() {
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let tokenValue = urlRequest.allHTTPHeaderFields?["Authorization"] as? String, !tokenValue.isEmpty {
            return urlRequest
        } else {
            if let token = SSRequestKitConfig.defaultConfig.token, !token.isEmpty {
                urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
            }
        }
        return urlRequest
    }

}
