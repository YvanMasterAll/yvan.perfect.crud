//
//  model.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/5/11.
//

import Foundation
import Fluent

enum Gender: String, Codable, CRUDEnumCodable {
    
    case male                   = "男"
    case female                 = "女"
    case unknown                = "未知"
    
    public var value: String {
        switch self {
        case .male              : return "男"
        case .female            : return "女"
        case .unknown           : return "未知"
        }
    }
    
    init(_ value: String) {
        switch value {
        case "男", "male"        : self = .male
        case "女", "female"      : self = .female
        default                  : self = .unknown
        }
    }
    
//    //MARK: - 如果要用String类型的枚举, 需要自己实现以下方法 => 已改善
//    enum Key: CodingKey {
//        case rawValue
//    }
//    
//    enum CodingError: Error {
//        case unknownValue
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Key.self)
//        let rawValue = try container.decode(String.self, forKey: .rawValue)
//        switch rawValue {
//        case "male":
//            self = .male
//        case "female":
//            self = .female
//        default:
//            throw CodingError.unknownValue
//        }
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Key.self)
//        switch self {
//        case .male:
//            try container.encode("male", forKey: .rawValue)
//        case .female:
//            try container.encode("male", forKey: .rawValue)
//        }
//    }
}

class Student: PostgresCRUDModel, Codable, TableNameProvider {
    
    typealias T = Student
    static var tableName: String = "student"    //自定义表名
    enum CodingKeys: String, CodingKey {        //自定义字段名
        case id, name = "name", gender = "gender", books = "books"
    }
    var id: Int
    var name: String
    var gender: Gender
    var books: [Book]?
    var results: [T]?
    
    init(id: Int = 0,
         name: String = "",
         gender: Gender = .male) {
        self.id = id
        self.name = name
        self.gender = gender
        self.books = nil
        self.results = []
    }
    
    func modifies() -> [ModifyType<T>]? {
        return [.name(\T.name)]
    }
    
    func modifies_out() -> [ModifyOutType<T>]? {
        return [.name(\T.name)]
    }
    
    public func records() throws {
        let query = try db()
            .order(by: \.id)
            .join(\.books,
                  with: Record.self,
                  on: \.id,
                  equals: \.stuid,
                  and: \.id,
                  is: \.bkid)
            .order(by: \.name)
            .where(\Student.name != "")
            .select()
        
        var records: [Student] = []
        for r in query {
            records.append(r)
        }
        results = records
    }
    
    public func add() throws {
        //测试数据修改
        self.modify()
        try db()
            .insert(self, ignoreKeys: \Student.id)
    }
    
    public func update() throws {
        try db()
            .where(\Student.id == self.id)
            .update(self, setKeys: \.name)
    }
}

class Book: PostgresCRUDModel, Codable, TableNameProvider {
    
    typealias T = Book
    static var tableName: String = "book"
    var id: Int
    var name: String
    var students: [Student]?
    var results: [T]?
    
    init(id: Int = 0,
         name: String = "") {
        self.id = id
        self.name = name
        self.students = nil
        results = []
    }
    
    func modifies() -> [ModifyType<T>]? {
        return nil
    }
    
    func modifies_out() -> [ModifyOutType<T>]? {
        return nil
    }
    
    public func add() throws {
        try db()
            .insert(self, ignoreKeys: \Book.id)
    }
}

class Record: PostgresCRUDModel, Codable, TableNameProvider {
    
    typealias T = Record
    static var tableName: String = "record"
    var id: Int
    var bkid: Int
    var stuid: Int
    var time: Date
    var results: [T]?
    
    init(id: Int = 0,
         bkid: Int = 0,
         stuid: Int = 0,
         time: Date = Date()) {
        self.id = id
        self.bkid = bkid
        self.stuid = stuid
        self.time = time
        results = []
    }
    
    func modifies() -> [ModifyType<T>]? {
        return nil
    }
    
    func modifies_out() -> [ModifyOutType<T>]? {
        return nil
    }
}

class TestView: PostgresCRUDModel, Codable, TableNameProvider {

    typealias T = TestView
    static var tableName: String = "v_test"
    var id: Int
    var name: String
    var results: [T]?

    init(id: Int = 0,
         name: String = "",
         stuid: Int = 0) {
        self.id = id
        self.name = name
        results = []
    }

    func modifies() -> [ModifyType<T>]? {
        return nil
    }

    func modifies_out() -> [ModifyOutType<T>]? {
        return nil
    }
}
