//
//  DetailsViewModel.swift
//  KpNewProjectClean
//
//  Created by Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

class DetailsViewModel: ObservableObject {
    
    
    private let productsUseCase: ProductsUseCase
    @Published var productDetails:ProductDetails?
    private var cancellables = Set<AnyCancellable>()
    
    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
    func fetchProductDetails() {
        productsUseCase.executeProductDetails()
               .sink(receiveCompletion: { completion in
                   // Handle errors if needed
               }, receiveValue: { productDetails in
                   self.productDetails = productDetails
               })
               .store(in: &cancellables)
    }
}
