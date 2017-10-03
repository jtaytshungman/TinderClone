//
//  caching.swift
//  GoogleToolboxForMac
//
//  Created by Jeremy Tay on 03/10/2017.
//

import UIKit

extension UIImageView {
    func loadImageUsingCacheWithURLString(urlString : String) {
        guard let url = URL(string : urlString) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
