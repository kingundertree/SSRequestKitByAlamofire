### 概述
SSRequestKitByAlamofire 是基于Alamofire封装，适配大部分企业的网络请求框架。
1. 核心通过RequestAdapter和RequestRetrier适配来满足需要的request。
2. 通过SSRequestable 协议简化请求和response的map映射，让请求调用更简单好用
3. 和SSRequestDirect实现非常类似

### 调用
```
let initDic: [String : Any] = [:]
let api = makeApi("/gateway", .post, queries: initDic)
api.requestData { (result) in
    result.withValue { (json) in
        print("requestJson==>>%@", json)
    }.withError { (error) in
        guard let wrapError: SSError = error as? SSError else {
            return
        }
        print("error==>>", wrapError.errCode, wrapError.localizedDescription)
    }
}

```

### 核心类
#### SSBaseApi
1. 定义基础的业务数据，比如host、path、method、requestSerializer、requestResponseSerializer等
2. 触发request


```
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
```

#### Api+EXT.swift
1. 基于SSRequestable实现了更灵活的调用和response解析

#### SSRequestHandler
1. 自定义SessionManager，可以自定义RequestAdapter、RequestRetrier，甚至TSP认证
2. 通过Alamofire触发请求
3. 通过SSReqeustKitLog请求前和请求后日志打印

```
let dateRequest: DataRequest =  sessionManager.request(encodedURLRequest).responseJSON { [weak self] (response) in
    guard let strongSelf = self else { return }
    DispatchQueue.main.async {
        strongSelf.responseHandle(response, complete)
    }
}
// 缓存request的url，用户取消请求用
baseApi.fullRequestUrl = dateRequest.request?.url?.absoluteString
SSReqeustKitLog.showRequestPreLog(dateRequest)

```

#### SSRequestAdapter
1. 实现公共参数、签名、headerFields
2. 可以根据业务自定义添加

#### SSRequestKitConfig
```
SSRequestKitConfig.defaultConfig.appId = "100001";
SSRequestKitConfig.defaultConfig.deviceId = "mnsdnjenrjkjke38dajdjwejd";
SSRequestKitConfig.defaultConfig.token = "dskjjjjdj3dsjs";
SSRequestKitConfig.defaultConfig.secret = "eiifs9wesdfsjes";
SSRequestKitConfig.defaultConfig.requestAdater = SSRequestAdapter.init([SSHeaderAdater(), SSPublicPramsAdater(), SSSignAdater()])
SSRequestKitConfig.defaultConfig.isShowDebugInfo = true;
SSRequestKitConfig.defaultConfig.service = SSRequestService.init("https://**.******.com")
```

### 移除请求
```
/*
 取消某个请求
 创建DataRequest后，需要SSBaseApi缓存url，通过url寻找对应request，通过Alamofire寻找task后再cance()
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
 通过URLSession的getTasksWithCompletionHandler取消全部请求
 */
func cancleAllRequest() {
    sessionManager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
        sessionDataTask.forEach{ $0.cancel() }
        uploadData.forEach{ $0.cancel() }
        downloadData.forEach{ $0.cancel() }
    }
}
```


### 日志输出

```
**************************************************************************
*                  SSRequestKitByAlamofire Response Start                *
**************************************************************************


response.timeline：
 Timeline: { "Latency": 0.180 secs, "Request Duration": 0.181 secs, "Serialization Duration": 0.000 secs, "Total Duration": 0.181 secs } 

response.url：
 https://**.******.com/gateway?appId=100001&appVersion=1.0&device=iOS&deviceId=mnsdnjenrjkjke38dajdjwejd&lang=zh-cn&region=cn&timeStamp=606906303.56609&sign=9b099b4fa9d194aa6ca0a64349bd1cfd 

response.allHTTPHeaderFields：
 ["Authorization": "dskjjjjdj3dsjs", "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"] 

response.method：
 POST 

response.httpBody：
 bizContent=%7B%22UserId%22%3A0%7D&clientVersion=6.4.2&method=******.******&module=appguide&version=3.0 

response.data：
 {
  "errorCode" : 5002,
  "result" : "0",
  "errorMsg" : "签名错误:请求已过期，您的timestamp:"
}


************************************************************************
*                  SSRequestKitByAlamofire Response End                *
************************************************************************
```
