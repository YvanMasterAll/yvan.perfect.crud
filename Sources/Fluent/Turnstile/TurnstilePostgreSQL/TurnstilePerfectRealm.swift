//
//  TurnstilePerfectSQLite.swift
//  TurnstilePerfect
//
//  Created by Jonathan Guthrie on 2016-10-17.
//
//

import PerfectHTTP

public class TurnstilePerfectRealm {
	public var requestFilter: (HTTPRequestFilter, HTTPFilterPriority)
	public var responseFilter: (HTTPResponseFilter, HTTPFilterPriority)

	private let turnstile: Turnstile

	public init(sessionManager: SessionManager = PerfectSessionManager(), realm: Realm = AuthRealm()) {
		turnstile = Turnstile(sessionManager: sessionManager, realm: realm)
		let filter = TurnstileFilter(turnstile: turnstile)

		requestFilter = (filter, HTTPFilterPriority.high)
		responseFilter = (filter, HTTPFilterPriority.high)
	}
}
