//
//  ProductRepositoryTests.swift
//  KpNewProjectCleanTests
//
//  Created by Krishna Prakash on 20/06/24.
//

import XCTest
import Combine
@testable import KpNewProjectClean

final class ProductsRepositoryImplTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockProductsService: MockProductService!
    var repository: ProductsRepositoryImpl!
    
    override func setUpWithError() throws {
        cancellables = []
        mockProductsService = MockProductService(networkService: MockNetworkService())
        repository = ProductsRepositoryImpl(productsService: mockProductsService)
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        mockProductsService = nil
        repository = nil
    }
    
    func testFetchAllProducts_LocalJson_Success() {
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
        let expectation = self.expectation(description: "Fetching companies from local JSON")
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
    
    func testFetchAllProducts_LocalJson_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockProductsService.companiesResult = Fail<[Company], Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies from local JSON")
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
    
    func testFetchProductDetails_LocalJson_Success() {
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
        let expectation = self.expectation(description: "Fetching product details from local JSON")
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
    
    func testFetchProductDetails_LocalJson_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockProductsService.productDetailsResult = Fail<ProductDetails, Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching product details from local JSON")
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
    
    func testFetchAllProducts_API_Success() {
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
        let expectation = self.expectation(description: "Fetching companies from API")
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
    
    func testFetchAllProducts_API_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockProductsService.companiesResult = Fail<[Company], Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies from API")
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
    
    func testFetchProductDetails_API_Success() {
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
        let expectation = self.expectation(description: "Fetching product details from API")
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
    
    func testFetchProductDetails_API_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockProductsService.productDetailsResult = Fail<ProductDetails, Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching product details from API")
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
            // Measure the time of code here
        }
    }
}

