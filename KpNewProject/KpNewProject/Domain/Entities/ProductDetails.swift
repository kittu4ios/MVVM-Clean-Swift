//
//  ProductDetails.swift
//  KpNewProjectClean
//
//  Created by N Krishna Prakash on 19/06/24.
//

import Foundation

struct ProductDetails: Codable {
    let id: String
    let name: String
    let type: String
    let symbol: String
    let currentValue: Double
    let percentageChange: Double
    let description: String
    let timestamp: String
    let image: String
    let historicalData: [HistoricalData]
}

struct HistoricalData: Codable {
    let date: String
    let value: Double
}

struct DetailsViewResponse: Codable {
    let productDetails: ProductDetails
}
