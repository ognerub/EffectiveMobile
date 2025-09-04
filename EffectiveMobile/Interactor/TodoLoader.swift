//
//  Loader.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 04.09.2025.
//

import Foundation

final class Loader {
    func loadTodos(completion: @escaping ([NoteModel]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
                assertionFailure("Error: Could not find todos.json in the bundle")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completion(response.todos)
                }
            } catch {
                assertionFailure("Error parsing JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}
