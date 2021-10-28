//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Apple on 10/28/21.
//

import UIKit
import JGProgressHUD

class WeatherVC: UIViewController {
    ///@IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChart!
    ///Varriable
    private let viewModel = WeatherViewModel()
    private let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.noDataLabel.text = "No Data for Selected Data"
        self.noDataLabel.isHidden = true
        getData()
    }

    private func getData() {
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)

        viewModel.fetchForcastAPI {
            DispatchQueue.main.async {
                self.hud.dismiss()
            }
            self.viewModel.hourlyArray = self.viewModel.getHourlyData()
            self.setupCollectioView()
            self.setUpChart()
        } failure: { error in
            print(error)
            DispatchQueue.main.async {
                self.hud.dismiss()
                let alert = UIAlertController(title: "Weather App", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupCollectioView() {
        DispatchQueue.main.async {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
            //Hourly
            self.hourlyCollectionView.dataSource = self
            self.hourlyCollectionView.delegate = self
            self.hourlyCollectionView.reloadData()
        }
    }
    
    private func setUpChart() {
        DispatchQueue.main.async {
            let dataEntries = self.viewModel.generateRandomEntries()
            self.lineChartView.dataEntries = dataEntries
            self.lineChartView.isCurved = true
            self.lineChartView.isHidden = false
        }
    }
}

//MARK:- UICollectionViewDataSource
extension WeatherVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            let count = viewModel.hourlyArray.count
            return count
        } else {
            let count = viewModel.weatherModel?.daily?.count ?? 0
            return (count > 5) ? 5 : count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        if collectionView == hourlyCollectionView {
            let model = viewModel.hourlyArray[indexPath.row]
            let weatherType = model.weather.first?.main ?? ""
            let hour = viewModel.getHourlyDate(model.dt)
            
            if hour == 0 {
                cell.dayLabel.text = "Current"
            } else {
                cell.dayLabel.text = "\(hour)h"
            }
            cell.forcastImageView.image = UIImage.init(named: weatherType)
            cell.tempratureCLabel.text = "\(Int((model.temp)))°"
            cell.tempratureFLabel.text = "\(Int((model.dewPoint)))°"
        }
        else {
            let model = viewModel.weatherModel?.daily?[indexPath.row]
            let weatherType = model?.weather?.first?.main ?? ""
            
            cell.dayLabel.text = viewModel.getDate(model?.dt ?? 0)
            cell.forcastImageView.image = UIImage.init(named: weatherType)
            cell.tempratureCLabel.text = "\(Int((model?.temp.min ?? 0.00)))°"
            cell.tempratureFLabel.text = "\(Int((model?.temp.max ?? 0.00)))°"
        }

        DispatchQueue.main.async {
            if self.viewModel.selectedIndex == indexPath.row && collectionView == self.collectionView {
                cell.viewContent?.backgroundColor = .lightGray.withAlphaComponent(0.1)
                cell.viewContent?.layer.borderWidth =  1.0
                cell.viewContent?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
            } else {
                cell.viewContent?.layer.borderWidth =  0.0
                cell.viewContent?.layer.borderColor = UIColor.clear.cgColor
                cell.viewContent?.backgroundColor = .white
            }
        }
        return cell
    }
}

//MARK:- UICollectionViewDataSource
extension WeatherVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            viewModel.selectedIndex = indexPath.row
            self.viewModel.hourlyArray = self.viewModel.getHourlyData()
            self.collectionView.reloadData()
            self.hourlyCollectionView.reloadData()
            self.noDataLabel.isHidden = !(viewModel.hourlyArray.isEmpty)
            self.hourlyCollectionView.isHidden = (viewModel.hourlyArray.isEmpty)
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

//MARK:- UICollectionViewDataSource
extension WeatherVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing: CGFloat = 10.0
        let cellWidth: CGFloat = (collectionView.frame.size.width / 3.5) - cellSpacing
        let cellHeight: CGFloat = collectionView.frame.size.height * 0.65
        return CGSize.init(width: cellWidth, height: cellHeight)
    }
}
