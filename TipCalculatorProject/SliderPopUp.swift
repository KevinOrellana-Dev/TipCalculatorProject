//
//  SliderPopUp.swift
//
//  Created by admin on 1/20/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class SliderPopUp: UIViewController {

    //Variable declarations
    @IBOutlet weak var sliderTipLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    var sliderValue = 30
    var delegate: PopUpDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = Float(sliderValue)
        sliderTipLabel.text = String(sliderValue) + "%"
        
    }
    
    //This function is called everytime the "continueButton" is pressed. The purpose of this function is to pass data back to the main viewer control and pop the current view control from the stack
    @IBAction func saveCustomTip(_ sender: Any)
    {
        delegate?.popupSetTip(value: sliderValue) //passing the slider value back to the main viewer control
        dismiss(animated: true, completion: nil)//going back to the main view controller
    }
    
    
    //this function gets called everytime the "slider" changes value. It essentially syncronizes the value of the slider with "sliderTipLabel"
    @IBAction func sliderValueChange(_ sender: Any)
    {
        sliderValue = Int(slider.value)
        sliderTipLabel.text = String(sliderValue) + "%"
    }


}
