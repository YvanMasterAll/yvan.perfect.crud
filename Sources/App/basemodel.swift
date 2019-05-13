//
//  basemodel.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/5/13.
//

import Foundation
import Fluent

public protocol PostgresCRUDModel {
    
    associatedtype T: Codable
    
    var results: [T]? { get set }
    
    /// 数据库连接器
    func db() -> Table<T, Database<PostgresDatabaseConfiguration>>
    
    /// Encode
    func toJson() -> String
    func toDicts() -> [[String: Any]]
    
    /// 删除一行
    func delete(by: CRUDBooleanExpression) throws
    
    /// 获取一行
    func get(by: CRUDBooleanExpression) throws -> T?
    
    /// 数据修改
    func modify()
    func modifies() -> [ModifyType<T>]?
    func modifies_out() -> [ModifyOutType<T>]?
}

extension PostgresCRUDModel where Self: Codable {
    
    /// 数据库连接器
    public func db() -> Table<T, Database<PostgresDatabaseConfiguration>> {
        return postgresDB.table(T.self)
    }
    
    //MARK: - Encode
    
    public func toJson() -> String {
        let data = results ?? []
        var _data = ""
        let jsonEncoder = JSONEncoder()
        for d in data {
            //序列化之前修改数据
            if let modifies = modifies_out() {
                for modify in modifies {
                    modify.apply(d)
                }
            }
            if let r = try? jsonEncoder.encode(d), let _r = String(data: r, encoding: String.Encoding.utf8) {
                _data.append(_r)
            }
        }
        
        return _data
    }
    
    public func toDicts() -> [[String: Any]] {
        let data = results ?? []
        let jsonEncoder = JSONEncoder()
        var _data: [[String: Any]] = []
        for d in data {
            //序列化之前修改数据
            if let modifies = modifies_out() {
                for modify in modifies {
                    modify.apply(d)
                }
            }
            if let r = try? JSONSerialization.jsonObject(with: jsonEncoder.encode(d)) as? [String: Any], let _r = r {
                _data.append(_r)
            }
        }
        
        return _data
    }
    
    /// 删除一行
    public func delete(by: CRUDBooleanExpression) throws {
        do {
            try self.db()
                .where(by)
                .delete()
        } catch {
            throw error
        }
    }
    
    /// 获取一行
    public func get(by: CRUDBooleanExpression) throws -> T? {
        do {
            let query = try self.db()
                .limit(1, skip: 0)
                .where(by)
                .select()
            var results: [T] = []
            for r in query {
                results.append(r)
            }
            if results.count == 0 {
                return nil
            }
            return results[0]
        } catch {
            throw error
        }
    }
    
    /// 首个字段作为关键字
    public func firstAsKey() -> (String, Any) {
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            return (label, value)
        }
        return ("id", "unknown")
    }
    
    /// 数据修改
    public func modify() {
        if let _modifies = modifies() {
            for modify in _modifies {
                modify.apply(self as! T)
            }
        }
    }
}


//MARK: - 数据修改, 在数据库操作前后更改数据

public enum ModifyType<T> {
    
    case name(_ by: ReferenceWritableKeyPath<T, String>)
}

extension ModifyType {
    
    func apply(_ to: T) {
        switch self {
        case .name(let by):
            to[keyPath: by] = "2班" + to[keyPath: by]
        }
    }
}

public enum ModifyOutType<T> {
    
    case name(_ by: ReferenceWritableKeyPath<T, String>)
}

extension ModifyOutType {
    
    func apply(_ to: T) {
        switch self {
        case .name(let by):
            to[keyPath: by] = (to[keyPath: by]).replacingOccurrences(of: "2班", with: "4班")
        }
    }
}
