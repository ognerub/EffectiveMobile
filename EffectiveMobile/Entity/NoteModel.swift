//
//  NoteModel.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 04.09.2025.
//

struct Response: Codable {
    let todos: [NoteModel]
}

struct NoteModel: Codable {
    let id: Int
    let todo: String?
    let completed: Bool
    let userId: Int
}
