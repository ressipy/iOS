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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "NetworkManager")
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
    
    func getSyncData(updatedAfter: String? = nil, completion: @escaping (ImporterResponse) -> ()) {
        var params: [URLQueryItem]? = nil
        
        if let updatedAfter = updatedAfter {
            params = [URLQueryItem(name: "updatedAfter", value: updatedAfter)]
        }
        
        getData(fromPath: "/data", withParams: params, asType: ImporterResponse.self, completion: completion)
    }
    
    private func getData<T: Decodable>(fromPath path: String, withParams params: [URLQueryItem]? = nil, asType type: T.Type, completion: @escaping (T) -> ()) {
        var urlComponents = URLComponents(string: baseUrl + path)!
        urlComponents.queryItems = params
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: type, decoder: decoder)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.logger.info("Successfully loaded \(path)")
                case .failure(let error):
                    print(error)
                    self.logger.warning("There was an error loading \(path): \(String(describing: error))")
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

