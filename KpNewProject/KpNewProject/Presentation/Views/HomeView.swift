//
//  HomeView.swift
//  KpNewProjectClean
//
//  Created by N Krishna Prakash on 19/06/24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        List(viewModel.companies) { company in
            VStack(alignment: .leading) {
                Text(company.name)
                    .font(.headline)
                HStack {
                    ForEach(company.products) { product in
                        VStack {
                            AsyncImage(url: URL(string: product.image)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle()) // Optional: Clip to circle shape
                                case .failure(let error):
                                    Text("Failed to load image: \(error.localizedDescription)")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text(product.name)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCompanies()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(productsUseCase: ProductsUseCaseImpl(repository: ProductsRepositoryImpl(productsService: ProductsService(networkService: NetworkService())))))
}
