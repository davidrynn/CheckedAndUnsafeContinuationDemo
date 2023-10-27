//
//  AnimalViewModel.swift
//  Continuation Demo
//
//  Created by David Rynn on 10/26/23.
//

import Foundation

class AnimalViewModel: ObservableObject {
    let network: Service
    @Published var animals: [Animal] = []
    @Published var error: SimpleError? = nil
    @Published var loadingState: LoadingState = .loaded
    
    init(service: Service) {
        self.network = service
    }
    
    @MainActor
    func loadChecked(_ animal: String) async {
        loadingState = .loading
        do {
            animals = try await network.fetchDataChecked(animal: animal)
            loadingState = .loaded
        } catch {
            if let error = error as? SimpleError {
                loadingState = .error(error)
            }
        }
    }
    
    @MainActor
    func loadUnsafe(_ animal: String) async {
        loadingState = .loading
        do {
            animals = try await network.fetchDataUnsafe(animal: animal)
            loadingState = .loaded
        } catch {
            if let error = error as? SimpleError {
                loadingState = .error(error)
            }
        }
    }
}

enum LoadingState {
    case loading, error(SimpleError), loaded
}
