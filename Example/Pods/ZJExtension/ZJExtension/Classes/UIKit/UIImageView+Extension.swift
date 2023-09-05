//
//  UIImageView+Extension.swift
//  ZJExtension
//
//  Created by Jercan on 2023/3/17.
//

import SDWebImage

public extension UIImageView {
        
    func setRoundImageWith(url: String?, placeholderImage: UIImage? = nil) {
        setImageWith(url: url, placeholderImage: placeholderImage) { [weak self] in
            if let img = $0?.round {
                self?.image = img
            }
        }
    }
    
    func setRoundImageWith(url: URL?, placeholderImage: UIImage? = nil) {
        setImageWith(url: url, placeholderImage: placeholderImage) { [weak self] in
            if let img = $0?.round {
                self?.image = img
            }
        }
    }
    
    func setImageWith(url: String?, placeholderImage: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        let imageURL: URL?
        if let remoteUrl = url {
            imageURL = URL(string: remoteUrl)
        } else {
            imageURL = nil
        }
        setImageWith(url: imageURL, placeholderImage: placeholderImage, completion: completion)
    }
    
    func setImageWith(url: URL?, placeholderImage: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        sd_setImage(with: url,
                    placeholderImage: placeholderImage,
                    options: [.retryFailed, .refreshCached, .scaleDownLargeImages]) { (image, _, _, _)  in
            completion?(image)
        }
    }
    
}


