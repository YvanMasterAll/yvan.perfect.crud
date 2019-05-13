// swift-tools-version:4.0
// Generated automatically by Perfect Assistant
// Date: 2019-02-21 04:02:35 +0000

import PackageDescription

let package = Package(
	name: "Test_Postgres2",
	products: [
        .library(name: "Fluent", targets: ["Fluent"]),
    ],
	dependencies: [
        .package(url: "https://github.com/iamjono/JSONConfig.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/SwiftORM/Postgres-StORM.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", from: "3.0.2"), 
		.package(url: "https://github.com/iamjono/SwiftString.git", from: "2.0.0")
	],
	targets: [
		.target(name: "Fluent", dependencies: [
			"JSONConfig", 				//文件解析
			"PerfectHTTPServer",		//HTTP服务
			"PostgresStORM", 			//PostgreSQL ORM
			"PerfectMustache",			//模板引擎
			"SwiftString"
			]),
		.target(name: "App", dependencies: ["Fluent"]),
        .testTarget(name: "FluentTests", dependencies: ["Fluent"])
	]
)