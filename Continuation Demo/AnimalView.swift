//
//  ContentView.swift
//  Continuation Demo
//
//  Created by David Rynn on 10/26/23.
//

import SwiftUI

struct AnimalView: View {
    @ObservedObject var viewModel: AnimalViewModel
    @State var animalName: String = ""
    
    var body: some View {
        VStack {
            Button("Reset") {
                viewModel.animals = []
                viewModel.loadingState = .loaded
            }
            switch viewModel.loadingState {
            case .error(let error):
                Text(error.localizedDescription)
            case .loaded:
                main
            case .loading:
                ProgressView()
            }
   
        }
    }
    
    var main: some View {
        
        VStack {
            TextField("Enter Animal Name", text: $animalName)
            Button("Submit Checked") {
                Task {
                    await viewModel.loadChecked(animalName)
                }
            }
            Button("Submit Unsafe") {
                Task {
                    await viewModel.loadUnsafe(animalName)
                }
            }
            ScrollView {
                ForEach(viewModel.animals) { animal in
                    Text(animal.name)
                }
                .padding()
            }
        }
        .padding()
 
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AnimalViewModel(service: MockService())
        AnimalView(viewModel: viewModel)
    }
}
