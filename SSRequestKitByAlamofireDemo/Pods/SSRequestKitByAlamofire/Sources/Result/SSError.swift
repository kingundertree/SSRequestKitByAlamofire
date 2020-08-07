//
//  SSRequestDirect.swift
//  AFNetworking
//
//  Created by ixiazer on 2020/3/17.
//

import Foundation

public let SSErrorDomain = "com.ss.com.error"
public let SSDefaultErrorCode = "SSDefaultErrorCode" // response未解析到errorcode
public let SSDefaultErrorMessage = "SSDefaultErrorMessage" // response未解析到errorMessage

public enum SSError: Error {
    case general
    case network
    case custom(resultCode: String)
    case customDesc(resultCode: String, description: String)
    // 数据类型异常
    case dataFormatUnexcepted(data: String)
    
    case dataCorrupted

    case dataNull

    case uploadErr(reason: UploadError)
    
    public enum UploadError {
        case nullPhoto
    }
}

let defaultServerErrDesc: String = "服务不可用，请稍后再试"
let defaultServerErrDescB: String = "遇到了一些问题，请稍后重试"
let defaultAppErrDesc: String = "服务不可用，请稍后再试"

let ssErrDescMap: [String: String] = [
    "sign_failed": "签名失败",
    "invalid_param": "参数错误",
    "internal_error": "服务器内部错误",
    "auth_failed": "你的登录信息已过期,请重新登录"
]
//"blacklisted_mobile": "不合法手机号不允许注册"
/*

 NSURLErrorUnknown = -1,
 NSURLErrorCancelled = -999,
 NSURLErrorBadURL = -1000,
 NSURLErrorTimedOut = -1001,
 NSURLErrorUnsupportedURL = -1002,
 NSURLErrorCannotFindHost = -1003,
 NSURLErrorCannotConnectToHost = -1004,
 NSURLErrorNetworkConnectionLost = -1005,
 NSURLErrorDNSLookupFailed = -1006,
 NSURLErrorHTTPTooManyRedirects = -1007,
 NSURLErrorResourceUnavailable = -1008,
 NSURLErrorNotConnectedToInternet = -1009,
 NSURLErrorRedirectToNonExistentLocation = -1010,
 NSURLErrorBadServerResponse = -1011,
 NSURLErrorUserCancelledAuthentication = -1012,
 NSURLErrorUserAuthenticationRequired = -1013,
 NSURLErrorZeroByteResource = -1014,
 NSURLErrorCannotDecodeRawData = -1015,
 NSURLErrorCannotDecodeContentData = -1016,
 NSURLErrorCannotParseResponse = -1017,
 NSURLErrorAppTransportSecurityRequiresSecureConnection = -1022,
 NSURLErrorFileDoesNotExist = -1100,
 NSURLErrorFileIsDirectory = -1101,
 NSURLErrorNoPermissionsToReadFile = -1102,
 NSURLErrorDataLengthExceedsMaximum = -1103,
 NSURLErrorSecureConnectionFailed = -1200,
 NSURLErrorServerCertificateHasBadDate = -1201,
 NSURLErrorServerCertificateUntrusted = -1202,
 NSURLErrorServerCertificateHasUnknownRoot = -1203,
 NSURLErrorServerCertificateNotYetValid = -1204,
 NSURLErrorClientCertificateRejected = -1205,
 NSURLErrorClientCertificateRequired = -1206,
 NSURLErrorCannotLoadFromNetwork = -2000,
 NSURLErrorCannotCreateFile = -3000,
 NSURLErrorCannotOpenFile = -3001,
 NSURLErrorCannotCloseFile = -3002,
 NSURLErrorCannotWriteToFile = -3003,
 NSURLErrorCannotRemoveFile = -3004,
 NSURLErrorCannotMoveFile = -3005,
 NSURLErrorDownloadDecodingFailedMidStream = -3006,
 NSURLErrorDownloadDecodingFailedToComplete = -3007,
 NSURLErrorInternationalRoamingOff = -1018,
 NSURLErrorCallIsActive = -1019,
 NSURLErrorDataNotAllowed = -1020,
 NSURLErrorRequestBodyStreamExhausted = -1021,
 NSURLErrorBackgroundSessionRequiresSharedContainer = -995,
 NSURLErrorBackgroundSessionInUseByAnotherProcess = -996,
 NSURLErrorBackgroundSessionWasDisconnected = -997
 */

