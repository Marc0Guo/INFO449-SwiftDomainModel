struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    public let amount: Int
    public let currency: String
    
    static let validCurrencies = ["USD", "GBP", "EUR", "CAN"]
    static let toUSD: [String: Double] = [
        "USD": 1.0,
        "GBP": 2.0,
        "EUR": 2.0/3.0,
        "CAN": 0.8
    ] // 1 Money = x USD
    
    static let fromUSD: [String: Double] = [
        "USD": 1.0,
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25
    ] // 1 USD = x Money

    public init(amount: Int, currency: String) {
        guard Money.validCurrencies.contains(currency) else {
            fatalError("Unknown currency: \(currency)")
        }
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ curr: String) -> Money {
        guard Money.validCurrencies.contains(curr) else {
            fatalError("Unknown currency: \(curr)")
        }
        
        let usdAmount = Double(self.amount) * Money.toUSD[self.currency]!
        let actualAmount = usdAmount * Money.fromUSD[curr]!
        
        return Money(amount: Int(actualAmount.rounded()), currency: curr)
    }
    
    func add(_ other: Money) -> Money {
        let selfInUSD = Double(self.amount) * Money.toUSD[self.currency]!
        let otherInUSD = Double(other.amount) * Money.toUSD[other.currency]!
        let totalInUSD = selfInUSD + otherInUSD
        
        let resultAmount = totalInUSD * Money.fromUSD[other.currency]!
        return Money(amount: Int(resultAmount), currency: other.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }

    public var title: String
    public var type: JobType

    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let hourlyWage):
            return Int(hourlyWage * Double(hours))
        case .Salary(let salary):
            return Int(salary)
        }
    }

    public func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage + amount)
        case .Salary(let salary):
            type = .Salary(salary + UInt(amount))
        }
    }

    public func raise(byPercent percent: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage * (1.0 + percent))
        case .Salary(let salary):
            let increased = Double(salary) * (1.0 + percent)
            type = .Salary(UInt(increased))
        }
    }
    
    // Extra
    public func convert() {
        switch type {
        case .Hourly(let rate):
            let estimatedSalary = Int(rate * 2000)
            let roundedUp = ((estimatedSalary + 999) / 1000) * 1000
            type = .Salary(UInt(roundedUp))
        case .Salary:
            break
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName: String
    public var lastName: String
    public var age: Int

    private var _job: Job?
    public var job: Job? {
        get {
            return _job
        }
        set {
            if age >= 16 {
                _job = newValue
            }
        }
    }

    private var _spouse: Person?
    public var spouse: Person? {
        get {
            return _spouse
        }
        set {
            if age >= 18 {
                _spouse = newValue
            }
        }
    }

    public init(firstName: String = "", lastName: String = "", age: Int) {
        precondition(!firstName.isEmpty || !lastName.isEmpty, "Person must have at least a first or last name")
        
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    public func toString() -> String {
        let jobDesc = job.map {
            switch $0.type {
            case .Hourly(let wage): return "Hourly(\(wage))"
            case .Salary(let salary): return "Salary(\(salary))"
            }
        } ?? "nil"

        let spouseDesc = spouse?.firstName ?? "nil"
        let fullName = [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")

        return "[Person: name:\(fullName) age:\(age) job:\(jobDesc) spouse:\(spouseDesc)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    public var members: [Person]

    public init(spouse1: Person, spouse2: Person) {

        spouse1.spouse = spouse2
        spouse2.spouse = spouse1

        self.members = [spouse1, spouse2]
    }
    
    public func haveChild(_ child: Person) -> Bool {
        let spouse1 = members[0]
        let spouse2 = members[1]
        
        if spouse1.age > 21 || spouse2.age > 21 {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    public func householdIncome() -> Double {
        var totalIncome: Double = 0.0
        for person in members {
            if let job = person.job {
                totalIncome += Double(job.calculateIncome(2000))
            }
        }
        return totalIncome
    }
}
