//
//  fridTests.swift
//  fridTests
//
//  Created by Evgeny Kazakov on 02/02/2017.
//  Copyright © 2017 Evgeny Kazakov. All rights reserved.
//

import Foundation
import XCTest
@testable import frid

class fridTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
    FrId.now = { Date() }
  }

  func testSameTimeOrder() {
    let time = Date()
    FrId.now = { time }

    let id1 = FrId.generate()
    let id2 = FrId.generate()

    XCTAssertNotEqual(id1, id2, "ids for the same time should be different")
    XCTAssert(id1 < id2)
  }

  func testOrder() {
    let now = Date()

    let past = now.addingTimeInterval(-60)
    FrId.now = { past }
    let idPast = FrId.generate()

    FrId.now = { now }
    let idNow = FrId.generate()

    let future = now.addingTimeInterval(60)
    FrId.now = { future }
    let idFuture = FrId.generate()

    XCTAssert(idPast < idNow, "'\(idPast)' should be less than '\(idNow)'")
    XCTAssert(idNow < idFuture, "'\(idNow)' should be less than '\(idFuture)'")
  }

}

extension fridTests {
  static var allTests: [(String, (fridTests) -> () throws -> Void )] {
    return [
      ("testSameTimeOrder", testSameTimeOrder),
      ("testOrder", testOrder)
    ]
  }
}
