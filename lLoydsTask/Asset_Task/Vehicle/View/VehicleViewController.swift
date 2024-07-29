//
//  VehicleViewController.swift
//  Asset_Task
//
//  Created by Anasurya on 7/25/24.
//

import UIKit
import iOSDropDown

class VehicleViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var vehicleMakeDropDown: DropDown!
    @IBOutlet weak var manufactureYearDropDown: DropDown!
    @IBOutlet weak var fuelTypeDropDown: DropDown!
    @IBOutlet weak var capacityDropDown: DropDown!
    @IBOutlet weak var qrTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    
    @IBOutlet weak var driverTF: UITextField!
    
    // MARK: - Variables
    var isLoaded: Bool = false
    var vehicle = VehicleViewModel()
    var vehicleTyes = [String]()
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        getVehicleDetails()
        driverTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UICollectionView{
                if let newValue = change?[.newKey]{
                    let newSize = newValue as? CGSize
                    self.collHeight.constant = newSize?.height ?? 0
                }
            }
        }
    }
    
    // MARK: - Functionality
    func registerNib() {
        let nib = UINib(nibName: "VehicleCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "VehicleCollectionViewCell")
    }
    
    // MARK: - API Functionality
    func getVehicleDetails() {
        vehicle.getVehicleDetails { vehicle, error in
            guard error == nil, let vehicle = vehicle else{
                print(error!.description)
                return
            }
            print(vehicle)
            if let vehicle_type = vehicle.vehicle_type{
                self.vehicleTyes = vehicle_type.compactMap({$0.text})
                self.vehicleTyes.insert("More", at: 3)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            if let makes = vehicle.vehicle_make{
                self.vehicleMakeDropDown.optionArray = makes.compactMap({$0.text})
            }
            if let manufactures = vehicle.manufacture_year{
                self.manufactureYearDropDown.optionArray = manufactures.compactMap({$0.text})
            }
            if let fuels = vehicle.fuel_type{
                self.fuelTypeDropDown.optionArray = fuels.compactMap({$0.text})
            }
            if let capacities = vehicle.vehicle_capacity{
                self.capacityDropDown.optionArray = capacities.compactMap({$0.text})
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    @IBAction func qrScannerBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Extensions and Delegates
extension VehicleViewController: QRCodebackDelegate {
    func qrCodeBackTo(vehicle qrCode: String) {
        qrTF.text = qrCode
    }
}

extension VehicleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleTyes.isEmpty ? 0 : (isLoaded ? vehicleTyes.count : 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCollectionViewCell", for: indexPath) as! VehicleCollectionViewCell
            cell.lbl.text = vehicleTyes[indexPath.row]
            if indexPath.item == 3 {
                if isLoaded {
                    cell.img.image = #imageLiteral(resourceName: "minus")
                    cell.lbl.text = "Less"
                } else {
                    cell.img.image = #imageLiteral(resourceName: "plus")
                    cell.lbl.text = "More"
                }
            }else {
                cell.img.image = #imageLiteral(resourceName: "truck")
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            self.isLoaded = self.isLoaded ? false : true
            self.collectionView.reloadData()
        }
    }
}

extension VehicleViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 4
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

