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
    var i = 0   // it defines which table..Arrays are used to the the Main Activity View
                // 0: MainActivities
                // 1: SubActivities of first Activity
                // 2: SubActivities of second Activity
                // 3: SubActivities of third Activity
                // 4: SubActivities of fourth Activity
                // 5: SubActivities of break Activity

                
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
        let index = brain.tableUpArrays[i].count

        if brain.tableUpArrays[i].count < K.Main.maxNumberOfActivity {
            print(brain.tableUpArrays[i].count, K.Main.maxNumberOfActivity)
            let alert = UIAlertController(title: "Add New Activity", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Activity", style: .default) { [self] (action) in
                
                if textField.text! != "" {
                    
                    brain.tableUpArrays[i].append(textField.text!)
                    addActivityToDownTable(activity: textField.text!)
                } else {
                    brain.tableUpArrays[i].append(brain.mainTableUpDefaultArray[index])
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
        brain.tableDownArrays[i].append(downTableRecord)
        if brain.tableDownArrays[i].count == 4 {
            brain.tableDownArrays[i].append(DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%"))
        }
        mainTableViewDown.reloadData()
    }
  
    @IBAction func mainBarRemoveButtonPressed(_ sender: UIBarButtonItem) {
        
        if brain.tableUpArrays[i].count == 4 {
            brain.tableDownArrays[i].remove(at: 4)
            mainTableViewDown.reloadData()
        }
        
        if brain.tableUpArrays[i].count > 0 {
            brain.tableUpArrays[i].removeLast()
            mainTableViewUp.reloadData()
            brain.tableDownArrays[i].remove(at: brain.tableUpArrays[i].count)
            mainTableViewDown.reloadData()
        }
//        else if dataStore.mainTableUpArray.count == 0   {
//            dataStore.tableDownArrays[i].removeAll()
//            mainTableViewDown.reloadData()
//        }
    }
}
    
extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainTableViewUp {
            
print(brain.tableUpArrays[i].count)
            
            return brain.tableUpArrays[i].count
            
        }
        
        if tableView == mainTableViewDown {
            return brain.tableDownArrays[i].count
        }
        return Int()
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainTableViewUp {
            let mainCellUp = tableView.dequeueReusableCell(withIdentifier: K.Main.Identifier.cellUp, for: indexPath)
            mainCellUp.textLabel?.text = brain.tableUpArrays[i][indexPath.row]
            
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
            
            mainCellDown.activityLabel.text = brain.tableDownArrays[i][indexPath.row].activity
            mainCellDown.achivedLabel.text = brain.tableDownArrays[i][indexPath.row].achived
            mainCellDown.separatorLabel.text = brain.tableDownArrays[i][indexPath.row].separator
            mainCellDown.goalLabel.text = brain.tableDownArrays[i][indexPath.row].goal
            mainCellDown.unitLabel.text = brain.tableDownArrays[i][indexPath.row].unit
            mainCellDown.precentLabel.text = brain.tableDownArrays[i][indexPath.row].precent
            
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
            let activity = brain.tableDownArrays[i][indexPath.row].activity
            let actualGoal = brain.tableDownArrays[i][indexPath.row].goal
            let actualyAchived = brain.tableDownArrays[i][indexPath.row].achived
            
            let alert = UIAlertController(title: "You can modify Goal of", message: activity, preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Goal", style: .default) { [self] (action) in
                let newGoal = textField.text!
                
                if newGoal != "" {
                    brain.tableDownArrays[i][indexPath.row].goal = newGoal
                    brain.tableDownArrays[i][indexPath.row].precent =  calculatePrecentFrom(achived: actualyAchived, goal: newGoal)
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        if let goalNumber = Double(goal) {
           let percent = achivedNumber / goalNumber
           return formatter.string(from: percent as NSNumber) ?? ""
        } else {
          return "???"
        }
    }
    
}


