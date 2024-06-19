//
//  ProductsUseCase.swift
//  KpNewProjectClean
//
//  Created by N Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

protocol ProductsUseCase {
   func execute() -> AnyPublisher<[Company], Error>
}

class ProductsUseCaseImpl: ProductsUseCase {
    
    private let repository: ProductsRepository
    
    init(repository: ProductsRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Company], Error> {
        
        return repository.fetchAllProducts()
        
    }
    
    
}
