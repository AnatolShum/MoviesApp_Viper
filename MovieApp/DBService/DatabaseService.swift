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
    
    func saveItem(_ entity: Entities) {
        switch entity {
        case .movie(let movie):
            self.context?.insert(movie)
        case .photo(let photo):
            self.context?.insert(photo)
        case .video(let video):
            self.context?.insert(video)
        case .trailer(let trailer):
            self.context?.insert(trailer)
        }
    }
    
    func checkIfItemInDb(category: Categories, id: Int) -> Bool {
        var exist: Bool = false
        fetchItems(category: category) { data, error in
            if let data {
                switch category {
                case .upcoming, .nowPlaying, .topRated, .popular:
                    let movies = data as! [Movie]
                    exist = movies.contains { $0.id == id }
                case .trailers:
                    let trailers = data as! [Trailer]
                    exist = trailers.contains { $0.id == id }
                default:
                    exist = false
                }
            }
        }
        
        return exist
    }
    
    func fetchItems(category: Categories, completion: @escaping([Any]?, Error?)->(Void)) {
        let categoryValue = category.identifier
        let moviePredicate = #Predicate<Movie> { $0.category == categoryValue }
        switch category {
        case .upcoming:
            let descriptor = FetchDescriptor<Movie>(predicate: moviePredicate)
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        case .nowPlaying:
            let descriptor = FetchDescriptor<Movie>(predicate: moviePredicate)
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        case .topRated:
            let descriptor = FetchDescriptor<Movie>(predicate: moviePredicate)
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        case .popular:
            let descriptor = FetchDescriptor<Movie>(predicate: moviePredicate)
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        case .photos:
            let descriptor = FetchDescriptor<Photos>()
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        case .videos:
            let descriptor = FetchDescriptor<Videos>()
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        case .trailers:
            let descriptor = FetchDescriptor<Trailer>()
            do {
                let data = try context?.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func filterMovie(id: Int, completion: @escaping([Movie]?, Error?)->(Void)) {
        let predicate = #Predicate<Movie> { $0.id == id }
        let descriptor = FetchDescriptor<Movie>(predicate: predicate)
        do {
            let data = try context?.fetch(descriptor)
            completion(data, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func deleteItems(_ entity: Entities) {
        switch entity {
        case .movie(let movie):
            context?.delete(movie)
        case .photo(let photo):
            context?.delete(photo)
        case .video(let video):
            context?.delete(video)
        case .trailer(let trailer):
            context?.delete(trailer)
        }
    }
    
    func updateTrailer(trailer: Trailer, newImageData: Data?, newKey: String?) {
        let trailerToBeUpdated = trailer
        
        if let newImageData {
            trailerToBeUpdated.imageData = newImageData
        }
        
        if let newKey {
            trailerToBeUpdated.videoKey = newKey
        }
    }
    
}
