//
//  DataManager.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Combine
import Foundation

class DataManager {
    static let shared = DataManager()
    var cancellables = Set<AnyCancellable>()
    
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
        guard let url = URL(string: "https://ressipy.fly.dev/api\(path)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: type, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished loading \(path)")
                case .failure(let error):
                    print("There was an error loading \(path): \(error)")
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
