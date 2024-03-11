//
//  NetworkClient.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 18/09/2023.
//

import Foundation
import UIKit
import Combine

extension Network {
    class Client {
        static let shared = Client()
        
        private let jsonDecoder = JSONDecoder()
        private let jsonEncoder = JSONEncoder()
        
        private var cache: NSCache<NSString, UIImage> = {
            let cache = NSCache<NSString, UIImage>()
            cache.countLimit = 200
            cache.totalCostLimit = 100_000_000
            return cache
        }()
        
        func fetch<Request, Response>(_ argument: Argument, method: Method = .get, body: Request? = nil, then callback: ((Result<Response, Errors>) -> Void)? = nil) where Request: Codable, Response: Codable {
            guard let url = argument.url else { return }
            
            var urlRequest = URLRequest(url: url)
            
            if let body = body {
                do {
                    urlRequest.httpBody = try jsonEncoder.encode(body)
                } catch {
                    print(error.localizedDescription)
                    callback?(.failure(.couldNotEncode))
                    return
                }
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    callback?(.failure(.couldNotFetchData))
                } else {
                    if let data = data {
                        do {
                            let result = try self.jsonDecoder.decode(Response.self, from: data)
                            callback?(.success(result))
                        } catch {
                            print(error.localizedDescription)
                            callback?(.failure(.couldNotDecode))
                        }
                    }
                }
            }
            dataTask.resume()
        }
        
        func get<Response>(_ argument: Argument, completion: @escaping (Result<Response, Errors>) -> Void) where Response: Codable {
                let body: Types.Request.Empty? = nil
                self.fetch(argument, method: .get, body: body) { result in
                    completion(result)
                }
        }
        
        func fetchImage(with path: String?, completion: @escaping (Result<UIImage, Errors>) -> Void) {
            guard let path = path else {
                completion(.failure(Errors.pathNotFound))
                return
            }
            
            if let image = self.cache.object(forKey: NSString(string: path)) {
                completion(.success(image))
            } else {
                let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
                
                let imageURL = baseURL.appending(path: path)
                
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    guard error == nil else {
                        completion(.failure(Errors.unknownError))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        completion(.failure(Errors.responseError))
                        return
                    }
                    guard let data else {
                        completion(.failure(Errors.couldNotFetchData))
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        completion(.failure(Errors.imageNotFound))
                        return
                    }
                    self.cache.setObject(image, forKey: NSString(string: path))
                    
                    completion(.success(image))
                }.resume()
            }
        }
        
        func fetchImage(with path: String?) -> Future<UIImage, Errors> {
            return Future() { promise in
                guard let path = path else { 
                    promise(.failure(Errors.pathNotFound))
                    return
                }
                if let image = self.cache.object(forKey: NSString(string: path)) {
                    promise(.success(image))
                } else {
                    let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
                    
                    let imageURL = baseURL.appending(path: path)
                    
                    URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                        guard let data else {
                            promise(.failure(Errors.couldNotFetchData))
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode == 200 else {
                            promise(.failure(Errors.responseError))
                            return
                        }
                        guard let image = UIImage(data: data) else {
                            promise(.failure(Errors.imageNotFound))
                            return
                        }
                        self?.cache.setObject(image, forKey: NSString(string: path))
                        promise(.success(image))
                    }
                    .resume()
                }
            }
        }
        
    }
}
