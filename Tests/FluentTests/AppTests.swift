import XCTest
import class Foundation.Bundle
import Fluent

final class AppTests: BaseTestCase {
    
    // Test Fluent
    func testFluent() throws {
        let db = Database(configuration: try PostgresDatabaseConfiguration(database: "test_postgres", host: "localhost", port: nil, username: "test_postgres", password: nil))
        
        //try db.create(Record2.self, policy: .reconcileTable)
        //try db.create(Student2.self, policy: .reconcileTable)
        //try db.create(Book2.self, policy: .reconcileTable)
        
        let table_student = db.table(Student2.self)
        
        do {
//            //data test
//            let stu1 = Student2(id: 1, name: "小明", books: nil)
//            let stu2 = Student2(id: 2, name: "小红", books: nil)
//            let stu3 = Student2(id: 3, name: "小易", books: nil)
//            let stu4 = Student2(id: 4, name: "小结", books: nil)
//            let bk1 = Book2(id: 1, name: "射雕英雄传", students: nil)
//            let bk2 = Book2(id: 2, name: "神雕侠女", students: nil)
//            let bk3 = Book2(id: 3, name: "新白娘子", students: nil)
//            let bk4 = Book2(id: 4, name: "葵花宝典", students: nil)
//            let rd1 = Record2(id: 1, bkid: 1, stuid: 1, time: Date())
//            let rd2 = Record2(id: 2, bkid: 1, stuid: 2, time: Date())
//            let rd3 = Record2(id: 3, bkid: 1, stuid: 3, time: Date())
//            let rd4 = Record2(id: 4, bkid: 1, stuid: 4, time: Date())
//            let rd5 = Record2(id: 5, bkid: 2, stuid: 2, time: Date())
//            let rd6 = Record2(id: 6, bkid: 2, stuid: 3, time: Date())
//            let rd7 = Record2(id: 7, bkid: 3, stuid: 4, time: Date())
//            let rd8 = Record2(id: 8, bkid: 4, stuid: 1, time: Date())
//
//            try db.table(Student2.self).insert([stu1, stu2, stu3, stu4])
//            try db.table(Book2.self).insert([bk1, bk2, bk3, bk4])
//            try db.table(Record2.self).insert([rd1, rd2, rd3, rd4, rd5, rd6, rd7, rd8])
        }
        
        //join test
        let query = try table_student
            .order(by: \.id)
            .join(\.books,
                  with: Record2.self,
                  on: \.id,
                  equals: \.stuid,
                  and: \.id,
                  is: \.bkid)
            .order(by: \.name)
            .where(\Student2.name != "")
            .select()

        for q in query {
            guard let books = q.books else {
                continue
            }
            print("\(q.name)借过的书籍:")
            for book in books {
                print(book.name)
            }
            print("---------------------")
        }
        
        //insert test
        do {
            //try table_student.insert(Student.init(id: -1, name: "小林", books: nil), ignoreKeys: \Student.id)
            //try db.table(Book.self).insert(Book.init(id: -1, name: "笑傲江湖", students: nil), ignoreKeys: \Book.id)
        } catch {
            
        }
        
        print("hello")
    }
}

struct Student2: Codable, TableNameProvider {
    static var tableName: String = "student2"
    let id: Int
    let name: String
    let books: [Book2]?
}

struct Book2: Codable {
    let id: Int
    let name: String
    let students: [Student2]?
}

struct Record2: Codable {
    let id: Int
    let bkid: Int
    let stuid: Int
    let time: Date
}
