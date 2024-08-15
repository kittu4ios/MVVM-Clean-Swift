//
//  productUseCaseTests.swift
//  KpNewProjectCleanTests
//
//  Created by Krishna Prakash on 20/06/24.
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

class MockProductService: ProductsService {
    var companiesResult: AnyPublisher<[Company], Error>!
    var productDetailsResult: AnyPublisher<ProductDetails, Error>!
    
    override func fetchCompanies(fromLocalJson: Bool = false) -> AnyPublisher<[Company], Error> {
        companiesResult
    }
    
    override func fetchProductDetails(fromLocalJson: Bool = false) -> AnyPublisher<ProductDetails, Error> {
        productDetailsResult
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
        mockProductsService.companiesResult = Just(companies)
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
        mockProductsService.companiesResult = Fail<[Company], Error>(error: error)
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
    
    func testFetchProductDetails_Success() {
            // Given
            let productDetails = ProductDetails(
                id: "1",
                name: "Apple Inc.",
                type: "Stock",
                symbol: "AAPL",
                currentValue: 145.32,
                percentageChange: 1.24,
                description: "Apple Inc. is an American multinational technology company headquartered in Cupertino, California.",
                timestamp: "2024-06-19T10:00:00Z",
                image: "https://example.com/images/apple.png",
                historicalData: [
                    HistoricalData(date: "2023-06-12", value: 144.1),
                    HistoricalData(date: "2023-06-11", value: 143.85)
                ]
            )
            mockProductsService.productDetailsResult = Just(productDetails)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
            // When
            let expectation = self.expectation(description: "Fetching product details")
            var fetchedProductDetails: ProductDetails?
            var fetchedError: Error?
            
            repository.fetchProductDetails()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        fetchedError = error
                    }
                    expectation.fulfill()
                }, receiveValue: { details in
                    fetchedProductDetails = details
                })
                .store(in: &cancellables)
            
            // Then
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertNotNil(fetchedProductDetails)
            XCTAssertEqual(fetchedProductDetails?.id, productDetails.id)
            XCTAssertNil(fetchedError)
        }
        
        func testFetchProductDetails_Failure() {
            // Given
            let error = NSError(domain: "", code: -1, userInfo: nil)
            mockProductsService.productDetailsResult = Fail<ProductDetails, Error>(error: error)
                .eraseToAnyPublisher()
            
            // When
            let expectation = self.expectation(description: "Fetching product details")
            var fetchedProductDetails: ProductDetails?
            var fetchedError: Error?
            
            repository.fetchProductDetails()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        fetchedError = error
                    }
                    expectation.fulfill()
                }, receiveValue: { details in
                    fetchedProductDetails = details
                })
                .store(in: &cancellables)
            
            // Then
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertNil(fetchedProductDetails)
            XCTAssertNotNil(fetchedError)
        }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
