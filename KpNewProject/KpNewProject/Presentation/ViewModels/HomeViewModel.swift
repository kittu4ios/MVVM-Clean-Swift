//
//  HomeViewModel.swift
//  KpNewProjectClean
//
//  Created by Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    private let getProductsUseCase: ProductsUseCase
    @Published var companies: [Company] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(productsUseCase: ProductsUseCase) {
        self.getProductsUseCase = productsUseCase
    }
    
    func fetchCompanies() {
        getProductsUseCase.executeProducts()
               .sink(receiveCompletion: { completion in
                   // Handle errors if needed
               }, receiveValue: { companies in
                   self.companies = companies
               })
               .store(in: &cancellables)
    }
}
