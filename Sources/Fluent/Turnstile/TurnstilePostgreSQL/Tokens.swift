//
//  Tokens.swift
//  PerfectTurnstilePostgreSQL
//
//  Created by Jonathan Guthrie on 2016-10-17.
//
//

//import PostgresStORM
//import StORM
//import Foundation
////import SwiftRandom
//
//
///// Class for handling the tokens that are used for JSON API and Web authentication
//open class AccessTokenStore : PostgresStORM {
//
//    /// The token itself.
//    public var token: String = ""
//
//    /// The userid relates to the Users object UniqueID
//    public var userid: String = ""
//
//    /// Integer relaing to the created date/time
//    public var created: Int = 0
//
//    /// Integer relaing to the last updated date/time
//    public var updated: Int = 0
//
//    /// Idle period specified when token was created
//    public var idle: Int = 86400 // 86400 seconds = 1 day
//
//    /// Table name used to store Tokens
//    override open func table() -> String {
//        return "tokens"
//    }
//
//
//    /// Set incoming data from database to object
//    open override func to(_ this: StORMRow) {
//        if let val = this.data["token"]        { token        = val as! String }
//        if let val = this.data["userid"]    { userid    = val as! String }
//        if let val = this.data["created"]    { created    = val as! Int }
//        if let val = this.data["updated"]    { updated    = val as! Int }
//        if let val = this.data["idle"]        { idle        = val as! Int}
//
//    }
//
//    /// Iterate through rows and set to object data
//    func rows() -> [AccessTokenStore] {
//        var rows = [AccessTokenStore]()
//        for i in 0..<self.results.rows.count {
//            let row = AccessTokenStore()
//            row.to(self.results.rows[i])
//            rows.append(row)
//        }
//        return rows
//    }
//
//    private func now() -> Int {
//        return Int(Date.timeIntervalSinceReferenceDate)
//    }
//
//    /// Checks to see if the token is active
//    /// Upticks the updated int to keep it alive.
//    public func check() -> Bool? {
//        if (updated + idle) < now() { return false } else {
//            do {
//                updated = now()
//                try save()
//            } catch {
//                print(error)
//            }
//            return true
//        }
//    }
//
//    /// Triggers creating a new token.
//    public func new(_ u: String) -> String {
//        let rand = URandom()
//        token = rand.secureToken
//        token = token.replacingOccurrences(of: "-", with: "a")
//        userid = u
//        created = now()
//        updated = now()
//        do {
//            try create()
//        } catch {
//            print(error)
//        }
//        return token
//    }
//}

import Foundation
import StORM
//import SwiftRandom

/// Class for handling the tokens that are used for JSON API and Web authentication
open class AccessTokenStore : Codable, TableNameProvider {
    
    public static var tableName: String = "tokens"
    
    /// The token itself.
    public var token: String = ""
    
    /// The userid relates to the Users object UniqueID
    public var userid: String = ""
    
    /// Integer relaing to the created date/time
    public var created: Int = 0
    
    /// Integer relaing to the last updated date/time
    public var updated: Int = 0
    
    /// Idle period specified when token was created
    public var idle: Int = 86400 // 86400 seconds = 1 day
    
    private func now() -> Int {
        return Int(Date.timeIntervalSinceReferenceDate)
    }
    
    public init() { }
    
    /// Checks to see if the token is active
    /// Upticks the updated int to keep it alive.
    public func check() -> Bool? {
        if (updated + idle) < now() { return false } else {
            do {
                updated = now()
                try postgresDB.table(AccessTokenStore.self).update(self)
            } catch {
                print(error)
            }
            return true
        }
    }
    
    /// Get a access instance by token.
    public func get(_ id: String) throws -> AccessTokenStore {
        do {
            let query = try postgresDB.table(AccessTokenStore.self)
                .limit(1, skip: 0)
                .where(\AccessTokenStore.token == id)
                .select()
            var results: [AccessTokenStore] = []
            for r in query {
                results.append(r)
            }
            if results.count == 0 {
                throw StORMError.noRecordFound
            }
            return results[0]
        } catch {
            throw StORMError.noRecordFound
        }
    }
    
    public func delete(_ id: String) throws {
        do {
            try postgresDB.table(AccessTokenStore.self)
                .where(\AccessTokenStore.token == id)
                .delete()
        } catch {
            throw error
        }
    }
    
    /// Triggers creating a new token.
    public func new(_ u: String) -> String {
        let rand = URandom()
        token = rand.secureToken
        token = token.replacingOccurrences(of: "-", with: "a")
        userid = u
        created = now()
        updated = now()
        do {
            let query = try postgresDB.table(AccessTokenStore.self).insert(self)
        } catch {
            print(error)
        }
        return token
    }
}
