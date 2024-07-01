//
//  ProductRepositoryTests.swift
//  KpNewProjectCleanTests
//
//  Created by N Krishna Prakash on 20/06/24.
//

import XCTest
import Combine

class MockProductRepositoryImpl: ProductsRepository {
    
    var fetchCompletionCallsCount = 0
    var result: AnyPublisher<[Company], Error>!
    func fetchAllProducts() -> AnyPublisher<[Company], Error> {
        fetchCompletionCallsCount += 1
        return result
    }
}

final class ProductRepositoryTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var repository: ProductsRepositoryImpl!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = []
        repository = ProductsRepositoryImpl(productsService: MockProductService(networkService: MockNetworkService()));
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = nil
        repository = nil
    }
    
    func testAPICallCount() {
        let companies = [
            Company(id: "1", name: "Tech Innovators Inc.", logo: "https://example.com/logos/tech_innovators.png", products: [
                Product(id: "1", name: "Apple Inc.", type: "Stock", currentValue: 145.32, percentageChange: 1.24, symbol: "AAPL", timestamp: "2024-06-19T10:00:00Z", image: "https://example.com/images/apple.png")
            ])
        ]
        var useCaseCompletionCallsCount = 0
        var mockRepository = MockProductRepositoryImpl()
        mockRepository.result = Just(companies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        let useCase = ProductsUseCaseImpl(repository:mockRepository)
        let expectation = self.expectation(description: "Check API call count")
        
        useCase.execute()
            .sink(receiveCompletion:  { completion in
                expectation.fulfill()
            }, receiveValue: { companies in
                useCaseCompletionCallsCount += 1
            }) .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.fetchCompletionCallsCount, useCaseCompletionCallsCount)
        
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
