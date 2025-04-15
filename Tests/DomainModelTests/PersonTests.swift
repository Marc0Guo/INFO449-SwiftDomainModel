import XCTest
@testable import DomainModel

class PersonTests: XCTestCase {

    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }

    func testAgeRestrictions() {
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)

        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)

        matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(matt.spouse == nil)
    }

    func testAdultAgeRestrictions() {
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)

        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(mike.job != nil)

        mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(mike.spouse != nil)
    }
    
    func testPersonEmptyFirstName() {
        let person = Person(lastName: "Doe", age: 30)
        XCTAssertEqual(person.firstName, "")
        XCTAssertEqual(person.lastName, "Doe")
    }

    func testPersonEmptyLastName() {
        let person = Person(firstName: "John", age: 25)
        XCTAssertEqual(person.firstName, "John")
        XCTAssertEqual(person.lastName, "")
    }

    func testJobAssignmentExactlyAt16() {
        let teen = Person(firstName: "Tim", lastName: "Young", age: 16)
        let job = Job(title: "Cashier", type: .Hourly(10.0))
        teen.job = job
        XCTAssertNotNil(teen.job)
    }

    func testSpouseAssignmentExactlyAt18() {
        let adult = Person(firstName: "Anna", lastName: "Smith", age: 18)
        adult.spouse = Person(firstName: "Ben", lastName: "Lee", age: 20)
        XCTAssertNotNil(adult.spouse)
    }

    func testSpouseNotMutual() {
        let alice = Person(firstName: "Alice", lastName: "Jones", age: 30)
        let bob = Person(firstName: "Bob", lastName: "Smith", age: 30)
        
        alice.spouse = bob
        XCTAssertEqual(alice.spouse?.firstName, "Bob")
        XCTAssertNil(bob.spouse)
    }


    static var allTests = [
        ("testPerson", testPerson),
        ("testAgeRestrictions", testAgeRestrictions),
        ("testAdultAgeRestrictions", testAdultAgeRestrictions),
        ("testPersonEmptyFirstName", testPersonEmptyFirstName),
        ("testPersonEmptyLastName", testPersonEmptyLastName),
        ("testJobAssignmentExactlyAt16", testJobAssignmentExactlyAt16),
        ("testSpouseAssignmentExactlyAt18", testSpouseAssignmentExactlyAt18),
        ("testSpouseNotMutual", testSpouseNotMutual),
    ]
}

class FamilyTests : XCTestCase {
  
    func testFamily() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 1000)
    }

    func testFamilyWithKids() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))

        let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
        let _ = family.haveChild(mike)
        let _ = family.haveChild(matt)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 12000)
    }
    
    // Extra

    func testFirstName() {
        let person = Person(firstName: "A", age: 40)
        XCTAssertEqual(person.firstName, "A")
        XCTAssertEqual(person.lastName, "")
    }

    func testLastName() {
        let person = Person(lastName: "B", age: 60)
        XCTAssertEqual(person.firstName, "")
        XCTAssertEqual(person.lastName, "B")
    }
    
    func testUnderageParentsCannotHaveChild() {
        let teen1 = Person(firstName: "Teen1", age: 20)
        let teen2 = Person(firstName: "Teen2", age: 19)
        let family = Family(spouse1: teen1, spouse2: teen2)

        let baby = Person(firstName: "Baby", age: 0)
        let result = family.haveChild(baby)

        XCTAssertFalse(result)
        XCTAssertFalse(family.members.contains(where: { $0.firstName == "Baby" }))
    }

    func testDuplicateChild() {
        let p1 = Person(firstName: "Alex", age: 30)
        let p2 = Person(firstName: "Jamie", age: 30)
        let family = Family(spouse1: p1, spouse2: p2)

        let child = Person(firstName: "Taylor", age: 5)
        XCTAssertTrue(family.haveChild(child))
        XCTAssertTrue(family.haveChild(child))

        let count = family.members.filter { $0.firstName == "Taylor" }.count
        XCTAssertEqual(count, 2)
    }

    func testHouseholdIncomeNoJobs() {
        let p1 = Person(firstName: "NoJob1", age: 30)
        let p2 = Person(firstName: "NoJob2", age: 30)
        let family = Family(spouse1: p1, spouse2: p2)

        XCTAssertEqual(family.householdIncome(), 0.0)
    }

    func testSpouseLinksAreMutual() {
        let p1 = Person(firstName: "One", age: 30)
        let p2 = Person(firstName: "Two", age: 30)
        let _ = Family(spouse1: p1, spouse2: p2)

        XCTAssertEqual(p1.spouse?.firstName, "Two")
        XCTAssertEqual(p2.spouse?.firstName, "One")
    }



  
    static var allTests = [
        ("testFamily", testFamily),
        ("testFamilyWithKids", testFamilyWithKids),
        
        // Extra
        ("testFirstName", testFirstName),
        ("testLastName", testLastName),
        ("testUnderageParentsCannotHaveChild", testUnderageParentsCannotHaveChild),
        ("testDuplicateChild", testDuplicateChild),
        ("testHouseholdIncomeNoJobs", testHouseholdIncomeNoJobs),
        ("testSpouseLinksAreMutual", testSpouseLinksAreMutual),
    ]
}
