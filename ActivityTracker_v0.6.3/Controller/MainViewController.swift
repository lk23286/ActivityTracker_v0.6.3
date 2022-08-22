//
//  ViewController.swift
//  ActivityTracker_v0.6.3
//
//  Created by Laszlo Kovacs on 2022. 08. 19..
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableViewUp: UITableView!
    @IBOutlet weak var mainTableViewDown: UITableView!
    
    var brain = Brain()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainTableViewUp.delegate = self
        mainTableViewUp.dataSource = self
        mainTableViewDown.delegate = self
        mainTableViewDown.dataSource = self
       
        mainTableViewDown.register(UINib(nibName: K.Main.nibName, bundle: nil), forCellReuseIdentifier: K.Main.Identifier.cellDown)
        
        brain.tableUpArrays.append(brain.tableUpEmptyArray)
        brain.tableDownArrays.append(brain.tableDownEmptyArray)
        
        
    }

    @IBAction func mainBarAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let index = brain.tableUpArrays[0].count

        if brain.tableUpArrays[0].count < K.maxNumberOfMainActivity {
            print(brain.tableUpArrays[0].count, K.maxNumberOfMainActivity)
            let alert = UIAlertController(title: "Add New Activity", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Activity", style: .default) { [self] (action) in
                
                if textField.text! != "" {
                    
                    brain.tableUpArrays[0].append(textField.text!)
                    addActivityToDownTable(activity: textField.text!)
                } else {
                    brain.tableUpArrays[0].append(brain.mainTableUpDefaultArray[index])
                    addActivityToDownTable(activity: brain.mainTableUpDefaultArray[index])
                }
                mainTableViewUp.reloadData()
                   }
                alert.addTextField { [self] (alertTextField) in
                    
                    alertTextField.placeholder = brain.mainTableUpDefaultArray[index]
                    textField = alertTextField
                }
                alert.addAction(action)
                    present(alert, animated: true, completion: nil)
        }
    }

    func addActivityToDownTable(activity: String) {
        
        let downTableRecord = DownTableRecord(activity: activity, achived: "1.0", goal: "2.0", precent: "50%")
        brain.tableDownArrays[0].append(downTableRecord)
        if brain.tableDownArrays[0].count == 4 {
            brain.tableDownArrays[0].append(DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%"))
        }
        mainTableViewDown.reloadData()
    }
  
    @IBAction func mainBarRemoveButtonPressed(_ sender: UIBarButtonItem) {
        
        if brain.tableUpArrays[0].count == 4 {
            brain.tableDownArrays[0].remove(at: 4)
            mainTableViewDown.reloadData()
        }
        
        if brain.tableUpArrays[0].count > 0 {
            brain.tableUpArrays[0].removeLast()
            mainTableViewUp.reloadData()
            brain.tableDownArrays[0].remove(at: brain.tableUpArrays[0].count)
            mainTableViewDown.reloadData()
        }
//        else if dataStore.mainTableUpArray.count == 0   {
//            dataStore.tableDownArrays[0].removeAll()
//            mainTableViewDown.reloadData()
//        }
    }
}
    
extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainTableViewUp {
            
print(brain.tableUpArrays[0].count)
            
            return brain.tableUpArrays[0].count
            
        }
        
        if tableView == mainTableViewDown {
            return brain.tableDownArrays[0].count
        }
        return Int()
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainTableViewUp {
            let mainCellUp = tableView.dequeueReusableCell(withIdentifier: K.Main.Identifier.cellUp, for: indexPath)
            mainCellUp.textLabel?.text = brain.tableUpArrays[0][indexPath.row]
            
            switch indexPath.row {
            case 0:
                mainCellUp.textLabel?.textColor = UIColor.green
            case 1:
                mainCellUp.textLabel?.textColor = UIColor.blue
            case 2:
                mainCellUp.textLabel?.textColor = UIColor.yellow
            case 3:
                mainCellUp.textLabel?.textColor = UIColor.gray
            default:
                mainCellUp.textLabel?.textColor = UIColor.white
            }
            mainCellUp.backgroundColor = UIColor.black
            mainCellUp.textLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
            return mainCellUp
        }
        
        if tableView == mainTableViewDown {
            let mainCellDown = tableView.dequeueReusableCell(withIdentifier: K.Main.Identifier.cellDown, for: indexPath) as! MainDownTableViewCell
            
            switch indexPath.row {
            case 0:
                mainCellDown.activityLabel.textColor = UIColor.green
            case 1:
                mainCellDown.activityLabel.textColor = UIColor.blue
            case 2:
                mainCellDown.activityLabel.textColor = UIColor.yellow
            case 3:
                mainCellDown.activityLabel.textColor = UIColor.gray
            case 4:
                mainCellDown.activityLabel.textColor = UIColor.white
            default:
                mainCellDown.activityLabel.textColor = UIColor.blue
            }
            mainCellDown.goalLabel.textColor = UIColor.green
            
            mainCellDown.activityLabel.text = brain.tableDownArrays[0][indexPath.row].activity
            mainCellDown.achivedLabel.text = brain.tableDownArrays[0][indexPath.row].achived
            mainCellDown.separatorLabel.text = brain.tableDownArrays[0][indexPath.row].separator
            mainCellDown.goalLabel.text = brain.tableDownArrays[0][indexPath.row].goal
            mainCellDown.unitLabel.text = brain.tableDownArrays[0][indexPath.row].unit
            mainCellDown.precentLabel.text = brain.tableDownArrays[0][indexPath.row].precent
            
            return mainCellDown
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == mainTableViewUp {
            print(indexPath.row)
            performSegue(withIdentifier: K.Main.Identifier.segue, sender: self)
        }
        if tableView == mainTableViewDown {
            
            var textField = UITextField()
            let activity = brain.tableDownArrays[0][indexPath.row].activity
            let actualGoal = brain.tableDownArrays[0][indexPath.row].goal
            let actualyAchived = brain.tableDownArrays[0][indexPath.row].achived
            
            let alert = UIAlertController(title: "You can modify Goal of", message: activity, preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Goal", style: .default) { [self] (action) in
                let newGoal = textField.text!
                
                if newGoal != "" {
                    brain.tableDownArrays[0][indexPath.row].goal = newGoal
                    brain.tableDownArrays[0][indexPath.row].precent =  calculatePrecentFrom(achived: actualyAchived, goal: newGoal)
                    mainTableViewDown.reloadData()
                }

            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = actualGoal
                textField = alertTextField
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
  
    func calculatePrecentFrom( achived: String, goal: String) -> String {
        
        let achivedNumber = Double(achived) ?? 1.0
        let goalNumber = Double(goal) ?? 1.0
        let percent = achivedNumber / goalNumber

        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        let percentString = formatter.string(from: percent as NSNumber) ?? "---"
       
       
        
print(percentString)
        
        return percentString
        
    }
    
    
    
}


