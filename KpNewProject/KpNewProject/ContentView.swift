//
//  ContentView.swift
//  KpNewProject
//
//  Created by Krishna Prakash on 08/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HomeView(viewModel: HomeViewModel(productsUseCase: ProductsUseCaseImpl(repository: ProductsRepositoryImpl(productsService: ProductsService(networkService: NetworkService())))))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
