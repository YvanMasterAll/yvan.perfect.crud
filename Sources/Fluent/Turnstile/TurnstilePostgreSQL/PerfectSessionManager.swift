//
//  PerfectSessionManager.swift
//  PerfectTurnstilePostgreSQL
//
//  Created by Jonathan Guthrie on 2016-10-19.
//
//

import Foundation

/// PerfectSessionManager manages sessions via PostgreSQL storage
open class PerfectSessionManager: SessionManager {
	public let random: Random = URandom()

	public init() {}

	/// Creates a session for a given Subject object and returns the identifier.
	public func createSession(account: Account) -> String {
		let identifier = tokenStore?.new(account.uniqueID)
		return identifier!
	}

	/// Deletes the session for a session identifier.
	public func destroySession(identifier: String) {
		let token = AccessTokenStore()
		do {
			try token.delete(identifier)
		} catch {
			print(error)
		}
	}

	/// Creates a Session-backed Account object from the Session store. This only contains the SessionID.
	public func restoreAccount(fromSessionID identifier: String) throws -> Account {
		var token = AccessTokenStore()
		do {
			token = try token.get(identifier)
			guard token.check()! else { throw InvalidSessionError() }
			return SessionAccount(uniqueID: token.userid)
		} catch {
			print("Error... \(error)")
			throw InvalidSessionError()
		}
	}
}
