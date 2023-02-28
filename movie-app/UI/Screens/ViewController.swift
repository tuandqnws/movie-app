//
//  ViewController.swift
//  movie-app
//
//  Created by TuanDQ on 20/02/2023.
//

import UIKit

@IBDesignable
class ViewController: UIViewController {
    
    var popularMovieList : [Movie] = []
    var upcomingMovieList : [Movie] = []
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    
    @IBOutlet weak var mostPopularCollectionView: UICollectionView!
    
    @IBOutlet weak var homeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarView.layer.cornerRadius = 15
        
        mostPopularCollectionView.delegate = self
        mostPopularCollectionView.dataSource = self
        
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        
        if let mostPopularFlowLayout = mostPopularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            mostPopularFlowLayout.scrollDirection = .horizontal
            mostPopularFlowLayout.minimumLineSpacing = 0
            mostPopularFlowLayout.minimumInteritemSpacing = 0
            mostPopularFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
            mostPopularFlowLayout.itemSize = CGSize(width: mostPopularCollectionView.frame.width * 0.7, height: mostPopularCollectionView.frame.height * 0.8)
        }
        
        if let upcomingFlowLayout = upcomingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            upcomingFlowLayout.scrollDirection = .horizontal
            upcomingFlowLayout.minimumLineSpacing = 0
            upcomingFlowLayout.minimumInteritemSpacing = 0
            upcomingFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
            upcomingFlowLayout.itemSize = CGSize(width: mostPopularCollectionView.frame.width * 0.3, height: mostPopularCollectionView.frame.height)
        }
        
        ApiService.shareInstance.getPopularMovieList(page: 1) { [weak self] data in
            guard let strongSelf = self else {
                return
            }
            strongSelf.popularMovieList = data?.results ?? []
            DispatchQueue.main.async {
                strongSelf.mostPopularCollectionView.reloadData()
            }
        } onFailure: { errorMessage in
            print(errorMessage)
        }
        
        ApiService.shareInstance.getUpcomingMovieList(page: 1) { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.upcomingMovieList = data?.results ?? []
            DispatchQueue.main.async {
                strongSelf.upcomingCollectionView.reloadData()
            }
        } onFailure: { errorMessage in
            print(errorMessage)
        }
        homeView.setGradientBackground(colorLeading: UIColor(red: 0.169, green: 0.345, blue: 0.463, alpha: 1), colorTrailing: UIColor(red: 0.306, green: 0.263, blue: 0.463, alpha: 1))
    }
}
    
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if (collectionView == mostPopularCollectionView) {
                return popularMovieList.count
            }
                return upcomingMovieList.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if (collectionView == mostPopularCollectionView) {
                let cell = mostPopularCollectionView.dequeueReusableCell(withReuseIdentifier: "mostPopularCell", for: indexPath) as! MostPopularCell
                cell.data = self.popularMovieList[indexPath.row]
                return cell
            }
            else {
                let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! UpcomingCell
                cell.data = self.upcomingMovieList[indexPath.row]
                return cell
            }
        }
}

extension UIView {
    func setGradientBackground(colorLeading: UIColor, colorTrailing: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeading.cgColor, colorTrailing.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
}