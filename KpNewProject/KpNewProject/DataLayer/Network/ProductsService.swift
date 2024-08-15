//
//  ProductsService.swift
//  KpNewProjectClean
//
//  Created by Krishna Prakash on 19/06/24.
//

import Foundation
import Combine


class ProductsService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCompanies(fromLocalJson: Bool = false) -> AnyPublisher<[Company], Error> {
        
        if fromLocalJson {
            return loadCompaniesFromFile(filename: "companies")
        } else {
            guard let url = URL(string: "http://127.0.0.1:3001/allproducts") else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            
            return networkService.request(url)
                .map { (response: CompaniesResponse) in
                    response.companies
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
    }
    
    func loadCompaniesFromFile(filename: String) -> AnyPublisher<[Company], Error> {
        Future { promise in
            DispatchQueue.global(qos: .background).async {
                guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                    return promise(.failure(URLError(.fileDoesNotExist)))
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let companiesResponse = try decoder.decode(CompaniesResponse.self, from: data)
                    DispatchQueue.main.async {
                        promise(.success(companiesResponse.companies))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchProductDetails(fromLocalJson: Bool = false) -> AnyPublisher<ProductDetails, Error> {
        
        if fromLocalJson {
            return loadProductDetailsFromFile(filename: "productDetails")
        } else {
            guard let url = URL(string: "http://127.0.0.1:3001/allproducts") else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            
            return networkService.request(url)
                .map { (response: ProductDetailsResponse) in
                    response.productDetails
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
    }
    
    func loadProductDetailsFromFile(filename: String) -> AnyPublisher<ProductDetails, Error> {
        Future { promise in
            DispatchQueue.global(qos: .background).async {
                guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                    return promise(.failure(URLError(.fileDoesNotExist)))
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let detailsResponse = try decoder.decode(ProductDetailsResponse.self, from: data)
                    DispatchQueue.main.async {
                        promise(.success(detailsResponse.productDetails))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
