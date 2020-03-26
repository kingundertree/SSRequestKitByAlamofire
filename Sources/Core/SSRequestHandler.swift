//
//  SSRequestHandler.swift
//  SSRequestKitByAlamofire
//
//  Created by ixiazer on 2020/3/25.
//

import Foundation
import Alamofire
import SwiftyJSON

class SSRequestHandler: NSObject {
    
    static let share = SSRequestHandler()
    private var sessionManager: SessionManager!
    
    override init() {
        super.init()
        
        sessionInit()
    }
    
    private func sessionInit() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = SSRequestKitConfig.defaultConfig.requestAdater
        sessionManager.retrier = SSRequestKitConfig.defaultConfig.retrier
    }
    
    /*
     创建请求
     baseApi, api的基本配置。包括url、params、method、requestSeries、responseSeries
     */
    public func doRequestOnQueue(_ baseApi: SSBaseApi, _ complete: @escaping Completion<JSON>) {
        let requestUrlStr: String = baseApi.service.baseApi + baseApi.requestPath()
        let url: URL = URL.init(string: requestUrlStr)!
        var requestUrl = URLRequest(url: url)
        requestUrl.timeoutInterval = baseApi.requestTimeoutInterval()
        requestUrl.httpMethod = baseApi.mehod().rawValue
        let encodedURLRequest = try! URLEncoding.default.encode(requestUrl, with: baseApi.requestArgument())

        if baseApi.responseSerizalType == .ResponseSerializerJSON {
            let dateRequest: DataRequest =  sessionManager.request(encodedURLRequest).responseJSON { [weak self] (response) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.responseHandle(response, complete)
                }
            }
            // 缓存request的url，用户取消请求用
            baseApi.fullRequestUrl = dateRequest.request?.url?.absoluteString
            SSReqeustKitLog.showRequestPreLog(dateRequest)
        } else {
            // XML 暂不处理
        }
    }

    /*
     创建上传文件请求
     */
    public func doUploadRequestOnQueue(_ baseApi: SSBaseApi, _ complete: @escaping Completion<JSON>) {
        let requestUrlStr: String = baseApi.service.baseApi + baseApi.requestPath()
        let url: URL = URL.init(string: requestUrlStr)!
        var requestUrl = URLRequest(url: url)
        requestUrl.timeoutInterval = baseApi.requestTimeoutInterval()
        requestUrl.httpMethod = baseApi.mehod().rawValue
        let encodedURLRequest = try! URLEncoding.default.encode(requestUrl, with: baseApi.requestArgument())

        if baseApi.responseSerizalType == .ResponseSerializerJSON {
            guard let structingBlock = baseApi.constructingBlock() else {
                return
            }
            sessionManager?.upload(multipartFormData: structingBlock, with: encodedURLRequest, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON {  [weak self] (response) in
                       guard let strongSelf = self else { return }
                       DispatchQueue.main.async {
                           strongSelf.responseHandle(response, complete)
                       }
                    }
                    break
                case .failure(let error):
                    let err = error as NSError
                    complete(Result.failure(err))
                    break
                }
            })
        } else {
            // XML 暂不处理
        }
    }
    
    private func responseHandle(_ response: DataResponse<Any>, _ complete: @escaping Completion<JSON>) {
        if let wrapError = response.error {
            SSReqeustKitLog.showRequestLog(response, nil)
            complete(Result.failure(wrapError))
            return
        }

        switch response.result {
            case .success:
                guard let wrapData = response.data else {
                    // 空data
                    complete(Result.failure(SSError.dataNull))
                    return
                }
                do {
                    let dataJson = try JSON(data: wrapData, options: [JSONSerialization.ReadingOptions.allowFragments , JSONSerialization.ReadingOptions.mutableContainers])
                    
                    SSReqeustKitLog.showRequestLog(response, dataJson)
                    if let resultCode = dataJson["result"].string {
                        if resultCode == "1" {
                            complete(Result.success(dataJson))
                        } else {
                            let errorCode = "\(dataJson["errorCode"].numberValue)"
                            let errorMsg = dataJson["errorMsg"].string
                            complete(Result.failure(SSError.customDesc(resultCode: errorCode ?? SSDefaultErrorCode, description: errorMsg ?? SSDefaultErrorMessage)))
                        }
                    } else {
                        complete(Result.failure(SSError.dataCorrupted))
                    }
                } catch {
                    complete(Result.failure(SSError.dataCorrupted))
                }
                break
            case .failure:
                // 非json数据格式
                complete(Result.failure(SSError.dataCorrupted))
                break
        }
    }
    
    /*
     取消某个请求
     */
    func cancleRequest(_ baseApi: SSBaseApi) {
        sessionManager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach{
                if $0.originalRequest?.url?.absoluteString == baseApi.fullRequestUrl {
                    $0.cancel()
                }
            }
        }
    }

    /*
     取消全部请求
     */
    func cancleAllRequest() {
        sessionManager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach{ $0.cancel() }
            uploadData.forEach{ $0.cancel() }
            downloadData.forEach{ $0.cancel() }
        }
    }
}

