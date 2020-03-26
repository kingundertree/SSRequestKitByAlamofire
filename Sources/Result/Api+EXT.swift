//
//  Api+EXT.swift
//  AFNetworking
//
//  Created by ixiazer on 2020/3/17.
//


import Foundation
import SwiftyJSON
import Alamofire

public typealias Completion<Value> = (Result<Value>) -> Void

public protocol SwiftyJSONDeserializable {

    init?(swiftyJSON json: SwiftyJSON.JSON)
}

public protocol SwiftyJSONUpdatable : SwiftyJSONDeserializable {
    @discardableResult
    func update(withSwiftyJSON json: SwiftyJSON.JSON) -> Bool
}

public protocol SSRequestable {
    associatedtype R = JSON
    func requestResult(completion: @escaping Completion<R>)
}

extension SSRequestable where R == JSON {
    public func requestData<T>(as type: T.Type = T.self, dataTransform: @escaping (JSON) -> T?, completion: @escaping Completion<T>) {
        self.atJSONPath("data").requestResult { (result) in
            result.withValue({ (json) in
                if let val = dataTransform(json) {
                    completion(Result.success(val))
                } else {
                    completion(Result.failure(SSError.dataCorrupted))
                }
            }).withError({ (err) in
                completion(Result.failure(err))
            })
        }
    }
    
    public func requestData<T: SwiftyJSONDeserializable> (as type: T.Type = T.self, completion: @escaping Completion<T>) {
        self.atJSONPath("data").requestResult { (result) in
            result.withValue({ (json) in
                if let val = type.init(swiftyJSON: json) {
                    completion(Result.success(val))
                } else {
                    completion(Result.failure(SSError.dataCorrupted))
                }
            }).withError({ (err) in
                completion(Result.failure(err))
            })
        }
    }
    
    public func requestData(completion: @escaping Completion<JSON>) {
        self.atJSONPath("data").requestResult(completion: completion)
    }
    
    public func atJSONPath(_ path: String) -> SSPathRequest<Self> {
        return SSPathRequest(self, path: path)
    }
    
    public func updateData<T: SwiftyJSONUpdatable>(_ item: T, completion: @escaping Completion<T>) {
        self.atJSONPath("data").update(item, completion: completion)
    }
}

extension SSRequestable where R == JSON {
    public func requestResult<T: SwiftyJSONDeserializable>(as type: T.Type = T.self, completion: @escaping Completion<T>) {
        self.transform(T.init(swiftyJSON:)).requestResult(completion: completion)
    }
    
    public func update<T: SwiftyJSONUpdatable>(_ item: T, completion: @escaping Completion<T>) {
        self.transform({ item.update(withSwiftyJSON: $0)  ? item : nil }).requestResult(completion: completion)
    }
}

public struct SSPathRequest<Request: SSRequestable> : SSRequestable where Request.R == JSON {
    
    private let request: Request
    private let path: String
    
    public init(_ request: Request, path: String) {
        self.request = request
        self.path = path
    }
    
    public func requestResult(completion: @escaping (Result<JSON>) -> Void) {
        let p = self.path
        request.requestResult { result in
            completion(result.map({ $0.jsonAtPath(p) }))
        }
    }
}

public struct MappingRequest<Request: SSRequestable, E>: SSRequestable {
 
    public typealias R = E
 
    let request: Request
 
    let transform: (Request.R) -> E?
 
    public init(request: Request, transform: @escaping (Request.R) -> E?) {
        self.request = request
        self.transform = transform
    }
 
    public func requestResult(completion: @escaping Completion<E>) {
        let trans = self.transform
        request.requestResult { result in
            do {
                let value = try result.unwrap()
                if let transformed = trans(value) {
                    completion(Result.success(transformed))
                } else {
                    throw SSError.dataCorrupted
                }
            } catch {
                completion(Result.failure(error))
            }
        }
    }
}


extension SSRequestable {
    public func transform<T>(_ transform: @escaping (R) -> T?) -> MappingRequest<Self, T> {
        return MappingRequest(request: self, transform: transform)
    }
}

