import Fluent
import PerfectLib
import StORM
import PerfectHTTPServer
import PerfectHTTP
import Foundation

let baseRoute           = "/api/v1"
let baseDBHost          = "localhost"
let baseServerPort      = 8181
let baseDBPort          = 5432
let baseDBUsername      = "test_postgres"
let baseDBPassword      = ""
let baseDBName          = "test_postgres"
let baseURL             = "http://192.168.1.6:8181"
let baseDomain          = ""
let baseDocument        = "webroot"

public func app() -> HTTPServer {
    //MARK: - 创建服务
    let server = HTTPServer()
    
    //MARK: - 查询日志
    StORMdebug = true
    
    //MARK: - 环境初始化
    postgresConnector = try! PostgresDatabaseConfiguration(database: baseDBName,
                                                           host: baseDBHost,
                                                           port: baseDBPort,
                                                           username: baseDBUsername,
                                                           password: nil)
    
    do {
        try postgresDB.create(AuthAccount.self)
        try postgresDB.create(AccessTokenStore.self)
        tokenStore = AccessTokenStore()
        try postgresDB.create(Record.self, policy: .reconcileTable) //递归的方式创建表
        
        //测试Model方法, delete方法类似
        if let student = try Student().get(by: \Student.id == 2) {
            CRUDLogging.log(.info, "测试Model.get方法, delete方法类似")
            print("\(student.id):\(student.name):\(student.gender.value)")
        }
        
        //测试视图, 支持视图查询
        let v_test = TestView()
        let query = try v_test.db().select()
        for q in query {
            print("\(q.id):\(q.name)")
        }
        
        //测试数据
//        let stu1 = Student(id: 1, name: "小明", gender: .male)
//        let stu2 = Student(id: 2, name: "小红", gender: .female)
//        let stu3 = Student(id: 3, name: "小易", gender: .male)
//        let stu4 = Student(id: 4, name: "小结", gender: .male)
//        let bk1 = Book(id: 1, name: "射雕英雄传")
//        let bk2 = Book(id: 2, name: "神雕侠女")
//        let bk3 = Book(id: 3, name: "新白娘子")
//        let bk4 = Book(id: 4, name: "葵花宝典")
//        let rd1 = Record(id: 1, bkid: 1, stuid: 1, time: Date())
//        let rd2 = Record(id: 2, bkid: 1, stuid: 2, time: Date())
//        let rd3 = Record(id: 3, bkid: 1, stuid: 3, time: Date())
//        let rd4 = Record(id: 4, bkid: 1, stuid: 4, time: Date())
//        let rd5 = Record(id: 5, bkid: 2, stuid: 2, time: Date())
//        let rd6 = Record(id: 6, bkid: 2, stuid: 3, time: Date())
//        let rd7 = Record(id: 7, bkid: 3, stuid: 4, time: Date())
//        let rd8 = Record(id: 8, bkid: 4, stuid: 1, time: Date())
//
//        try Student().db().insert([stu1, stu2, stu3, stu4])
//        try Book().db().insert([bk1, bk2, bk3, bk4])
//        try Record().db().insert([rd1, rd2, rd3, rd4, rd5, rd6, rd7, rd8])
    } catch {
        print(error)
    }
    
    // Register routes and handlers
    let authWebRoutes = makeWebAuthRoutes()
    let authJSONRoutes = makeJSONAuthRoutes("/api/v1")
    
    // Add the routes to the server.
    server.addRoutes(authWebRoutes)
    server.addRoutes(authJSONRoutes)
    
    // Adding a test route
    var routes = Routes()
    routes.add(method: .get, uri: "/api/v1/test", handler: AuthHandlersJSON.testHandler)
    
    // An example route where authentication will be enforced
    routes.add(method: .get, uri: "/api/v1/check", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        var resp = [String: String]()
        resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
        resp["SessionID"] = "SessionID: \(request.user.authDetails?.account.uniqueID ?? "")"
        
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.completed()
    })
    
    // An example route where auth will not be enforced
    routes.add(method: .get, uri: "/api/v1/nocheck", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        var resp = [String: String]()
        resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
        resp["authDetails"] = "DETAILS: \(request.user.authDetails!)"
        
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.completed()
    })
    
    // 测试table join, 三表
    routes.add(method: .get, uri: "/api/v1/record", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        do {
            let student = Student()
            try student.records()
            CRUDLogging.log(.info, "这是一条测试日志.")
            try response.setBody(json: student.toDicts().map { d -> [String: Any] in
                var _d = d
                _d["code"] = "abcdefghij"[0..<Int(arc4random()%10)]
                return _d
            })
        } catch {
            print(error)
        }
        response.completed()
    })
    
    // 测试插入数据
    routes.add(method: .get, uri: "/api/v1/addbook", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        guard let name = request.param(name: "name") else {
            response.setBody(string: "请添加书籍名称.")
            response.completed()
            return
        }
        
        do {
            let book = Book()
            book.name = name
            try book.add()
            response.setBody(string: "书籍添加成功: \(name).")
        } catch {
            print(error)
        }
        response.completed()
    })
    routes.add(method: .get, uri: "/api/v1/addstudent", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        guard let name = request.param(name: "name") else {
            response.setBody(string: "请添加学生名称.")
            response.completed()
            return
        }
        
        do {
            let student = Student()
            student.name = name
            student.gender = .female
            try student.add()
            response.setBody(string: "学生添加成功: \(name).")
        } catch {
            print(error)
        }
        response.completed()
    })
    
    //测试更新数据
    routes.add(method: .get, uri: "/api/v1/updatestu", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        guard let id = request.param(name: "id")?.toInt() else {
            response.setBody(string: "请添加学生ID.")
            response.completed()
            return
        }
        guard let name = request.param(name: "name") else {
            response.setBody(string: "请添加学生名称.")
            response.completed()
            return
        }
        
        do {
            let student = Student()
            student.id = id
            student.name = name
            try student.update()
            response.setBody(string: "学生修改成功: \(name).")
        } catch {
            print(error)
        }
        response.completed()
    })
    
    // Add the routes to the server.
    server.addRoutes(routes)
    
    // add routes to be checked for auth
    var authenticationConfig = AuthenticationConfig()
    authenticationConfig.include("/api/v1/check")
    authenticationConfig.exclude("/api/v1/login")
    authenticationConfig.exclude("/api/v1/register")
    authenticationConfig.exclude("/api/v1/record")
    authenticationConfig.exclude("/api/v1/addbook")
    authenticationConfig.exclude("/api/v1/addstudent")
    authenticationConfig.exclude("/api/v1/updatestu")
    
    let authFilter = AuthFilter(authenticationConfig)
    
    // Note that order matters when the filters are of the same priority level
    let pturnstile = TurnstilePerfectRealm()
    server.setRequestFilters([pturnstile.requestFilter])
    server.setResponseFilters([pturnstile.responseFilter])
    server.setRequestFilters([(authFilter, .high)])
    
    //MARK: - 启动服务
    server.serverPort = UInt16(baseServerPort)
    server.documentRoot = baseDocument
    
    return server
}

do {
    try app().start()
} catch PerfectError.networkError(let err, let msg) {
    print("网络异常: \(err) \(msg)")
}
