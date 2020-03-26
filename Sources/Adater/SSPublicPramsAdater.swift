//
//  SSPublicPramsAdater.swift
//  Alamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import Alamofire

public class SSPublicPramsAdater: RequestAdapter {
    
    public init() {
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard
            let url = urlRequest.url,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return urlRequest
        }
        
        var pulicItems = self.queryParamForPublic()
//            self.publicParams()
        var percentEncodedQuery = pulicItems.query()
        if let queryString = components.percentEncodedQuery {
            percentEncodedQuery += ("&" + queryString)
        }
        var request = urlRequest
        components.percentEncodedQuery = percentEncodedQuery
        request.url = components.url
        return request
    }
    
//    private func publicParams()-> Parameters {
//        var dict: Parameters = [:]
//
//        let appVer = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//        dict["app_id"] = SSRequestKitConfig.defaultConfig.appId
//        dict["app_ver"] = appVer ?? "0.0.1"
//        dict["lang"] = "zh-cn"
//        dict["region"] = "cn"
//        dict["device_id"] = SSRequestKitConfig.defaultConfig.deviceId ?? ""
//        dict["timestamp"] = String(format:"%ld", Int64(Date().timeIntervalSince1970 * 1000))
//        dict["terminal"] = [
//            "model": UIDevice.current.model,
//            "name": UIDevice.current.name
//            ].asJSONString()
//        return dict
//    }

    fileprivate func queryParamForPublic() -> [String: Any] {
        return ["appId": SSRequestKitConfig.defaultConfig.appId ?? "",
                "region": "cn",
                "lang": "zh-cn",
                "appVersion": (Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "") as! String,
                "timeStamp" : NSDate.timeIntervalSinceReferenceDate,
                "deviceId": SSRequestKitConfig.defaultConfig.deviceId ?? "",
                "device": "iOS"]
    }
}

extension Parameters {
    func query() -> String {
        var components: [(String, String)] = []
        for key in self.keys.sorted(by: <) {
            if let value = self[key] {
                components += URLEncoding.default.queryComponents(fromKey: key, value: value)
            }
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}
