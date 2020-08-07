//
//  SSRequestKitConfig.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation


public class SSRequestKitConfig: NSObject {
    
    public static let defaultConfig: SSRequestKitConfig  = SSRequestKitConfig()

    // 公共参数
    public var token: String?
    public var appId: String?
    public var deviceId: String?
    public var secret: String?
    public var requestAdater: SSRequestAdapter?
    public var retrier: SSRequestRetrier?
    public var isShowDebugInfo: Bool = false
    public var service: SSRequestService!
    
}
