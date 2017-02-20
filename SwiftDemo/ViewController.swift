//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Han Pham Xuan on 2/19/17.
//  Copyright © 2017 Han Pham Xuan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UITableViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!

    @IBOutlet weak var btnCalPrice: UIButton!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var btnViewMap: UIButton!
    
    private let _locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtFrom.delegate = self;
        
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestWhenInUseAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: ==============UITextFieldDelegate      ==============
    func textFieldDidEndEditing(textField: UITextField) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = textField.text
        
        let searchResult = MKLocalSearch(request: request)
        searchResult.startWithCompletionHandler{
            (response, _) in UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if response == nil || response!.mapItems.isEmpty
            {
                return
            }
            
            print("Count :\(response!.mapItems.count)")
            
            for mapItem in response!.mapItems
            {
                print(mapItem.placemark)
            }
            
            textField.text = self.addressNameFromPlacemark(response!.mapItems.first!.placemark)
        }
    }
    
    func addressNameFromPlacemark(placemark: CLPlacemark) -> String
    {
        let addresses = placemark.addressDictionary!
        let addressLines = [
            addresses["Name"] as! String,
            addresses["State"] as! String,
            addresses["Country"] as! String
        ]
        
        return addressLines .joinWithSeparator(", ")
    }
//MARK: ==============CLLocationManagerDelegate==============
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    
}

