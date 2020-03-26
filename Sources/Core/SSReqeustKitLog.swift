//
//  SSReqeustKitLog.swift
//  SSRequestKitByAlamofire
//
//  Created by ixiazer on 2020/3/26.
//

import Foundation
import SwiftyJSON
import Alamofire

class SSReqeustKitLog {
    static public func showRequestPreLog(_ request: DataRequest) {
        if SSRequestKitConfig.defaultConfig.isShowDebugInfo {
            print("\n\n*************************************************************************\n*                  SSRequestKitByAlamofire Request Start                *\n*************************************************************************\n\n")
            print("request.url：\n", request.request?.url?.absoluteString ?? "", "\n")
            print("request.allHTTPHeaderFields：\n", request.request?.allHTTPHeaderFields ?? "", "\n")
            print("request.method：\n", request.request?.httpMethod ?? "", "\n")
            if let wrapBodyData = request.request?.httpBody {
                print("request.httpBody：\n", String(data: wrapBodyData, encoding: String.Encoding.utf8) ?? "", "\n")
            }
            print("\n\n***********************************************************************\n*                  SSRequestKitByAlamofire Request End                *\n***********************************************************************\n\n")
        }
    }

    static public func showRequestLog(_ response: DataResponse<Any>, _ dataJson: JSON?) {
        if SSRequestKitConfig.defaultConfig.isShowDebugInfo {
            print("\n\n**************************************************************************\n*                  SSRequestKitByAlamofire Response Start                *\n**************************************************************************\n\n")
            print("response.timeline：\n", response.timeline, "\n")
            print("response.url：\n", response.request?.url?.absoluteString ?? "", "\n")
            print("response.allHTTPHeaderFields：\n", response.request?.allHTTPHeaderFields ?? "", "\n")
            print("response.method：\n", response.request?.urlRequest?.httpMethod ?? "", "\n")
            if let wrapBodyData = response.request?.urlRequest?.httpBody {
                print("response.httpBody：\n", String(data: wrapBodyData, encoding: String.Encoding.utf8) ?? "", "\n")
            }
            print("response.data：\n", dataJson ?? "")
            print("\n\n************************************************************************\n*                  SSRequestKitByAlamofire Response End                *\n************************************************************************\n\n")
        }
    }
}
