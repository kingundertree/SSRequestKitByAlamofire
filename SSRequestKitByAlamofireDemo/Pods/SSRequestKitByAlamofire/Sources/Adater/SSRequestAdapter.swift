//
//  SSRequestAdapter.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import Alamofire

public class SSRequestAdapter: RequestAdapter {
    
    private var dispatchAdaters: [RequestAdapter] = []
    
    public convenience init(_ adaters: [RequestAdapter]) {
        self.init()
        
        appendAdaters(adaters)
    }
    
    public func appendAdater(_ adater: RequestAdapter) {
        dispatchAdaters.append(adater)
    }
    
    public func appendAdaters(_ adaters: [RequestAdapter]) {
        dispatchAdaters.append(contentsOf: adaters)
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        // swift的应用类型，深度复制
        var urlRequestCopy = urlRequest
        do {
            // 遍历全部的URLRequest，自定义实现HeaderField、Sign等基本操作
            for adater: RequestAdapter in dispatchAdaters {
                try? urlRequestCopy = adater.adapt(urlRequestCopy)
            }
        } catch  {
            return urlRequestCopy
        }

        return urlRequestCopy
    }
}
