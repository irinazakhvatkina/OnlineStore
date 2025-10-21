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
    
    var itemsCount: Int {
        let items = fetchCartItems()
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    // MARK: - Add
    func addCartItem(_ product: Product, quantity: Int = 1) {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(product.id))
        
        if let entity = try? context.fetch(request).first {
            entity.quantity += Int16(quantity)
        } else {
            let entity = CartItemEntity(context: context)
            entity.id = "\(product.id)"
            entity.name = product.title
            entity.price = product.price
            entity.descriptionText = product.description
            entity.imageUrl = product.images.first
            entity.variant = product.category.name
            entity.quantity = Int16(quantity)
        }
        saveContext()
        notifyCartUpdated()
    }
    
    // MARK: - Fetch
    func fetchCartItems() -> [CartItem] {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                let product = Product(
                    id: Int(entity.id ?? "0") ?? 0,
                    title: entity.name ?? "",
                    price: entity.price,
                    description: entity.description,
                    category: Category(
                        id: 0,
                        name: entity.variant ?? "",
                        creationAt: nil,
                        updatedAt: nil
                    ),
                    images: (entity.imageUrl == nil) ? [] : [entity.imageUrl ?? ""],
                    slug: nil,
                    creationAt: nil,
                    updatedAt: nil
                )
                return CartItem(product: product, quantity: Int(entity.quantity))
            }
        } catch {
            print("Ошибка fetch: \(error)")
            return []
        }
    }
    
    func clearCartItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
            notifyCartUpdated()
        } catch {
            print("Ошибка при очистке корзины: \(error)")
        }
    }
    
    func containsCartItem(_ product: Product) -> Bool {
        do {
            let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", String(product.id))
            
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Ошибка проверки contains: \(error)")
            return false
        }
    }
    
    // MARK: - Delete
    func deleteCartItem(id: String) {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        
        if let result = try? context.fetch(request).first {
            context.delete(result)
            saveContext()
            
            notifyCartUpdated()
        }
    }
    
    private func notifyCartUpdated() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    // MARK: - Create
    func addQuery(_ query: String) {
        let entity = SearchQueryEntity(context: context)
        entity.query = query
        entity.date = Date()
        
        saveContext()
        notifyQueryUpdated()
    }
    
    // MARK: - Read (Fetch)
    func fetchQueries() -> [String] {
        let request: NSFetchRequest<SearchQueryEntity> = SearchQueryEntity.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            let queries = entities.compactMap { (entity: SearchQueryEntity) -> String? in
                return entity.query
            }
            return queries
        } catch {
            print("Ошибка fetch запросов: \(error)")
            return []
        }
    }
    
    // MARK: - Delete (by query)
    func deleteQuery(by query: String) {
        let request: NSFetchRequest<SearchQueryEntity> = SearchQueryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "query == %@", query)
        
        do {
            if let query = try context.fetch(request).first {
                context.delete(query)
                saveContext()
                notifyQueryUpdated()
            }
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
    
    // MARK: - Delete All
    func clearAllQueries() {
        let request: NSFetchRequest<NSFetchRequestResult> = SearchQueryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            notifyQueryUpdated()
        } catch {
            print("Ошибка очистки всех запросов: \(error)")
        }
    }
    
    // MARK: - Check
    func containsQuery(_ query: String) -> Bool {
        let request: NSFetchRequest<SearchQueryEntity> = SearchQueryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "query == %@", query)
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Ошибка проверки contains: \(error)")
            return false
        }
    }
    
    // MARK: - Notification
    private func notifyQueryUpdated() {
        NotificationCenter.default.post(name: .searchQueriesUpdated, object: nil)
    }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
