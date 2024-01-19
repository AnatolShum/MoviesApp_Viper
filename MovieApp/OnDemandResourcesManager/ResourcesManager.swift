//
//  ResourcesManager.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 19/01/2024.
//

import Foundation
import UIKit

final class ResourcesManager {
    private let group = DispatchGroup()
    private let tags = ["ApiKey"]
    
    private func loadResources(completion: @escaping (NSBundleResourceRequest?, Error?) -> Void) {
        let tags = NSSet(array: tags)
        let resourcesRequest: NSBundleResourceRequest = NSBundleResourceRequest(tags: tags as! Set<String>)
        
        resourcesRequest.conditionallyBeginAccessingResources { resourcesAvailable in
            if resourcesAvailable {
                completion(resourcesRequest, nil)
            } else {
                resourcesRequest.beginAccessingResources { error in
                    if let error {
                        completion(nil, error)
                        print("Could not read on-Demand Resources: \(error.localizedDescription)")
                              } else {
                                  completion(resourcesRequest, nil)
                        }
                }
            }
        }
    }
    
    typealias ApiKey = String?
    func getKey() -> ApiKey {
        var key: String? = nil
        
        group.enter()
        loadResources { odr, error in
            if error == nil, odr != nil {
                guard let resources = NSDataAsset(name: "secret") else { return }
                let data = resources.data
                let nsKey = NSString(data: data, encoding: NSUTF8StringEncoding)
                key = nsKey as? String
                
                self.group.leave()
            } else {
                self.group.leave()
            }
        }
        
        group.wait()
        return key
    }
}
