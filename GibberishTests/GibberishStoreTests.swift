//
//  GibberishStoreTests.swift
//  GibberishTests
//
//  Created by Gero Herkenrath on 27.02.21.
//

import XCTest
@testable import Gibberish

class GibberishStoreTests: XCTestCase {

    var underTest: GibberishStore!

    var mockLoader: MockLoader!
    var testItem: GibberishJsonModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockLoader = MockLoader()
        testItem = GibberishJsonModel(icon: "sun.max.fill", label: "TestName", text: "TestText", minWordCount: 1, maxWordCount: 10)

        underTest = GibberishStore()
        underTest.gibberishLoader = mockLoader
    }

    func test_loadMore_changesIsLoadingAndProperlyParsesResponse() throws {
        let didCallDownload = expectation(description: "did invoke download on loader")
        mockLoader.injectDownloadResponse = { [unowned self] in
            didCallDownload.fulfill()
            XCTAssertTrue(underTest.isLoading)
            XCTAssertTrue(underTest.items.isEmpty)
            return .goodResponse(testItem)
        }

        let isLoadingChanged = expectation(description: "did change value of isLoading")
        isLoadingChanged.expectedFulfillmentCount = 3 // the first value before chaning also "flows" into this sink!
        var nextExpectedState = false
        let subscriber = underTest.$isLoading.sink { newValue in
            XCTAssertEqual(newValue, nextExpectedState)
            nextExpectedState = !nextExpectedState
            isLoadingChanged.fulfill()
        }

        XCTAssertFalse(underTest.isLoading)
        XCTAssertTrue(underTest.items.isEmpty)
        underTest.loadMore()
        wait(for: [didCallDownload, isLoadingChanged], timeout: 1.0)
        subscriber.cancel()

        XCTAssertFalse(underTest.isLoading)
        // note: Just making GibberishStore.Element equatable and compare against an expected value won't work due to the 'id' field
        XCTAssertEqual(underTest.items.count, 1)
        XCTAssertEqual(underTest.items[0].iconName, testItem.icon)
        XCTAssertEqual(underTest.items[0].author, testItem.label)
        XCTAssertEqual(underTest.items[0].text, testItem.text)
    }
}

// MARK: - Test Helpers, Mocks, etc.
extension GibberishStoreTests {

    class MockLoader: GibberishLoading { // note this is a class!

        var injectDownloadResponse: () -> GibberishLoadingResponse = { return .badResponse }
        func download(onCompletion: @escaping (GibberishLoadingResponse) -> Void) {
            let response = injectDownloadResponse()
            DispatchQueue.main.async {
                onCompletion(response)
            }
        }
    }
}
