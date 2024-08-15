//
//  ProductsRepository.swift
//  KpNewProjectClean
//
//  Created by Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

protocol ProductsRepository {
    func fetchAllProducts() -> AnyPublisher<[Company], Error>
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error>
}

class ProductsRepositoryImpl : ProductsRepository {
    
    private let productsService : ProductsService
    
    init(productsService: ProductsService) {
        self.productsService = productsService
    }
    
    func fetchAllProducts() -> AnyPublisher<[Company], Error> {
        ////For testing purposes, you can use a local JSON file by setting the parameter to true. Set it to false to make a request to the actual API.
        return productsService.fetchCompanies(fromLocalJson: true)
    }
    
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error> {
        ////For testing purposes, you can use a local JSON file by setting the parameter to true. Set it to false to make a request to the actual API.
        return productsService.fetchProductDetails(fromLocalJson: true)
        
    }
}
