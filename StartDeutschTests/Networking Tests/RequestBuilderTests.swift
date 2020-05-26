//
//  RequestBuilderTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/13/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest

@testable import Start_Deutsch

class RequestBuilderTests: XCTestCase {
    
    var sut: RequestBuilderProtocol!

    override func setUp() {
        super.setUp()
        sut = RequestBuilder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testRequestBuilder_buildsTokenRequest(){

        // given
        let parameters = "grant_type=client_credentials"
        let postData =  parameters.data(using: .utf8)
        var tokenRequest = URLRequest(url: URL(string: "https://startdeutsch.org/oauth2/token/")!)
        
        tokenRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        tokenRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        tokenRequest.httpMethod = "POST"
        tokenRequest.httpBody = postData
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.postToken)
        
        // then
        XCTAssertEqual(tokenRequest.url, buildedRequest.url)
        XCTAssertEqual(tokenRequest.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(tokenRequest.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(tokenRequest.httpBody, buildedRequest.httpBody)
    }
    
    func testRequestBuilder_buildsGetCourseRequest(){
        // given
        var request = URLRequest(url: URL(string: "https://startdeutsch.org/api/v1/courses/")!)
        request.httpMethod = "GET"
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.getCourse)
        
        // then
        XCTAssertEqual(request.url, buildedRequest.url)
        XCTAssertEqual(request.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(request.httpBody, buildedRequest.httpBody)
    }
    
    func testRequestBuilder_buildsGetTestRequest(){
        // given
        var request = URLRequest(url: URL(string: "https://startdeutsch.org/api/v1/tests/?course_id=id1")!)
        request.httpMethod = "GET"
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.getTest(course_id: "id1"))
        
        // then
        XCTAssertEqual(request.url, buildedRequest.url)
        XCTAssertEqual(request.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(request.httpBody, buildedRequest.httpBody)
    }
    
    func testRequestBuilder_buildsGetListeningQuestionRequest(){
        // given
        var request = URLRequest(url: URL(string: "https://startdeutsch.org/api/v1/listening-questions/?test_id=id1")!)
        request.httpMethod = "GET"
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.getListeningQuestion(test_id: "id1"))
        
        // then
        XCTAssertEqual(request.url, buildedRequest.url)
        XCTAssertEqual(request.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(request.httpBody, buildedRequest.httpBody)
    }
    
    func testRequestBuilder_buildsGetReadingQuestionRequest(){
        // given
        var request = URLRequest(url: URL(string: "https://startdeutsch.org/api/v1/reading-questions/?test_id=id1")!)
        request.httpMethod = "GET"
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.getReadingQuestion(test_id: "id1"))
        
        // then
        XCTAssertEqual(request.url, buildedRequest.url)
        XCTAssertEqual(request.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(request.httpBody, buildedRequest.httpBody)
    }
    
    func testRequestBuilder_buildsGetWordRequest(){
        // given
        var request = URLRequest(url: URL(string: "https://startdeutsch.org/api/v1/words/")!)
        request.httpMethod = "GET"
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.getWord)
        
        // then
        XCTAssertEqual(request.url, buildedRequest.url)
        XCTAssertEqual(request.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(request.httpBody, buildedRequest.httpBody)
    }
    
    func testRequestBuilder_buildsGetCardRequest(){
        // given
        var request = URLRequest(url: URL(string: "https://startdeutsch.org/api/v1/cards/")!)
        request.httpMethod = "GET"
        
        // when
        let buildedRequest = sut.buildRequest(from: StartDeutschEndpoint.getCard)
        
        // then
        XCTAssertEqual(request.url, buildedRequest.url)
        XCTAssertEqual(request.allHTTPHeaderFields, buildedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpMethod, buildedRequest.httpMethod)
        XCTAssertEqual(request.httpBody, buildedRequest.httpBody)
    }

}
