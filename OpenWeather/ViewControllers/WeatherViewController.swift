//
//  WeatherViewController
//  OpenWeather
//
//  Created by Daniel Broad on 26/02/2017.
//  Copyright © 2017 Dorada App Software Ltd. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    var networkController : WeatherAPIRequests = NetworkController()
    
    var forecastWeek = ForecastWeek()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Open Weather", comment: "VC title")
        automaticallyAdjustsScrollViewInsets = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
        let forecastController = ForecastController(networkController: networkController)
        forecastController.getForecast { [weak self] (networkforcast, error) in
            guard let `self` = self else { return }
            self.activityIndicator.stopAnimating()
            if let networkforcast = networkforcast {
                self.forecastWeek = networkforcast
                self.collectionView.reloadData()
            } else if let error = error {
                SimpleAlert.show(fromViewController: self, title: error.localizedDescription, message: nil)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

fileprivate let cellReuseIdentifier = "WeatherCollectionViewCell"
fileprivate let headerReuseIdentifier = "WeatherCollectionViewHeader"

extension WeatherViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let day = forecastWeek.days[section]
        return day.items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        cell.networkController = networkController
        let day = forecastWeek.days[indexPath.section]
        cell.forecast = day.items[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return forecastWeek.days.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! WeatherCollectionViewHeader
        headerView.forecastday = forecastWeek.days[indexPath.section]
        return headerView
    }
}

extension WeatherViewController : UICollectionViewDelegate {
    
}

fileprivate let itemsPerRow: CGFloat = 24.0/3.0
fileprivate let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 14.0, right: 4.0)
fileprivate let cellSpacing: CGFloat = 2.0

extension WeatherViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}
