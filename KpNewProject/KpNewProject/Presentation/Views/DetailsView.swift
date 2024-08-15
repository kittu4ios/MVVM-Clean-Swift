//
//  DetailsView.swift
//  KpNewProjectClean
//
//  Created by Krishna Prakash on 19/06/24.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: DetailsViewModel

    var body: some View {
        ScrollView { // Wrap the entire content in a ScrollView
            VStack {
                if let productDetails = viewModel.productDetails {
                    // Display product details
                    VStack(alignment: .leading, spacing: 16) {
                        // Product Image
                        if let imageUrl = URL(string: productDetails.image) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                        .padding(.bottom, 16)
                                case .failure(let error):
                                    Text("Failed to load image: \(error.localizedDescription)")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        // Product Name
                        Text(productDetails.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)

                        // Product Type and Symbol
                        HStack {
                            Text(productDetails.type)
                                .font(.headline)
                            Spacer()
                            Text(productDetails.symbol)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }

                        // Current Value and Percentage Change
                        HStack {
                            Text("Current Value: $\(productDetails.currentValue, specifier: "%.2f")")
                                .font(.title2)
                            Spacer()
                            Text("\(productDetails.percentageChange >= 0 ? "+" : "")\(productDetails.percentageChange, specifier: "%.2f")%")
                                .font(.title2)
                                .foregroundColor(productDetails.percentageChange >= 0 ? .green : .red)
                        }

                        // Description
                        Text(productDetails.description)
                            .font(.body)
                            .padding(.vertical)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)

                        // Historical Data
                        Text("Historical Data")
                            .font(.headline)
                            .padding(.top)

                        ForEach(productDetails.historicalData, id: \.date) { data in
                            HStack {
                                Text(data.date)
                                Spacer()
                                Text("$\(data.value, specifier: "%.2f")")
                            }
                            Divider()
                        }
                    }
                    .padding()
                } else {
                    ProgressView("Loading...")
                        .onAppear {
                            viewModel.fetchProductDetails()
                        }
                }
            }
            .padding()
        }
    }
}



#Preview {
    DetailsView(viewModel: DetailsViewModel(productsUseCase: ProductsUseCaseImpl(repository: ProductsRepositoryImpl(productsService: ProductsService(networkService: NetworkService())))))
}
