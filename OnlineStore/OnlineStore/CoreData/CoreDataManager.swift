//
//  CoreDataManager.swift
//  OnlineStore
//
//  Created by Zaripov Anushervon  on 12/10/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OnlineStoreModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - CRUD
    
    func saveProduct(_ product: ProductModel) {
        let entity = ProductEntity(context: context)
        entity.id = product.id
        entity.name = product.name
        entity.price = product.price
        entity.descriptionText = product.description
        entity.imageUrl = product.imageUrl
        entity.isFavorite = product.isFavorite
        saveContext()
    }
    
    func fetchProducts() -> [ProductModel] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map {
                ProductModel(
                    id: $0.id ?? "",
                    name: $0.name ?? "",
                    price: $0.price,
                    description: $0.descriptionText ?? "",
                    imageUrl: $0.imageUrl ?? "",
                    isFavorite: $0.isFavorite
                )
            }
        } catch {
            print("Ошибка fetch: \(error)")
            return []
        }
    }
    
    func deleteProduct(id: String) {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let result = try? context.fetch(request).first {
            context.delete(result)
            saveContext()
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
