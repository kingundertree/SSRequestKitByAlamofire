//
//  SSBaseApi.swift
//  SSRequestKitByAlamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum SSRequestHandlerSessionType {
    case Default // 默认
    case Authentication // 需要自建TSP认证
}

public enum SSRequestSerializerType {
    case SSRequestSerializerTypeHTTP // form
    case SSRequestSerializerTypeJSON // json
}

public enum SSResponseSerializerType {
    case ResponseSerializerHTTP
    case ResponseSerializerText
    case ResponseSerializerJSON
    case ResponseSerializerXML
}

fileprivate let mimeType = "image/jpeg"

/*
 下载进度回调
 */
public typealias SSRequestProgressBlock = (_ progress: Progress) -> Void

/*
 上传数据组合
*/
public typealias SSRequestConstructingBlock = (_ formData: MultipartFormData) -> Void

public func makeApi(_ path: String, _ method: HTTPMethod, queries: Parameters?) -> SSBaseApi {
    var api = SSBaseApi()
    api.path = path
    api.method = method
    api.arguments = queries ?? [:]
    
    return api
}

public class SSBaseApi: NSObject, NSCopying {
    fileprivate var appVersion: String = ""
    fileprivate var region: String = ""
    fileprivate var lang: String = ""
    fileprivate var appId: String = ""
    fileprivate var deviceId: String = ""
    fileprivate var timestamp: TimeInterval = 0

    public var service: SSRequestService = SSRequestService.init("https://wx.freshfresh.com")
    public var path: String = ""
    public var method: HTTPMethod = .get
    public var arguments: Parameters = [:]
    public var requestSerizalType: SSRequestSerializerType = .SSRequestSerializerTypeHTTP
    public var responseSerizalType: SSResponseSerializerType = .ResponseSerializerJSON
    public var uploadDataArr: [Data]?
    public var uploadFileArr: [String]?
    
    public var isUpdate: Bool = false
    var fullRequestUrl: String?
    
    public convenience init(_ path: String, _ queries: [String: Any]) {
        self.init()
        
        self.path = path
        self.arguments = queries
        
//        doConfigInit()
    }
    
//    func doConfigInit() {
//        appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "") as! String
//        region = "cn"
//        lang = "zh-cn"
//        appId = SSRequestKitConfig.defaultConfig.appId ?? ""
//        timestamp = NSDate.timeIntervalSinceReferenceDate
//        self.deviceId = SSRequestKitConfig.defaultConfig.deviceId ?? ""
//    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let api = SSBaseApi.init()
        api.arguments = self.arguments
        api.method = self.method
        api.requestSerizalType = self.requestSerizalType
        api.responseSerizalType = self.responseSerizalType
        api.path = self.path
        api.uploadDataArr = self.uploadDataArr
        api.uploadFileArr = self.uploadFileArr
        
        return api
    }
    
    public subscript(key: String) -> Any? {
        get {
            return self.arguments[key]
        }
        set {
            self.arguments[key] = newValue
        }
    }

    public func requestPath() -> String {
        return self.path
//        公共参数通过Adater实现
//            + "?" + self.queryParamForPublic().map { "\($0)=\($1)" }.joined(separator: "&")
    }

    public func mehod() -> HTTPMethod {
        return method
    }
    
    public func sessionType() -> SSRequestHandlerSessionType {
        return .Default
    }
    
    public func requestArgument() -> Parameters {
        return self.arguments
    }
    
    public func requestSerializerType() -> SSRequestSerializerType {
        return requestSerizalType
    }

    public func requestTimeoutInterval() -> TimeInterval {
        return 20;
    }
    
    // MARK:- method
//    fileprivate func queryParamForPublic() -> [String: Any] {
//        return ["appId": self.appId,
//                "region": self.region,
//                "lang": self.lang,
//                "appVersion": self.appVersion,
//                "timeStamp" : self.getNowFormateDate(),
//                "deviceId": self.deviceId,
//                "device": "iOS"]
//    }
    
    fileprivate func getNowFormateDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.string(from: Date())
        
        return dateStr
    }
    
    func cancelRequest() {
        SSRequestHandler.share.cancleRequest(self)
    }

    public func constructingBlock() -> SSRequestConstructingBlock? {
        if let dataArr = self.uploadDataArr {
            return { formData in
                var i = 1
                for d in dataArr {
                    let fielName = "\(NSDate.timeIntervalSinceReferenceDate)" + "_\(i).jpeg"
                    formData.append(d, withName: "file", mimeType: mimeType)
                    i = i + 1
                }
            }
        } else if let fileArr = self.uploadFileArr {
            return { formData in
                var i = 1
                for p in fileArr {
                    do {
                        let fileURL = URL(fileURLWithPath: p)
                        let fileName = "\(NSDate.timeIntervalSinceReferenceDate)" + "_\(i).jpeg"
                        try formData.append(fileURL, withName: "file", fileName: fileName, mimeType: mimeType)
                    } catch {
                        print("generate formData error")
                    }

                    i = i + 1
                }
            }
        } else {
            return nil
        }
    }
}

// 触发请求
extension SSBaseApi {
    // 普通请求
    public func requestWithCompletionBlock(_ complete: @escaping Completion<JSON>) {
        SSRequestHandler.share.doRequestOnQueue(self, complete)
    }
    // 上传
    public func uploadRequestWithCompletionBlock(_ complete: @escaping Completion<JSON>) {
        SSRequestHandler.share.doRequestOnQueue(self, complete)
    }
}

extension SSBaseApi : SSRequestable {
    public func requestResult(completion: @escaping Completion<R>) {
        if isUpdate == false {
            self.requestWithCompletionBlock(completion)
        } else {
            self.uploadRequestWithCompletionBlock(completion)
        }
    }
}
