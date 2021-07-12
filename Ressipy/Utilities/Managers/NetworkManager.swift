//
//  NetworkManager.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/7/21.
//

import Foundation
import Combine
import os

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://ressipy.com/api"
    var cancellables = Set<AnyCancellable>()
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = StorageProvider.shared.persistentContainer.viewContext
        return decoder
    }()
    
    private init() {}
    
    func getCategory(slug: String, completion: @escaping (CategoryResult) -> ()) {
        getData(fromPath: "/categories/\(slug)", asType: CategoryResult.self, completion: completion)
    }
    
    func getCategoryList(completion: @escaping (CategoryListResult) -> ()) {
        getData(fromPath: "/categories", asType: CategoryListResult.self, completion: completion)
    }
    
    func getRecipe(slug: String, completion: @escaping (RecipeResult) -> ()) {
        getData(fromPath: "/recipes/\(slug)", asType: RecipeResult.self, completion: completion)
    }
    
    private func getData<T: Decodable>(fromPath path: String, asType type: T.Type, completion: @escaping (T) -> ()) {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "NetworkManager")
        guard let url = URL(string: baseUrl + path) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: type, decoder: decoder)
            .sink { completion in
                switch completion {
                case .finished:
                    logger.info("Successfully loaded \(path)")
                case .failure(let error):
                    logger.warning("There was an error loading \(path): \(String(describing: error))")
                }
            } receiveValue: { result in
                completion(result)
            }
            .store(in: &cancellables)
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
}

