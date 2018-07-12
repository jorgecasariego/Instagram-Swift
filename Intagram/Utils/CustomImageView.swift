//
//  CustomImageView.swift
//  Intagram
//
//  Created by Jorge Casariego on 12/7/18.
//  Copyright © 2018 Jorge Casariego. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        // Verificamos si tenemos cacheado la imagen. Si tenemos asignamos y retornamos
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image: ", err)
            }
            
            // Esto hacemos para que no se repitan las imagenes
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
