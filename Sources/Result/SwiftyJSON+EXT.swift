//
//  SSRequestDirect.swift
//  AFNetworking
//
//  Created by ixiazer on 2020/3/17.
//

import Foundation
import SwiftyJSON
import CoreLocation

extension JSON {
    
    public var percentValue: Double? { return double.map { $0 / 100 } }
    
    public var date: Date? { return double.map(Date.init(timeIntervalSince1970:)) }
    
    public func asObject<T: SwiftyJSONDeserializable>(_ type: T.Type = T.self) -> T? {
        return asObject(type, transform: T.init(swiftyJSON:))
    }
    
    public func asObject<T>(_ type: T.Type = T.self, transform: (JSON) -> T?) -> T? {
        return transform(self)
    }
    
    public func asObjects<T: SwiftyJSONDeserializable>(_ type: T.Type = T.self) -> [T]? {
        return array?.compactMap(T.init(swiftyJSON:))
    }
    
    public func asObjects<T>(_ type: T.Type = T.self, transform: (JSON) -> T?) -> [T]? {
        return array?.compactMap(transform)
    }
}


extension JSON {
    
    public func jsonAtPath(_ path: String) -> JSON {
        var reval = self
        for component in path.components(separatedBy: ".") {
            reval = reval[component]
        }
        return reval
    }
}

extension String: SwiftyJSONDeserializable {
    
    public init?(swiftyJSON json: SwiftyJSON.JSON) {
        if let string = json.string {
            self = string
        } else {
            return nil
        }
    }
}

extension Int: SwiftyJSONDeserializable {
    
    public init?(swiftyJSON json: SwiftyJSON.JSON) {
        if let int = json.int {
            self = int
        } else {
            return nil
        }
    }
}

extension URL: SwiftyJSONDeserializable {
    
    public init?(swiftyJSON json: SwiftyJSON.JSON) {
        if let url = json.url {
            self = url
        } else {
            return nil
        }
    }
}

extension Date: SwiftyJSONDeserializable {
    
    public init?(swiftyJSON json: SwiftyJSON.JSON) {
        if let date = json.date {
            self = date
        } else {
            return nil
        }
    }
}

extension Double: SwiftyJSONDeserializable {
    
    public init?(swiftyJSON json: SwiftyJSON.JSON) {
        if let double = json.double {
            self = double
        } else {
            return nil
        }
    }
}

extension Bool: SwiftyJSONDeserializable {
    
    public init?(swiftyJSON json: SwiftyJSON.JSON) {
        if let bool = json.bool {
            self = bool
        } else {
            return nil
        }
    }
}

