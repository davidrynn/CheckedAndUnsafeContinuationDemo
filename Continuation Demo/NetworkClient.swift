//
//  NetworkClient.swift
//  Continuation Demo
//
//  Created by David Rynn on 10/26/23.
//

import Foundation

protocol Service {
    func fetchDataChecked(animal: String) async throws -> [Animal]
    func fetchDataUnsafe(animal: String) async throws -> [Animal]

}

struct NetworkClient: Service {
    
    let key = "aby4sbTeiglqCJg90ihfXg==d6uvVBefSORV3VCT"
    let decoder = JSONDecoder()
    
    private func fetchData(animal: String, completion: @escaping (Result<[Animal], SimpleError>) -> Void) {

        let request = createRequest(animal: animal)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                completion(.failure(.network))
                return
            }
            guard let data = data else {
                completion(.failure(.network))
                return
            }
            
            
            do {
                let animals = try decoder.decode([Animal].self, from: data)
              //  completion(.success(animals))
            } catch {
                if let error = error as? DecodingError {
                    completion(.failure(.decoding(error)))
                }
            }
        }
        task.resume()
    }
    
    private func createRequest(animal: String) -> URLRequest {
        let name = animal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/animals?name="+name!)!
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    func fetchDataChecked(animal: String) async throws -> [Animal] {
        return try await withCheckedThrowingContinuation { continuation in
            fetchData(animal: animal) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func fetchDataUnsafe(animal: String) async throws -> [Animal] {
        return try await withUnsafeThrowingContinuation { continuation in
            fetchData(animal: animal) { result in
                continuation.resume(with: result)
            }
        }
    }
}

enum SimpleError: Error {
    case network, decoding(DecodingError)
}

struct MockService: Service {
    let taxonomy = Taxonomy(kingdom: "Big", phylum: "big", order: "order", family: "family", genus: "genus")
    func fetchDataChecked(animal: String) async throws -> [Animal] {
        let animal = Animal(name: "Cheetah", taxonomy: taxonomy, locations: [])
        let animal2 = Animal(name: "Zebra", taxonomy: taxonomy, locations: [])
        return [animal, animal2]
    }
    func fetchDataUnsafe(animal: String) async throws -> [Animal] {
        let animal = Animal(name: "Cheetah", taxonomy: taxonomy, locations: [])
        let animal2 = Animal(name: "Zebra", taxonomy: taxonomy, locations: [])
        return [animal, animal2]
    }
}
