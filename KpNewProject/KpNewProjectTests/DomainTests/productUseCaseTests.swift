//
//  productUseCaseTests.swift
//  KpNewProjectCleanTests
//
//  Created by N Krishna Prakash on 20/06/24.
//

import XCTest
import Combine
@testable import KpNewProjectClean

class MockNetworkService: NetworkService {
    var result: AnyPublisher<Data, Error>!
    
    override func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        result
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

class MockProductService : ProductsService {
    var result: AnyPublisher<[Company], Error>!
    
    override func fetchCompanies() -> AnyPublisher<[Company], Error> {
        return result
    }
}

final class productUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockProductsService: MockProductService!
    var repository: ProductsRepositoryImpl!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = []
        mockProductsService = MockProductService(networkService: MockNetworkService())
        repository = ProductsRepositoryImpl(productsService: mockProductsService);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = nil
        mockProductsService = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchAllProducts_Success() {
        // Given
        let companies = [
            Company(id: "1", name: "Tech Innovators Inc.", logo: "https://example.com/logos/tech_innovators.png", products: [
                Product(id: "1", name: "Apple Inc.", type: "Stock", currentValue: 145.32, percentageChange: 1.24, symbol: "AAPL", timestamp: "2024-06-19T10:00:00Z", image: "https://example.com/images/apple.png")
            ])
        ]
        mockProductsService.result = Just(companies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies")
        var fetchedCompanies: [Company]?
        var fetchedError: Error?
        
        repository.fetchAllProducts()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchedError = error
                }
                expectation.fulfill()
            }, receiveValue: { companies in
                fetchedCompanies = companies
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(fetchedCompanies)
        XCTAssertEqual(fetchedCompanies?.count, companies.count)
        XCTAssertNil(fetchedError)
    }
    
    
    func testFetchAllProducts_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockProductsService.result = Fail<[Company], Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies")
        var fetchedCompanies: [Company]?
        var fetchedError: Error?
        
        repository.fetchAllProducts()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchedError = error
                }
                expectation.fulfill()
            }, receiveValue: { companies in
                fetchedCompanies = companies
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(fetchedCompanies)
        XCTAssertNotNil(fetchedError)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
