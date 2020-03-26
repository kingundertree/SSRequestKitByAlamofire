//
//  ViewController.swift
//  SSRequestKitByAlamofireDemo
//
//  Created by ixiazer on 2020/3/24.
//  Copyright © 2020 FF. All rights reserved.
//

import UIKit
import SSRequestKitByAlamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        SSRequestKitConfig.defaultConfig.appId = "100001";
        SSRequestKitConfig.defaultConfig.deviceId = "mnsdnjenrjkjke38dajdjwejd";
        SSRequestKitConfig.defaultConfig.token = "dskjjjjdj3dsjs";
        SSRequestKitConfig.defaultConfig.secret = "eiifs9wesdfsjes";
        SSRequestKitConfig.defaultConfig.requestAdater = SSRequestAdapter.init([SSHeaderAdater(), SSPublicPramsAdater(), SSSignAdater()])
        SSRequestKitConfig.defaultConfig.isShowDebugInfo = true;
        SSRequestKitConfig.defaultConfig.service = SSRequestService.init("https://**.******.com")
    
        normalRequest()
    }

    func normalRequest() {
        let bizContent: [String : Any] = ["UserId": NSNumber(value: 0)]
        let bizContentStr = self.dicValueString(bizContent)
        let initDic: [String : Any] = ["method" : "HomePageManager.GetHomePageInfo",
                                       "bizContent" : bizContentStr ?? [:],
                                       "module": "appguide",
                                       "version": "3.0",
                                       "clientVersion": "6.4.2"]
    
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
    }
    
    func uploadRequest() {
        let api = makeApi("/upload", .post, queries: nil)
        api.uploadDataArr = []
        api.isUpdate = true
        api.requestData { (result) in
            result.withValue { (json) in
                print("requestJson==>>%@", json)
            }.withError { (error) in
                guard let wrapError: SSError = error as? SSError else {
                    return
                }
                print("error：\nErrorCode", wrapError.errCode, "\ndesc", wrapError.localizedDescription)
            }
        }
    }
    
    // MARK: 字典转字符串
   func dicValueString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }

    // MARK: 字符串转字典
    func stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
}


