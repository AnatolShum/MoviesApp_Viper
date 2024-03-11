//
//  DatabaseService.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 09/01/2024.
//

import Foundation
import SwiftData

class DatabaseService {
    static var shared = DatabaseService()
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            let schema = Schema([Movie.self, Photos.self, Videos.self, Trailer.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    func saveItem<Model: PersistentModel>(_ model: Model) {
        self.context?.insert(model)
    }
    
    func isItemExist<Model: PersistentModel>(item: Model) -> Bool {
        var exist: Bool = false
        fetchItems(predicate: nil) { (result: Result<[Model], Error>) in
            switch result {
            case .success(let models):
                if let movies = models as? [Movie], let item = item as? Movie {
                    exist = movies.contains { $0.id == item.id && $0.category == item.category }
                }
                if let trailers = models as? [Trailer], let item = item as? Trailer {
                    exist = trailers.contains { $0.id == item.id }
                }
                exist = models.contains { $0 == item }
            case .failure(_):
                break
            }
        }
        
        return exist
    }
    
    func fetchItems<Model: PersistentModel>(predicate: Predicate<Model>?, completion: @escaping (Result<[Model], Error>)->(Void)) {
        var descriptor: FetchDescriptor<Model>
        if let predicate {
            descriptor = FetchDescriptor<Model>(predicate: predicate)
        } else {
            descriptor = FetchDescriptor<Model>()
        }
        
        do {
            let data = try context?.fetch(descriptor)
            completion(.success(data ?? []))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteItems<Model: PersistentModel>(_ model: Model) {
        context?.delete(model)
    }
    
}
