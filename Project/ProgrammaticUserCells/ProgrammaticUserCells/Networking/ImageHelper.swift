//
//  ImageHelper.swift
//  ProgrammaticUserCells
//
//  Created by Jason Ruan on 10/8/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    // MARK: - Static Properties
    
    static let shared = ImageHelper()
    
    // MARK: - Instance Methods
    
    func getImage(url: URL, completionHandler: @escaping (Result<UIImage, AppError>) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(.failure(.badURL))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataReceived))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler(.failure(.notAnImage))
                return
            }
            
            completionHandler(.success(image))
            }.resume()
    }
    
    // MARK: - Private Properties and Initializers
    
    private init() {}
}
