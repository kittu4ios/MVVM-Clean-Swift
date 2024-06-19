//
//  ProductsRepository.swift
//  KpNewProjectClean
//
//  Created by N Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

protocol ProductsRepository {
    func fetchAllProducts() -> AnyPublisher<[Company], Error>
}

class ProductsRepositoryImpl : ProductsRepository {
    
    private let productsService : ProductsService
    
    init(productsService: ProductsService) {
        self.productsService = productsService
    }
    
    func fetchAllProducts() -> AnyPublisher<[Company], Error> {
        
        return productsService.fetchCompanies()
        
    }
}
