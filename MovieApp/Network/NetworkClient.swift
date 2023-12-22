//
//  NetworkClient.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 18/09/2023.
//

import Foundation
import UIKit

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
        
        func get<Response>(_ argument: Argument, then callback: ((Result<Response, Errors>) -> Void)? = nil) where Response: Codable {
            let body: Types.Request.Empty? = nil
            fetch(argument, method: .get, body: body) { result in
                callback?(result)
            }
        }
        
        func fetchImage(with path: String?) async throws -> UIImage {
            guard let path = path else { throw Errors.pathNotFound }
            if let image = cache.object(forKey: NSString(string: path)) {
                return image
            } else {
                let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
                
                let imageURL = baseURL.appending(path: path)
                
                let (data, response) = try await URLSession.shared.data(from: imageURL)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw Errors.responseError }
                
                guard let image = UIImage(data: data) else { throw Errors.imageNotFound }
                cache.setObject(image, forKey: NSString(string: path))
                
                return image
            }
        }
        
    }
}
