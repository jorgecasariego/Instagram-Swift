//
//  CustomImageView.swift
//  Intagram
//
//  Created by Jorge Casariego on 12/7/18.
//  Copyright © 2018 Jorge Casariego. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        lastURLUsedToLoadImage = urlString
        
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
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
