//
//  ViewModel.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 03.09.2025.
//

import SwiftUI
import CoreData

final class ViewModel: ObservableObject {

    private let viewContext: NSManagedObjectContext
    private let defaultHeader = "Заметка без имени"
    private let defaultBody = "Описание отсутсвует"

    @Published var navPath: [Item] = [] {
        didSet {
            guard let last = navPath.last else { return }
            editableHeader = last.header ?? defaultHeader
            editableBody = last.body ?? defaultBody
        }
    }

    @Published var editableHeader = "Header"
    @Published var editableBody = "Body"
    @Published var searchText: String = ""
    @Published var items: [Item] = []
    @Published var isLoading = false

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.fetchItems()
    }

    func getFilteredItems() -> [Item] {
        guard !searchText.isEmpty else {
            return items
        }
        return items.filter {
            $0.header?.lowercased().contains(searchText.lowercased()) ?? false
            || $0.body?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }

    func fetchItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)]
        do {
            items = try viewContext.fetch(request)
        } catch {
            assertionFailure("Error fetching items: \(error)")
        }
    }

    func getItemHeaderAndBody(_ item: Item) -> (header: String, body: String) {
        var header: String = defaultHeader
        var body: String = defaultBody
        if let itemHeader = item.header, !itemHeader.isEmpty {
            header = itemHeader
        }
        if let itemBody = item.body, !itemBody.isEmpty {
            body = itemBody
        }
        return (header, body)
    }

    func addItem() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.id = UUID()
        newItem.header = ""
        newItem.body = ""
        navPath.append(newItem)
        saveContext()
    }

    func deleteItems(withId id: UUID?) {
        guard let item = findItem(by: id) else {
            assertionFailure("Item not found")
            return
        }
        viewContext.delete(item)
        saveContext()
    }

    func toggleItemStatus(withId id: UUID?) {
        guard let item = findItem(by: id) else {
            assertionFailure("Item not found")
            return
        }
        if item.status {
            item.status = false
        } else {
            item.status = true
        }
        saveContext()
    }

    func updateItem(withId id: UUID?, header: String?, body: String?, timestamp: Date?, status: Bool?) {
        guard let id, let item = findItem(by: id) else {
            assertionFailure("Item not found")
            return
        }
        item.header = header
        item.body = body
        item.timestamp = timestamp
        item.status = status == true
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
            fetchItems()
        } catch {
            assertionFailure("Error saving context: \(error)")
        }
    }

    private func findItem(by id: UUID?) -> Item? {
        guard let id else { return nil }
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            return try viewContext.fetch(request).first
        } catch {
            assertionFailure("Error finding item: \(error)")
            return nil
        }
    }
}