//NSURLErrorDomain code = -1001
let urlErrorDescMap: [Int: String] = [
    NSURLErrorUnknown: "未知的错误",
    NSURLErrorCancelled: "请求被取消",
    NSURLErrorBadURL: "请求的URL错误，无法启动请求",
    NSURLErrorTimedOut: "请求超时",
    NSURLErrorUnsupportedURL: "不支持的URL Scheme",
    NSURLErrorCannotFindHost: "URL的host名称无法解析，即DNS有问题",
    NSURLErrorCannotConnectToHost: "连接host失败",
    NSURLErrorNetworkConnectionLost: "连接过程中被中断",
    NSURLErrorDNSLookupFailed: "URL的host名称无法解析，即DNS有问题",
    NSURLErrorHTTPTooManyRedirects: "重定向次数超过限制",
    NSURLErrorResourceUnavailable: "无法获取所请求的资源",
    NSURLErrorNotConnectedToInternet: "断网状态",
    NSURLErrorRedirectToNonExistentLocation: "重定向到一个不存在的位",
    NSURLErrorBadServerResponse: "服务器返回数据有误",
    NSURLErrorUserCancelledAuthentication: "身份验证请求被用户取消",
    NSURLErrorUserAuthenticationRequired: "访问资源需要身份验证",
    NSURLErrorZeroByteResource: "服务器报告URL数据不为空，却未返回任何数据",
    NSURLErrorCannotDecodeRawData: "响应数据无法解码为已知内容编码",
    NSURLErrorCannotDecodeContentData: "请求数据存在未知内容编码",
    NSURLErrorCannotParseResponse: "响应数据无法解析",
    NSURLErrorAppTransportSecurityRequiresSecureConnection: "需要Https加密连接",
    NSURLErrorFileDoesNotExist: "请求的文件路径上文件不存在",
    NSURLErrorFileIsDirectory: "请求的文件只是一个目录，而非文件",
    NSURLErrorNoPermissionsToReadFile: "缺少权限无法读取文件",
    NSURLErrorDataLengthExceedsMaximum: "资源数据大小超过最大限制",
    NSURLErrorSecureConnectionFailed: "安全连接失败",
    NSURLErrorServerCertificateHasBadDate: "服务器证书过期",
    NSURLErrorServerCertificateUntrusted: "不受信任的根服务器签名证书",
    NSURLErrorServerCertificateHasUnknownRoot: "服务器证书没有任何根服务器签名",
    NSURLErrorServerCertificateNotYetValid: "服务器证书还未生效",
    NSURLErrorClientCertificateRejected: "服务器证书被拒绝",
    NSURLErrorClientCertificateRequired: "需要客户端证书来验证SSL连接",
    NSURLErrorCannotLoadFromNetwork: "请求只能加载缓存中的数据，无法加载网络数据"
   /*
    NSURLErrorCannotCreateFile = -3000,
    NSURLErrorCannotOpenFile = -3001,
    NSURLErrorCannotCloseFile = -3002,
    NSURLErrorCannotWriteToFile = -3003,
    NSURLErrorCannotRemoveFile = -3004,
    NSURLErrorCannotMoveFile = -3005,
    NSURLErrorDownloadDecodingFailedMidStream = -3006,
    NSURLErrorDownloadDecodingFailedToComplete = -3007,
    NSURLErrorInternationalRoamingOff = -1018,
    NSURLErrorCallIsActive = -1019,
    NSURLErrorDataNotAllowed = -1020,
    NSURLErrorRequestBodyStreamExhausted = -1021,
    NSURLErrorBackgroundSessionRequiresSharedContainer = -995,
    NSURLErrorBackgroundSessionInUseByAnotherProcess = -996,
    NSURLErrorBackgroundSessionWasDisconnected = -997
    */
    ]

extension Error {
    
    public func tryAsSSError() -> SSError {
        if self is SSError {
            return self as! SSError
        } else {
            let nsError = (self as NSError)
            if nsError.domain == NSURLErrorDomain {
                let code = nsError.code
                let desc = nsError.description
                let errDesc = urlErrorDescMap[code] ?? desc
                return SSError.customDesc(resultCode: desc, description: errDesc)
            }
            else {
                let errDes = nsError.localizedDescription
                let errCode = nsError.code
                let errDomain = nsError.domain
                return SSError.customDesc(resultCode: "errDomain \(errCode)", description: errDes)
            }
        }
    }
}


extension SSError.UploadError {
    public var localizedDescription: String {
        switch self {
        case .nullPhoto:
            return "没有图片"
        }
    }
    
    public var errCode: String {
        switch self {
        case .nullPhoto:
            return "no photo"
        }
    }
}

extension SSError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .general:
            return "请求错误"
        case .network:
            return "网络异常"
        case .dataCorrupted:
            return "数据类型异常"
        case .custom(let resultCode):
            return ssErrDescMap[resultCode] ?? resultCode
        case .customDesc(let resultCode, let description):
            return description
        case .uploadErr(let reason):
            return reason.localizedDescription
        case .dataFormatUnexcepted(let dataStr):
            return "数据格式错误：" + dataStr
        case .dataNull:
            return "数据为空"
        }
    }
    
    public var failureReason: String? {
        return self.errCode
    }
    
   public var errCode: String {
        switch self {
        case .custom(let resultCode):
            return resultCode
        case .customDesc(let resultCode, let description):
            return resultCode
        case .general:
            return "general err"
        case .network:
            return "network err"
        case .dataCorrupted:
            return "dataCorrupted"
        case .uploadErr(let err):
            return err.errCode
        case .dataFormatUnexcepted(let dataStr):
            return "data format unexcepted"
        case .dataNull:
            return "dataNull"
    }
    }
}
