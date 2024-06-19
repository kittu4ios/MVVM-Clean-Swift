//
//  NetworkService.swift
//  KpNewProjectClean
//
//  Created by N Krishna Prakash on 19/06/24.
//

import Foundation
import Combine

enum NetworkError: Error {
  case decodingError(DecodingError.Context)
  case urlError(URLError)
  // Add other potential error cases here
}

class NetworkService {
//    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
//        return AF.request(url)
//            .publishDecodable(type: T.self)
//            .value()
//            .mapError { $0 as Error }
//            .eraseToAnyPublisher()
//    }
    
   /* func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
      return URLSession.shared.dataTaskPublisher(for: url)
          .tryMap { data, response -> Data in
              guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                  throw URLError(.badServerResponse)
              }
              return data
          }
          .decode(type: T.self, decoder: JSONDecoder())
          .mapError { error -> Error in
              if let urlError = error as? URLError {
                  return urlError
              } else {
                  // Handle other types of errors (e.g., decoding errors)
                  return DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
              }
              
          }
          .eraseToAnyPublisher()
    }*/
    
    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
            return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
}
