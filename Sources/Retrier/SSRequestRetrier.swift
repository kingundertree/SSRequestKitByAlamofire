//
//  SSRequestRetrier.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import Alamofire

public class SSRequestRetrier: RequestRetrier {

    private var dispatchRetrier: [RequestRetrier] = []
    
    public convenience init(_ retriers: [RequestRetrier]) {
        self.init()
        
        appendRetriers(retriers)
    }
    
    public func appendRetrier(_ retrier: RequestRetrier) {
        dispatchRetrier.append(retrier)
    }
    
    public func appendRetriers(_ retriers: [RequestRetrier]) {
        dispatchRetrier.append(contentsOf: retriers)
    }
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        for retrier in dispatchRetrier {
            retrier.should(manager, retry: request, with: error, completion: completion)
        }
        
        // 不处理
        completion(false, 0);
    }
}

