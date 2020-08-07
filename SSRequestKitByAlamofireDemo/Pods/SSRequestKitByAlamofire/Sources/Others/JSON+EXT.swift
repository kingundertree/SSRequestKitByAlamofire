//
//  JSON+EXT.swift
//  SSRequestKitByAlamofire
//
//  Created by ixiazer on 2020/3/24.
//

import Foundation
import SwiftyJSON

private func _asJSONString(with jsonObject: Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: jsonObject) else { return nil }
    return String(data: data, encoding: String.Encoding.utf8)
}

extension Array {
    
    public func asJSONString() -> String? { return _asJSONString(with: self) }
}

extension Dictionary {
    
    public func asJSONString() -> String? { return _asJSONString(with: self) }
}

extension NSArray {
    
    @objc
    public func asJSONString() -> String? { return _asJSONString(with: self) }
}

extension NSDictionary {
    
    @objc
    public func asJSONString() -> String? { return _asJSONString(with: self) }
}

extension String {
    public func asDictionary() -> Dictionary<String, Any>? {
        if  let jsonData = self.data(using: .utf8) {
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? Dictionary<String, Any>
            return dict ?? nil
        }
        return nil
    }
    
    public func asSwiftyJSON() -> JSON? {
        if let dict = self.asDictionary() {
            return JSON(dict)
        }
        return nil
    }
}
