//
//  UpcomingCell.swift
//  movie-app
//
//  Created by TuanDQ on 27/02/2023.
//

import UIKit

class UpcomingCell: UICollectionViewCell {
    
    @IBOutlet weak var upcomingImageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var task: URLSessionDataTask?
    
    var upcomingImageCache: [String: UIImage] = [:]
    
    override func prepareForReuse() {
        task?.cancel()
    }
    
    var data: Movie? {
        didSet {
            guard let data = data else { return }
            upcomingImageView.image = nil
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            loadFrom(URLAddress: Configs.Network.apiImageUrl + (data.posterPath ?? ""))
            upcomingImageView.layer.cornerRadius = 30
        }
    }
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        if upcomingImageCache[url.absoluteString] != nil {
            self.upcomingImageView.image = upcomingImageCache[url.absoluteString]
            return
        }
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No image data received")
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.upcomingImageCache[url.absoluteString] = image
                self.upcomingImageView.image = image
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
        }
        task?.resume()
    }
}






