//
//  ProductsUseCase.swift
//  KpNewProjectClean
//
//  Created by Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

protocol ProductsUseCase {
   func executeProducts() -> AnyPublisher<[Company], Error>
   func executeProductDetails() -> AnyPublisher<ProductDetails, Error>
}

class ProductsUseCaseImpl: ProductsUseCase {
    
    private let repository: ProductsRepository
    
    init(repository: ProductsRepository) {
        self.repository = repository
    }
    
    func executeProducts() -> AnyPublisher<[Company], Error> {
        
        return repository.fetchAllProducts()
        
    }
    
    func executeProductDetails() -> AnyPublisher<ProductDetails, Error> {
        return repository.fetchProductDetails()
    }
    
}
