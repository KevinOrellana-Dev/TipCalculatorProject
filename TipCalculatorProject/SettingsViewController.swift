//
//  SettingsViewController.swift
//
//  Created by admin on 1/22/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    //variables
    var delegate : SettingsDelegate?
    var rememberCustomTip = false
    var defaultTipPercentageIndex = 0
    
    @IBOutlet weak var percentagesSegmentControl: UISegmentedControl!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        syncSwitch()
        percentagesSegmentControl.selectedSegmentIndex = defaultTipPercentageIndex

        
    }
    
    //this function is called everytime the "percentagesSegmentControl's" value is changed. The purpose of this function is update the users choice on what tip percentage should be set as default
    @IBAction func percentageSegmentControlChange(_ sender: Any) {
        
        defaultTipPercentageIndex = percentagesSegmentControl.selectedSegmentIndex
    }
    
    //this function is called everytime the switch button is presssed. Essentially, everytime this function is called, it changes the value of "rememberCustomTip" to its opposite value.
    @IBAction func switchValueChange(_ sender: Any)
    {
        if(rememberCustomTip)
        {
            rememberCustomTip = false
        }
        else
        {
            rememberCustomTip = true
            
        }
        syncSwitch()
    }
    
    //This function syncs the position of the switchOutlet with the value of "remberCustomTip".
    func syncSwitch()
    {
        if (rememberCustomTip)
        {
            switchOutlet.setOn(true, animated: true)
        }
        else
        {
            switchOutlet.setOn(false, animated: true)
        }
    }

    //This function will be called right before the user decides to go back to the main screen. The purpose of this function is to called the necessary functions to pass data back to the "main" view controller
    override func viewWillDisappear(_ animated: Bool) {
        
        delegate?.setRememberCustomTip(value: rememberCustomTip)
        delegate?.setDefaultTipIndex(value: defaultTipPercentageIndex)
        super.viewWillDisappear(true)
    }
}
