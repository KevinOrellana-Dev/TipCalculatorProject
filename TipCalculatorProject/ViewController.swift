//
//  ViewController.swift
//
//  Created by admin on 1/20/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //labels
    var lol: String = " "
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var numberOfPersonsLabel: UILabel!
    @IBOutlet weak var totalPerPersonLabel: UILabel!
    @IBOutlet weak var billTxtField: UITextField!
    @IBOutlet weak var percentagesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var customTipButton: UIButton!
    @IBOutlet weak var summaryViewWindow: UIView!
    
    var tipPercentages = [0.05, 0.20, 0.30, 0.0]
    var bill = 0.0
    var splitBillTotal = 0.0
    var tip = 0.0
    var total = 0.0
    var selectedTipPercentage = 0.0
    var customTipInUse = false
    var defaultTipIndex = 0
    var rememberCustomTip = false
    var customTip = 0.0
    
    let defaults = UserDefaults.standard
    
    /*The purpose of this "struct" is to save the keys that are used when loading the information stored in userDefaults */
    struct Keys
    {
        static let defaultTipIndexKey = "defaultTipIndex"
        static let rememberCustomTipKey = "rememberCustomTip"
        static let customTipKey = "customKey"
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        billTxtField.becomeFirstResponder()
        summaryViewWindow.layer.cornerRadius = 20//Make it with rounded edges
        
    }
    
    
    
    //this function, the user preferences stored in "UserDefaults" are loaded into the program
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(true)
        
        //Loading default index
        if let importedDefaultIndex = defaults.object(forKey: Keys.defaultTipIndexKey) as? Int
        {
            
                defaultTipIndex = importedDefaultIndex
                percentagesSegmentedControl.selectedSegmentIndex = defaultTipIndex
            
        }
        
        //Loading whether or not program should save and display the custom tip
        if let importedRemeberCustomTip = defaults.object(forKey: Keys.rememberCustomTipKey) as? Bool
        {
            
            if(importedRemeberCustomTip)
            {
                rememberCustomTip = importedRemeberCustomTip
              
            }
            
        }
        
        //Loading the exact index value of the custom tip
        if let importedCustomKey = defaults.object(forKey: Keys.customTipKey) as? Double
        {
            if(importedCustomKey != 0.0 && percentagesSegmentedControl.numberOfSegments <= 3 && rememberCustomTip)
            {
                
                tipPercentages[3] = importedCustomKey
                
                print("Imported Key!!" + String(importedCustomKey))
                let convertToPercentage = importedCustomKey * 100
                
                //inserting an extra segment in the "percentageSegmentedControl" to display the custom tip to the user
               percentagesSegmentedControl.insertSegment(withTitle:  String(Int(convertToPercentage)) + "%" , at: 3, animated: true)
            }
            
        }

        //synch the tip percentage value to what is selected on the "percentage segmented control"
        determineTipPercentageValue(self)
    }
    
    
    
    //The purpose of this function is to make the keyboard disappear when the user taps outside the "billTextField"
    @IBAction func onTap(_ sender: Any)
    {
        view.endEditing(true)
        
    }
    
    
    //Calculates the tip based on the bill and tip percentages specified by the user
    @IBAction func calculateTip(_ sender: Any)
    {
        
        bill = Double(billTxtField.text!) ?? 0 //gathering user input
        tip = selectedTipPercentage * bill //calculating tip amount
        total  = bill + tip // calculting the total amount to be paid
        splitBill() // spliting bill
        updateVariables()
    }
    
    //This functions syncs the labels that are the displayed in the app with the most current information
    func updateVariables()
    {
        tipLabel.text = String(format: "$%.2f",tip)
        billLabel.text = String(format: "$%.2f", bill)
        totalLabel.text = String(format: "$%.2f", total)
        totalPerPersonLabel.text = String(format: "%.2f", splitBillTotal)
    }
    
    
    //This fuction determines the value of the tip percentage currently selected
    @IBAction func determineTipPercentageValue(_ sender: Any)
    {
        
        selectedTipPercentage = tipPercentages[percentagesSegmentedControl.selectedSegmentIndex]
        
        //If custom tip is no longer to be used, eliminate it from "percentagesSegmentedControl"
        if(percentagesSegmentedControl.selectedSegmentIndex <= 2   &&  !rememberCustomTip)
        {
            percentagesSegmentedControl.removeSegment(at: 3, animated: true)
            
        }
        
        
        calculateTip(self)
    }
    
    //This function splits the total bill between the amount of people specified by the user
    func splitBill()
    {
        
        let numberOfPeople = Double(numberOfPersonsLabel.text!) ?? 0 //gathering user input
        
        if(numberOfPeople != 0)
        {
            
            splitBillTotal = total / numberOfPeople
        }
        
        updateVariables()
        
    }
    
    
    //This function is called everytime the "-" button is pressed. Its purpose is to decrease the amount of people to split the bill.
    @IBAction func subtractNumberOfPeople(_ sender: Any)
    {
        
        var numberOfPeople = Int(numberOfPersonsLabel.text!) ?? 0 //gathering user input
        
        
        if(numberOfPeople > 1)
        {
           numberOfPeople -= 1
            numberOfPersonsLabel.text = String(numberOfPeople)//updating label
        }
        
        
        splitBill()
    }
    
     //This function is called everytime the "+" button is pressed. Its purpose is to increase the amount of people to split the bill.
    @IBAction func addNumberOfPeople(_ sender: Any)
    {
        
        var numberOfPeople = Int(numberOfPersonsLabel.text!) ?? 0
        
        
        if(numberOfPeople < 100)
        {
            numberOfPeople += 1
            numberOfPersonsLabel.text = String(numberOfPeople)
        }
        
        
        splitBill()
    }
    
    
    //This function saves all the user preferences using "UserDefaults". This information will be then loaded back into the program when the users opens a new instance of the app.
    func  saveUserPreferences ()
    {
        defaults.set(defaultTipIndex, forKey: Keys.defaultTipIndexKey)
        defaults.set(rememberCustomTip, forKey: Keys.rememberCustomTipKey)
        defaults.set(tipPercentages[3], forKey: Keys.customTipKey)
    }
    
    
    /*
     VIEW CONTROLLERS
     This code group primarily deals with "pushing" new view controllers into the main interface
     */
    
    //this function presents the custom tip view controller
    @IBAction func specifyCustomTip(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let popup = storyBoard.instantiateViewController(withIdentifier: "SliderPopUp") as! SliderPopUp
        
        popup.delegate = self
        
        //sending information to the popup screen, in order to display the most current data.
        if(tipPercentages[3] != 0.0)
        {
            let value = tipPercentages[3] * 100
            popup.sliderValue = Int(value)
        }
        
        self.present(popup, animated: true)//showing the popup view controler to the user
    }
    

    //this function presents the settings menu
    @IBAction func presentSettingsMenu(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsMenu = storyBoard.instantiateViewController(withIdentifier: "SettingsMenu") as! SettingsViewController
        settingsMenu.delegate = self
        
        //passing information to the view controller to enable it to show the most current data
        settingsMenu.defaultTipPercentageIndex = defaultTipIndex
        settingsMenu.rememberCustomTip = rememberCustomTip
        
        self.navigationController!.pushViewController(settingsMenu, animated: true)//showing the settings view controller
    }
    

}

//These functions are used to pass data back and forth between the view controllers used
extension ViewController: PopUpDelegate, SettingsDelegate
{
    //determining whether or not the programs needs to remember the custom tip specified by the user
    func setRememberCustomTip(value: Bool) {
        rememberCustomTip = value
        saveUserPreferences()
    }
    
    //remembering the deafult tip percentage specified by the user
    func setDefaultTipIndex(value: Int) {
        defaultTipIndex = value
        percentagesSegmentedControl.selectedSegmentIndex = value
        determineTipPercentageValue(self)
        saveUserPreferences()
    }
    
    //Gather the custom tip percentage amount specified by the user
    func popupSetTip(value: Int) {
        
        tipPercentages[3] = (Double(value)) / 100.0
        
       if(percentagesSegmentedControl.numberOfSegments <= 3)//if there is not a segment dedicated to show the custom tip
        {
            percentagesSegmentedControl.insertSegment(withTitle:  String(value) + "%" , at: 3, animated: true)
        }
        else // if there is a segment showing the custom tip
        {
            percentagesSegmentedControl.setTitle(String(value) + "%", forSegmentAt: 3)
        }
        percentagesSegmentedControl.selectedSegmentIndex = 3
        determineTipPercentageValue(self)
    }
}
