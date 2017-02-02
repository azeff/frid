//
//  fridTests.swift
//  fridTests
//
//  Created by Evgeny Kazakov on 02/02/2017.
//  Copyright © 2017 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import frid

class fridTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
    frid.now = { Date() }
  }

  func testSameTimeOrder() {
    let time = Date()
    frid.now = { time }

    let id1 = frId()
    let id2 = frId()

    XCTAssertNotEqual(id1, id2, "ids for the same time should be different")
    XCTAssert(id1 < id2)
  }

  func testOrder() {
    let now = Date()

    let past = now.addingTimeInterval(-60)
    frid.now = { past }
    let idPast = frId()

    frid.now = { now }
    let idNow = frId()

    let future = now.addingTimeInterval(60)
    frid.now = { future }
    let idFuture = frId()

    XCTAssert(idPast < idNow, "'\(idPast)' should be less than '\(idNow)'")
    XCTAssert(idNow < idFuture, "'\(idNow)' should be less than '\(idFuture)'")
  }

}
