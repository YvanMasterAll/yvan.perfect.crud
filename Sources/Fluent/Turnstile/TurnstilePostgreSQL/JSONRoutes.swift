//
//  JSONRoutes.swift
//  PerfectTurnstilePostgreSQL
//
//  Created by Jonathan Guthrie on 2016-10-11.
//
//


import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache


/// Defines and returns the JSON API Authentication routes
public func makeJSONAuthRoutes(_ root: String = "/api/v1") -> Routes {
	var routes = Routes()

	//routes.add(method: .get, uri: "\(root)/", handler: AuthHandlersJSON.indexHandlerGet)

	//Authorization: Bearer [ACCESSTOKEN]


	/* =================================================================================================================
	Login
	================================================================================================================= */
	//routes.add(method: .get, uri: "\(root)/login", handler: AuthHandlers.loginHandlerGET)
	routes.add(method: .post, uri: "\(root)/login", handler: AuthHandlersJSON.loginHandlerPOST)
	/* =================================================================================================================
	/Login
	================================================================================================================= */





	/* =================================================================================================================
	Register
	================================================================================================================= */
	//routes.add(method: .get, uri: "\(root)/register", handler: AuthHandlers.registerHandlerGET)
	routes.add(method: .post, uri: "\(root)/register", handler: AuthHandlersJSON.registerHandlerPOST)
	/* =================================================================================================================
	/Register
	================================================================================================================= */





	/* =================================================================================================================
	Logout
	================================================================================================================= */
	routes.add(method: .get, uri: "\(root)/logout", handler: AuthHandlersJSON.logoutHandler)
	/* =================================================================================================================
	/Logout
	================================================================================================================= */




	/* =================================================================================================================
	Facebook Signin
	================================================================================================================= */
//	routes.add(method: .get, uri: "\(root)/login/facebook", handler: AuthHandlersJSON.facebookHandler)
//	routes.add(method: .get, uri: "\(root)/login/facebook/consumer", handler: AuthHandlersJSON.facebookHandlerConsumer)
	/* =================================================================================================================
	/Facebook Signin
	================================================================================================================= */






	/* =================================================================================================================
	Google Signin
	================================================================================================================= */
//	routes.add(method: .get, uri: "\(root)/login/google", handler: AuthHandlersJSON.googleHandler)
//	routes.add(method: .get, uri: "\(root)/login/google/consumer", handler: AuthHandlersJSON.googleHandlerConsumer)
	/* =================================================================================================================
	/Google Signin
	================================================================================================================= */
	
	
	
	
	return routes
}
