//
//  AuthRealm.swift
//  PerfectTurnstilePostgreSQL
//
//  Created by Jonathan Guthrie on 2016-10-17.
//
//

//import PostgresStORM
//
///// The "Turnstile Realm" that holds the main routing functionality for request filters
//open class AuthRealm : Realm {
//    /// A container for the Random object fromTurnstile Crypto
//    public var random: Random = URandom()
//
//    public init() {}
//
//    /// Used when a "Credentials" onject is passed to the authenticate function. Returns an Account object.
//    open func authenticate(credentials: Credentials) throws -> Account {
//
//        switch credentials {
//        case let credentials as UsernamePassword:
//            return try authenticate(credentials: credentials)
//        case let credentials as AccessToken:
//            return try authenticate(credentials: credentials)
//            //        case let credentials as FacebookAccount:
//            //            return try authenticate(credentials: credentials)
//            //        case let credentials as GoogleAccount:
//        //            return try authenticate(credentials: credentials)
//        default:
//            throw UnsupportedCredentialsError()
//        }
//
//    }
//
//    /// Used when an "AccessToken" onject is passed to the authenticate function. Returns an Account object.
//    open func authenticate(credentials: AccessToken) throws -> Account {
//        let account = AuthAccount()
//        let token = AccessTokenStore()
////        print(credentials.string)
//        do {
//            try token.get(credentials.string)
//            if token.check() == false {
//                throw IncorrectCredentialsError()
//            }
//            try account.get(token.userid)
//            return account
//        } catch {
//            throw IncorrectCredentialsError()
//        }
//    }
//
//
//    /// Used when a "UsernamePassword" onject is passed to the authenticate function. Returns an Account object.
//    open func authenticate(credentials: UsernamePassword) throws -> Account {
//        let account = AuthAccount()
//        do {
//            let thisAccount = try account.get(credentials.username, credentials.password)
//            return thisAccount
//        } catch {
//            throw IncorrectCredentialsError()
//        }
//    }
//
//    //    private func authenticate(credentials: FacebookAccount) throws -> Account {
//    //        if let account = accounts.filter({$0.facebookID == credentials.uniqueID}).first {
//    //            return account
//    //        } else {
//    //            return try register(credentials: credentials)
//    //        }
//    //    }
//    //
//    //    private func authenticate(credentials: GoogleAccount) throws -> Account {
//    //        if let account = accounts.filter({$0.googleID == credentials.uniqueID}).first {
//    //            return account
//    //        } else {
//    //            return try register(credentials: credentials)
//    //        }
//    //    }
//
//    /// Registers PasswordCredentials against the AuthRealm.
//    open func register(credentials: Credentials) throws -> Account {
//
//        let account = AuthAccount()
//        let newAccount = AuthAccount()
//        newAccount.id(String(random.secureToken))
//
//        switch credentials {
//        case let credentials as UsernamePassword:
//            do {
//                if account.exists(credentials.username) {
//                    throw AccountTakenError()
//                }
//                newAccount.username = credentials.username
//                newAccount.password = credentials.password
//                do {
//                    try newAccount.make() // can't use save as the id is populated
//                } catch {
//                    print("REGISTER ERROR: \(error)")
//                }
//            } catch {
//                throw AccountTakenError()
//            }
//            //        case let credentials as FacebookAccount:
//            //            guard accounts.filter({$0.facebookID == credentials.uniqueID}).first == nil else {
//            //                throw AccountTakenError()
//            //            }
//            //            newAccount.facebookID = credentials.uniqueID
//            //        case let credentials as GoogleAccount:
//            //            guard accounts.filter({$0.googleID == credentials.uniqueID}).first == nil else {
//            //                throw AccountTakenError()
//            //            }
//        //            newAccount.googleID = credentials.uniqueID
//        default:
//            throw UnsupportedCredentialsError()
//        }
//        return newAccount
//    }
//}

/// The "Turnstile Realm" that holds the main routing functionality for request filters
open class AuthRealm : Realm {
    /// A container for the Random object fromTurnstile Crypto
    public var random: Random = URandom()
    
    public init() {}
    
    /// Used when a "Credentials" onject is passed to the authenticate function. Returns an Account object.
    open func authenticate(credentials: Credentials) throws -> Account {
        
        switch credentials {
        case let credentials as UsernamePassword:
            return try authenticate(credentials: credentials)
        case let credentials as AccessToken:
            return try authenticate(credentials: credentials)
            //        case let credentials as FacebookAccount:
            //            return try authenticate(credentials: credentials)
            //        case let credentials as GoogleAccount:
        //            return try authenticate(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
        
    }
    
    /// Used when an "AccessToken" onject is passed to the authenticate function. Returns an Account object.
    open func authenticate(credentials: AccessToken) throws -> Account {
        var account = AuthAccount()
        var token = AccessTokenStore()
        //        print(credentials.string)
        do {
            token = try token.get(credentials.string)
            if token.check() == false {
                throw IncorrectCredentialsError()
            }
            account = try account.get(token.userid)
            return account
        } catch {
            throw IncorrectCredentialsError()
        }
    }
    
    
    /// Used when a "UsernamePassword" onject is passed to the authenticate function. Returns an Account object.
    open func authenticate(credentials: UsernamePassword) throws -> Account {
        let account = AuthAccount()
        do {
            let thisAccount = try account.get(credentials.username, credentials.password)
            return thisAccount
        } catch {
            throw IncorrectCredentialsError()
        }
    }
    
    //    private func authenticate(credentials: FacebookAccount) throws -> Account {
    //        if let account = accounts.filter({$0.facebookID == credentials.uniqueID}).first {
    //            return account
    //        } else {
    //            return try register(credentials: credentials)
    //        }
    //    }
    //
    //    private func authenticate(credentials: GoogleAccount) throws -> Account {
    //        if let account = accounts.filter({$0.googleID == credentials.uniqueID}).first {
    //            return account
    //        } else {
    //            return try register(credentials: credentials)
    //        }
    //    }
    
    /// Registers PasswordCredentials against the AuthRealm.
    open func register(credentials: Credentials) throws -> Account {
        
        let account = AuthAccount()
        let newAccount = AuthAccount()
        newAccount.id(String(random.secureToken))
        
        switch credentials {
        case let credentials as UsernamePassword:
            do {
                if account.exists(credentials.username) {
                    throw AccountTakenError()
                }
                newAccount.username = credentials.username
                newAccount.password = credentials.password
                do {
                    try newAccount.make() // can't use save as the id is populated
                } catch {
                    print("REGISTER ERROR: \(error)")
                }
            } catch {
                throw AccountTakenError()
            }
            //        case let credentials as FacebookAccount:
            //            guard accounts.filter({$0.facebookID == credentials.uniqueID}).first == nil else {
            //                throw AccountTakenError()
            //            }
            //            newAccount.facebookID = credentials.uniqueID
            //        case let credentials as GoogleAccount:
            //            guard accounts.filter({$0.googleID == credentials.uniqueID}).first == nil else {
            //                throw AccountTakenError()
            //            }
        //            newAccount.googleID = credentials.uniqueID
        default:
            throw UnsupportedCredentialsError()
        }
        return newAccount
    }
}
