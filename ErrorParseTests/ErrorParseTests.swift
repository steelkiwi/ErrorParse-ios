//
//  ErrorParseTests.swift
//  ErrorParseTests
//
//  Created by Viktor Olesenko on 13.03.17.
//  Copyright © 2017 Viktor Olesenko. All rights reserved.
//

import XCTest
@testable import ErrorParse

private typealias JSON = Dictionary<String, Any>

private enum Key: String {
    case correct
    case wrong1
    case wrong2
    case wrong3
    
    case errorCorrect
    case errorEmpty = ""
}

class ErrorParseTests: XCTestCase {
    
    func testExample1() {
        
        let error = [
            Key.correct.rawValue : Key.errorCorrect.rawValue,
            Key.wrong1.rawValue  : Key.errorEmpty.rawValue
        ]
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample2() {
        
        let error = [Key.correct.rawValue : [Key.errorEmpty.rawValue,
                                             Key.errorCorrect.rawValue,
                                             Key.errorEmpty.rawValue]
        ]
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample3() {
        
        let error = [
            Key.correct.rawValue : [Key.errorCorrect.rawValue, Key.errorEmpty.rawValue],
            Key.wrong1.rawValue  : [Key.errorEmpty.rawValue,   Key.errorEmpty.rawValue]
        ]
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample4() {
        
        let error = [
            [Key.wrong1.rawValue  : Key.errorEmpty.rawValue],
            [Key.correct.rawValue : Key.errorCorrect.rawValue],
            [Key.wrong2.rawValue  : Key.errorEmpty.rawValue]
        ]
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample5() {
        
        let error = [
            [:],
            [Key.correct.rawValue : [Key.errorCorrect.rawValue, Key.errorEmpty.rawValue]],
            [:]
            ] as [JSON]
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample6() {
        
        let error = [
            Key.wrong1.rawValue : Key.errorEmpty.rawValue,
            Key.wrong2.rawValue : Key.errorEmpty.rawValue,
            Key.wrong3.rawValue : [
                Key.correct.rawValue : Key.errorCorrect.rawValue,
                Key.wrong2.rawValue  : Key.errorEmpty.rawValue
            ]
            ] as JSON
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample7() {
        
        let error = [
            Key.correct.rawValue : [Key.errorCorrect.rawValue, Key.errorEmpty.rawValue],
            Key.wrong1.rawValue  : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
            Key.wrong2.rawValue  : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
            Key.wrong3.rawValue  : [
                Key.wrong1.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
                Key.wrong2.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
                Key.wrong3.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue]
            ]
            ] as JSON
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample8() {
        
        let error = [
            Key.wrong1.rawValue : Key.errorEmpty.rawValue,
            Key.wrong2.rawValue : Key.errorEmpty.rawValue,
            Key.wrong3.rawValue : [
                [
                    Key.wrong1.rawValue : Key.errorEmpty.rawValue,
                    Key.wrong2.rawValue : Key.errorEmpty.rawValue
                ],
                [
                    Key.wrong1.rawValue  : Key.errorEmpty.rawValue,
                    Key.correct.rawValue : Key.errorCorrect.rawValue
                ]
            ]
            ] as JSON
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
    
    func testExample9() {
        
        let error = [
            Key.wrong1.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
            Key.wrong2.rawValue : [
                [
                    Key.wrong1.rawValue  : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
                    Key.correct.rawValue : [Key.errorEmpty.rawValue, Key.errorCorrect.rawValue],
                    Key.wrong3.rawValue  : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue]
                ],
                [
                    Key.wrong1.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
                    Key.wrong2.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue],
                    Key.wrong3.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue]
                ]
            ],
            Key.wrong3.rawValue : [Key.errorEmpty.rawValue, Key.errorEmpty.rawValue]
            ] as JSON
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        
        let parsedError = APIErrorParser.parse(errorData)
        
        XCTAssertNotNil(parsedError.field)
        XCTAssertEqual(Key.correct.rawValue, parsedError.field)
        XCTAssertEqual(Key.errorCorrect.rawValue, parsedError.error.localizedDescription)
    }
}
