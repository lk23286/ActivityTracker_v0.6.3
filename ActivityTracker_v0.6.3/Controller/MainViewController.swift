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
    
    var dataStore = DataStore()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainTableViewUp.delegate = self
        mainTableViewUp.dataSource = self
        mainTableViewDown.delegate = self
        mainTableViewDown.dataSource = self
       
        mainTableViewDown.register(UINib(nibName: K.Main.nibName, bundle: nil), forCellReuseIdentifier: K.Main.Identifier.cellDown)
    }

    @IBAction func mainBarAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let index = dataStore.mainTableUpArray.count

        if dataStore.mainTableUpArray.count < K.maxNumberOfMainActivity {
            print(dataStore.mainTableUpArray.count, K.maxNumberOfMainActivity)
            let alert = UIAlertController(title: "Add New Activity", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Activity", style: .default) { [self] (action) in
                
                if textField.text! != "" {
                    
                    dataStore.mainTableUpArray.append(textField.text!)
                    addActivityToDownTable(activity: textField.text!)
                } else {
                    dataStore.mainTableUpArray.append(dataStore.mainTableUpDefaultArray[index])
                    addActivityToDownTable(activity: dataStore.mainTableUpDefaultArray[index])
                }
                mainTableViewUp.reloadData()
                   }
                alert.addTextField { [self] (alertTextField) in
                    
                    alertTextField.placeholder = dataStore.mainTableUpDefaultArray[index]
                    textField = alertTextField
                }
                alert.addAction(action)
                    present(alert, animated: true, completion: nil)
        }
    }

    func addActivityToDownTable(activity: String) {
        
        let downTableRecord = DownTableRecord(activity: activity, achived: "1.0", goal: "2.0", precent: "50%")
        dataStore.mainTableDownArray.append(downTableRecord)
        if dataStore.mainTableDownArray.count == 4 {
            dataStore.mainTableDownArray.append(DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%"))
        }
        mainTableViewDown.reloadData()
    }
  
    @IBAction func mainBarRemoveButtonPressed(_ sender: UIBarButtonItem) {
        
        if dataStore.mainTableUpArray.count == 4 {
            dataStore.mainTableDownArray.remove(at: 4)
            mainTableViewDown.reloadData()
        }
        
        if dataStore.mainTableUpArray.count > 0 {
            dataStore.mainTableUpArray.removeLast()
            mainTableViewUp.reloadData()
            dataStore.mainTableDownArray.remove(at: dataStore.mainTableUpArray.count)
            mainTableViewDown.reloadData()
        }
//        else if dataStore.mainTableUpArray.count == 0   {
//            dataStore.mainTableDownArray.removeAll()
//            mainTableViewDown.reloadData()
//        }
    }
}
    
extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainTableViewUp {
            
print(dataStore.mainTableUpArray.count)
            
            return dataStore.mainTableUpArray.count
            
        }
        
        if tableView == mainTableViewDown {
            return dataStore.mainTableDownArray.count
        }
        return Int()
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainTableViewUp {
            let mainCellUp = tableView.dequeueReusableCell(withIdentifier: K.Main.Identifier.cellUp, for: indexPath)
            mainCellUp.textLabel?.text = dataStore.mainTableUpArray[indexPath.row]
            
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
            
            mainCellDown.activityLabel.text = dataStore.mainTableDownArray[indexPath.row].activity
            mainCellDown.achivedLabel.text = dataStore.mainTableDownArray[indexPath.row].achived
            mainCellDown.separatorLabel.text = dataStore.mainTableDownArray[indexPath.row].separator
            mainCellDown.goalLabel.text = dataStore.mainTableDownArray[indexPath.row].goal
            mainCellDown.unitLabel.text = dataStore.mainTableDownArray[indexPath.row].unit
            mainCellDown.precentLabel.text = dataStore.mainTableDownArray[indexPath.row].precent
            
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
            let activity = dataStore.mainTableDownArray[indexPath.row].activity
            let actualGoal = dataStore.mainTableDownArray[indexPath.row].goal
            let actualyAchived = dataStore.mainTableDownArray[indexPath.row].achived
            
            let alert = UIAlertController(title: "You can modify Goal of", message: activity, preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Goal", style: .default) { [self] (action) in
                let newGoal = textField.text!
                
                if newGoal != "" {
                    dataStore.mainTableDownArray[indexPath.row].goal = newGoal
                    dataStore.mainTableDownArray[indexPath.row].precent =  calculatePrecentFrom(achived: actualyAchived, goal: newGoal)
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


