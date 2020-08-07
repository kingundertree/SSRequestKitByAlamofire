//
//  SSRequestService.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation


public class SSRequestService: NSObject {
    var baseApi: String!
    
    public convenience init(_ baseApi: String!) {
        self.init()
        self.baseApi = baseApi
    }
}
