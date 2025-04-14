import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
    // Extra test
    func testConvertNothing() {
        let job = Job(title: "test1", type: .Salary(10000))
        job.convert()
        
        switch job.type {
        case .Salary(let salary):
            XCTAssertEqual(salary, 10000)
        default:
            XCTFail("Job should remain a Salary type")
        }
    }
    func testConvertExact() {
        let job = Job(title: "test2", type: .Hourly(20.0))
        job.convert()
        
        switch job.type {
        case .Salary(let salary):
            XCTAssertEqual(salary, 40000)
        default:
            XCTFail("Expected job type to be Salary")
        }
    }
    
    func testConvertRound(){
        let job = Job(title: "test3", type: Job.JobType.Hourly(21.75))
        job.convert()
        
        switch job.type {
        case .Salary(let salary):
            XCTAssertEqual(salary, 44000)
        default:
            XCTFail("Expected Salary job type after conversion")
        }
        // 43500 -> 44000
    }
  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        
        // Extra
        ("testConvertNothing", testConvertNothing),
        ("testConvertExact", testConvertExact),
        ("testConvertRound", testConvertRound),
    ]
}
