//
//  SelectCityControllerViewController.swift
//  Weather
//
//  Created by Joe on 29/02/20.
//  Copyright © 2020 Joe. All rights reserved.
//

import UIKit

protocol SelectCityDelegate{
    func didChangeCity(city:String)
}

class SelectCityController: UIViewController {

    var currentCity = ""
    var delegate:SelectCityDelegate?
    
    @IBOutlet weak var cityInput: UITextField!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true
            , completion: nil)
    }
    @IBAction func changeCity(_ sender: Any) {
        delegate?.didChangeCity(city:cityInput.text!)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentCityLabel.text = currentCity
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
