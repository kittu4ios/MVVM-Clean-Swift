//
//  ProductsService.swift
//  KpNewProjectClean
//
//  Created by N Krishna Prakash on 19/06/24.
//

import Foundation
import Combine


class ProductsService {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchCompanies() -> AnyPublisher<[Company], Error> {
        let url = URL(string: "http://127.0.0.1:3001/allproducts")!
        return networkService.request(url)
            .map { (response: CompaniesResponse) in
            response.companies
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()

    }
}
