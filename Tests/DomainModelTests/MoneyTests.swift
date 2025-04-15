import XCTest
@testable import DomainModel

class MoneyTests: XCTestCase {
  
  let tenUSD = Money(amount: 10, currency: "USD")
  let twelveUSD = Money(amount: 12, currency: "USD")
  let fiveGBP = Money(amount: 5, currency: "GBP")
  let fifteenEUR = Money(amount: 15, currency: "EUR")
  let fifteenCAN = Money(amount: 15, currency: "CAN")
    
  func testCanICreateMoney() {
    let oneUSD = Money(amount: 1, currency: "USD")
    XCTAssert(oneUSD.amount == 1)
    XCTAssert(oneUSD.currency == "USD")
    
    let tenGBP = Money(amount: 10, currency: "GBP")
    XCTAssert(tenGBP.amount == 10)
    XCTAssert(tenGBP.currency == "GBP")
  }
  
  func testUSDtoGBP() {
    let gbp = tenUSD.convert("GBP")
    XCTAssert(gbp.currency == "GBP")
    XCTAssert(gbp.amount == 5)
  }
  func testUSDtoEUR() {
    let eur = tenUSD.convert("EUR")
    XCTAssert(eur.currency == "EUR")
    XCTAssert(eur.amount == 15)
  }
  func testUSDtoCAN() {
    let can = twelveUSD.convert("CAN")
    XCTAssert(can.currency == "CAN")
    XCTAssert(can.amount == 15)
  }
  func testGBPtoUSD() {
    let usd = fiveGBP.convert("USD")
    XCTAssert(usd.currency == "USD")
    XCTAssert(usd.amount == 10)
  }
  func testEURtoUSD() {
    let usd = fifteenEUR.convert("USD")
    XCTAssert(usd.currency == "USD")
    XCTAssert(usd.amount == 10)
  }
  func testCANtoUSD() {
    let usd = fifteenCAN.convert("USD")
    XCTAssert(usd.currency == "USD")
    XCTAssert(usd.amount == 12)
  }
  
  func testUSDtoEURtoUSD() {
    let eur = tenUSD.convert("EUR")
    let usd = eur.convert("USD")
    XCTAssert(tenUSD.amount == usd.amount)
    XCTAssert(tenUSD.currency == usd.currency)
  }
  func testUSDtoGBPtoUSD() {
    let gbp = tenUSD.convert("GBP")
    let usd = gbp.convert("USD")
    XCTAssert(tenUSD.amount == usd.amount)
    XCTAssert(tenUSD.currency == usd.currency)
  }
  func testUSDtoCANtoUSD() {
    let can = twelveUSD.convert("CAN")
    let usd = can.convert("USD")
    XCTAssert(twelveUSD.amount == usd.amount)
    XCTAssert(twelveUSD.currency == usd.currency)
  }
  
  func testAddUSDtoUSD() {
    let total = tenUSD.add(tenUSD)
    XCTAssert(total.amount == 20)
    XCTAssert(total.currency == "USD")
  }
  
  func testAddUSDtoGBP() {
    let total = tenUSD.add(fiveGBP)
    XCTAssert(total.amount == 10)
    XCTAssert(total.currency == "GBP")
  }
    
    // Extra
    
    func testAddRounding() {
        let usd = Money(amount: 5, currency: "USD")
        let eur = Money(amount: 1, currency: "EUR")
        let result = usd.add(eur)
        XCTAssertEqual(result.amount, 8)
        XCTAssertEqual(result.currency, "EUR")
    }
    
    func testSubtract() {
        let first = Money(amount: 24, currency: "USD")
        let second = Money(amount: 15, currency: "CAN")
        let result = first.subtract(second)
        XCTAssertEqual(result.amount, 15)
        XCTAssertEqual(result.currency, "CAN")
    }
    
    func testSubtractZero() {
        let first = Money(amount: 5, currency: "USD")
        let second = Money(amount: 5, currency: "USD")
        let result = first.subtract(second)
        XCTAssertEqual(result.amount, 0)
        XCTAssertEqual(result.currency, "USD")
    }
    
    func testSubtractNegative() {
        let smallAmount = Money(amount: 5, currency: "USD")
        let largeAmount = Money(amount: 10, currency: "USD")
        let result = smallAmount.subtract(largeAmount)
        XCTAssertEqual(result.amount, -5)
        XCTAssertEqual(result.currency, "USD")
    }

    func testAddZero() {
        let zeroUSD = Money(amount: 0, currency: "USD")
        let result = zeroUSD.add(Money(amount: 10, currency: "USD"))
        XCTAssertEqual(result.amount, 10)
        XCTAssertEqual(result.currency, "USD")
    }
    
    func testSameCurrency() {
        let money = Money(amount: 10, currency: "EUR")
        let result = money.convert("EUR")
        XCTAssertEqual(result.amount, 10)
        XCTAssertEqual(result.currency, "EUR")
    }
    

    

    static var allTests = [
        ("testCanICreateMoney", testCanICreateMoney),

        ("testUSDtoGBP", testUSDtoGBP),
        ("testUSDtoEUR", testUSDtoEUR),
        ("testUSDtoCAN", testUSDtoCAN),
        ("testGBPtoUSD", testGBPtoUSD),
        ("testEURtoUSD", testEURtoUSD),
        ("testCANtoUSD", testCANtoUSD),
        ("testUSDtoEURtoUSD", testUSDtoEURtoUSD),
        ("testUSDtoGBPtoUSD", testUSDtoGBPtoUSD),
        ("testUSDtoCANtoUSD", testUSDtoCANtoUSD),
        
        ("testAddUSDtoUSD", testAddUSDtoUSD),
        ("testAddUSDtoGBP", testAddUSDtoGBP),
        
        // Extra
        ("testAddRounding", testAddRounding),
        ("testSubtract", testSubtract),
        ("testSubtractZero", testSubtractZero),
        ("testSubtractNegative", testSubtractNegative),
        ("testAddZero", testAddZero),
        ("testSameCurrency", testSameCurrency),
        
    ]
}

