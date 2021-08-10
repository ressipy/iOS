//
//  NetworkManager.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/7/21.
//

import Foundation
import Combine
import os

enum NetworkError: Error {
    case badRequest
    case badServerResponse
    case badURL
    case notFound
    case requestRateLimited
    case requestForbidden
    case requestUnauthorized
    case unknownError
}

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
    
    func createToken(credentials: Credentials, completion: @escaping (Result<TokenResult, NetworkError>) -> ()) {
        guard let url = URL(string: baseUrl + "/users/tokens") else { return }
        let credentialsWrapper = CredentialsWrapper(user: credentials)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(credentialsWrapper)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        makeRequest(request, asType: TokenResult.self, completion: completion)
    }
    
    func getCategory(slug: String, completion: @escaping (Result<CategoryResult, NetworkError>) -> ()) {
        guard let url = URL(string: baseUrl + "/categories/\(slug)") else { return }
        makeRequest(URLRequest(url: url), asType: CategoryResult.self, completion: completion)
    }
    
    func getCategoryList(completion: @escaping (Result<CategoryListResult, NetworkError>) -> ()) {
        guard let url = URL(string: baseUrl + "/categories") else { return }
        makeRequest(URLRequest(url: url), asType: CategoryListResult.self, completion: completion)
    }
    
    func getRecipe(slug: String, completion: @escaping (Result<RecipeResult, NetworkError>) -> ()) {
        guard let url = URL(string: baseUrl + "/recipes/\(slug)") else { return }
        makeRequest(URLRequest(url: url), asType: RecipeResult.self, completion: completion)
    }
    
    func getSyncData(updatedAfter: String? = nil, completion: @escaping (Result<ImporterResponse, NetworkError>) -> ()) {
        var urlComponents = URLComponents(string: baseUrl + "/data")!
        
        if let updatedAfter = updatedAfter {
            urlComponents.queryItems = [URLQueryItem(name: "updatedAfter", value: updatedAfter)]
        }
        
        guard let url = urlComponents.url else { return }
        makeRequest(URLRequest(url: url), asType: ImporterResponse.self, completion: completion)
    }
    
    private func makeRequest<T: Decodable>(_ baseRequest: URLRequest, asType type: T.Type, completion: @escaping (Result<T, NetworkError>) -> ()) {
        var request = baseRequest
        
        if AuthManager.shared.isLoggedIn {
            request.setValue("Bearer \(AuthManager.shared.token!)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: type, decoder: decoder)
            .mapError { error -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                } else if let error = error as? URLError {
                    switch error.code {
                    case .badURL:
                        return NetworkError.badURL
                    default:
                        self.logger.warning("Received an unknown error while loading \(request.url!.path): \(String(describing: error))")
                        return NetworkError.unknownError
                    }
                } else {
                    return NetworkError.unknownError
                }
            }
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .finished:
                    self.logger.info("Successfully loaded \(request.url!.path)")
                case .failure(let error):
                    self.logger.warning("There was an error loading \(request.url!.path): \(String(describing: error))")
                    completion(.failure(error))
                }
            } receiveValue: { result in
                completion(.success(result))
            }
            .store(in: &cancellables)
    }
    
    private func handleError(error: Error) {
        
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.badServerResponse
        }
        
        switch response.statusCode {
        case 200:
            return output.data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.requestUnauthorized
        case 403:
            throw NetworkError.requestForbidden
        case 404:
            throw NetworkError.notFound
        case 429:
            throw NetworkError.requestRateLimited
        default:
            self.logger.warning("Unexpected status code: \(response.allHeaderFields)")
            throw NetworkError.badServerResponse
        }
    }
}

