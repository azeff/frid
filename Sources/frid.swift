//
//  frid.swift
//  frid
//
//  Created by Evgeny Kazakov on 02/02/2017.
//  Copyright © 2017 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct FrId {

  private init() { }
  
  /// Provides current date. Needed for testing.
  internal static var now: () -> Date = { Date() }
 
  /// Fancy ID generator that creates 20-character string identifiers with the following properties:
  ///
  /// 1. They're based on timestamp so that they sort *after* any existing ids.
  /// 2. They contain 72-bits of random data after the timestamp so that IDs won't collide with other clients' IDs.
  /// 3. They sort *lexicographically* (so the timestamp is converted to characters that will sort properly).
  /// 4. They're monotonically increasing. Even if you generate more than one in the same timestamp, the
  ///    latter ones will sort after the former ones. We do this by using the previous random bits
  ///    but "incrementing" them by 1 (only in the case of a timestamp collision).
  ///
  /// - Returns: generated id
  public static func generate() -> String {
    
    let nowMilliseconds = UInt64(now().timeIntervalSince1970 * 1000)
    defer { lastMilliseconds = nowMilliseconds }
    
    // Convert timestamp to characters from alphabet.
    let timeStampChars = (0...7)
      .reversed()
      .map { (shiftMultiplier: Int) -> UInt64 in nowMilliseconds >> UInt64(6 * shiftMultiplier) }
      .map { (rnd: UInt64) -> Int in Int(rnd % 64) }
      .map { (index: Int) -> Character in alphabetCharacters[index] }
    
    let duplicateTime = nowMilliseconds == lastMilliseconds
    // If the timestamp hasn't changed since last generation, use the same random number, except incremented by 1.
    randomCharactersIndexes = duplicateTime ? inc(randomCharactersIndexes) : generateNewRandomIndexes()
    
    let randomCharacters = randomCharactersIndexes.map { alphabetCharacters[$0] }
    
    let idCharacters = timeStampChars + randomCharacters
    
    return String(idCharacters)
  }
}

/// Modeled after base64 web-safe chars, but ordered by ASCII.
private let alphabet = "-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz"
private let alphabetCharacters = [Character](alphabet.characters)

/// Timestamp of last generation, used to prevent local collisions if you generate twice in one ms.
private var lastMilliseconds: UInt64 = 0

/// We generate 72-bits of randomness which get turned into 12 characters and appended to the
/// timestamp to prevent collisions with other clients.  We store the last characters we
/// generated because in the event of a collision, we'll use those same characters except
/// "incremented" by one.
private var randomCharactersIndexes: [Int] = generateNewRandomIndexes()

private func generateNewRandomIndexes() -> [Int] {
  return (0...11).map { _ in Int(arc4random_uniform(64)) }
}

/// Increment random number by 1.
/// Number is presented in form of array of 'digits'.
/// Base == `alphabetCharacters.count`
///
/// - Parameter rnd: random number
/// - Returns: incremented
private func inc(_ rnd: [Int]) -> [Int] {
  let base = alphabetCharacters.count
  var incremented = rnd
  var index = incremented.count - 1
  while incremented[index] == base - 1 {
    incremented[index] = 0
    index -= 1
  }
  incremented[index] += 1
  return incremented
}
