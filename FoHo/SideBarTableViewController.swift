//
//  SideBarTableViewController.swift
//  FoHo
//
//  Created by Scott Williams on 5/2/17.
//  Copyright © 2017 FohoDuo. All rights reserved.
//

import UIKit
import CoreData

//Class that allows the user to open a side menu containing
//options to filter a search
class SideBarTableViewController: UITableViewController {
    
    //Strings to be used to fill in the cell options
    let catagories: [String] = ["Diet options", "Allergy options", "Course options", "Cuisine options"]
    let dietOptions: [String] = ["Lacto vegetarian","Ovo vegetarian","Pescetarian","Vegan","Vegetarian"]
    let allergyOptions: [String] = ["Dairy", "Egg", "Gluten", "Peanut", "Seafood", "Sesame", "Soy", "Sulfite", "Tree Nut", "Wheat"]
    let courseOptions: [String] = ["Main Dishes", "Desserts", "Side Dishes", "Lunch and Snacks", "Appetizers", "Salads", "Breads", "Breakfast and Brunch", "Soups", "Beverages", "Condiments and Sauces", "Cocktails"]
    let cuisineOptions: [String] = ["American", "Italian", "Asian", "Mexican", "Southern & Soul Food", "French", "Southwestern", "Barbecue", "Indian", "Chinese", "Cajun & Creole", "English", "Mediterranean", "Greek", "Spanish", "German", "Thai", "Moroccan", "Irish", "Japanese", "Cuban", "Hawaiin", "Swedish", "Hungarian", "Portugese"]
    
    //contains the truth value for each option
    var optionsList: [Bool] = []
    
    
    @IBOutlet weak var timeSwitch: UISwitch!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if timeSwitch.isOn {
            timeLabel.text = String(Int(timeSlider.value)) + " minutes"
        }
        else {
            timeLabel.text = "None"
        }

        
        //load options from the database
        fetch()
    }
    
    //fetches all option values from the database and stores then in optionsList
    func fetch() {
        
        //1) Set app delegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //2) Set managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //3) Set fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Options")
        do {
            let items = try managedContext.fetch(fetchRequest)
            for option in items {
                
                //4) Grab each item from the fetch
                optionsList.append((option.value(forKeyPath: "on") as! Bool))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    //Called only from instances of SideBarTableViewCells
    //reverses the truth value and updates it in the database
    func updateSwitchStates(index: Int) {
        if optionsList[index] == false {
            print("setting to true at ", index)
            optionsList[index] = true
            saveOption(toEdit: true, index: index)
        }
        else {
            optionsList[index] = false
            saveOption(toEdit: false, index: index)
        }
    }
    
    //Updates a record in the database
    func saveOption(toEdit: Bool, index: Int) {
        
        //1) Set app delegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //2) Set managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //3) Set fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Options")
        do {
            let items = try managedContext.fetch(fetchRequest)
            
            //4) Update the specific record with the value in toEdit
            items[index].setValue(toEdit, forKey: "on")
            
            //5) Save the updated entity
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return catagories.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return catagories[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dietOptions.count
        }
        if section == 1 {
            return allergyOptions.count
        }
        if section == 2 {
            return courseOptions.count
        }
        if section == 3 {
            return cuisineOptions.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarCell", for: indexPath) as! SideBarTableViewCell
        if(indexPath.section == 0) {
            
            //set the cell and its switch
            cell.setCell(text: dietOptions[indexPath.row], index: indexPath, sender: self)
            cell.switch.isOn = optionsList[indexPath.row]
        }
        else if indexPath.section == 1 {
            
            //set the cell and its switch, noting that the switch values
            //are after diet's switch values
            cell.setCell(text: allergyOptions[indexPath.row], index: indexPath, sender: self)
            cell.switch.isOn = optionsList[indexPath.row + dietOptions.count]
        }
        else if indexPath.section == 2 {
            
            //set the cell and its switch, noting that the switch values
            //are after diet's switch values
            cell.setCell(text: courseOptions[indexPath.row], index: indexPath, sender: self)
            cell.switch.isOn = optionsList[indexPath.row + dietOptions.count + allergyOptions.count]
        }
        else {
            
            //set the cell and its switch, noting that the switch values
            //are after diet's and course's switch values
            cell.setCell(text: cuisineOptions[indexPath.row], index: indexPath,sender: self)
            cell.switch.isOn = optionsList[indexPath.row + dietOptions.count + allergyOptions.count + courseOptions.count]
        }

        //disable clicking on a cell to highlight it
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func timeOn(_ sender: UISwitch) {
        if timeSwitch.isOn {
            timeLabel.text = String(Int(timeSlider.value)) + " minutes"
        }
        else {
            timeLabel.text = "None"
        }
        tableView.reloadData()
    }
    
    
    @IBAction func sliderChange(_ sender: UISlider) {
        
        if timeSwitch.isOn {
            timeLabel.text = String(Int(timeSlider.value)) + " minutes"
        }
        else {
            timeLabel.text = "None"
        }
        tableView.reloadData()
    }
    
    
    
    
}
