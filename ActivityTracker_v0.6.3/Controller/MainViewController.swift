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
        
        // Do any additional setup after loading the view.
    }


    @IBAction func mainBarAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        if dataStore.MainTableUpArray.count < K.maxNumberOfMainActivity {
            
            print(dataStore.MainTableUpArray.count, K.maxNumberOfMainActivity)
            
            let alert = UIAlertController(title: "Add New Activity", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Activity", style: .default) { [self] (action) in
                
                let newActivity = textField.text!
                
                dataStore.MainTableUpArray.append(newActivity)
                mainTableViewUp.reloadData()
                
                addActivityToDownTable(activity: newActivity)
                
for memeber in dataStore.MainTableUpArray {print(memeber)}
                   }
            
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = " Create New Activity"
                    textField = alertTextField
                }
            
                alert.addAction(action)
                    present(alert, animated: true, completion: nil)
        }
    }

    func addActivityToDownTable(activity: String) {
        
        let downTableRecord = DownTableRecord(activity: activity, achived: "1.0", goal: "2.0", precent: "50%")

        dataStore.MainTableDownArray.append(downTableRecord)
        
        
        if dataStore.MainTableDownArray.count == 4 {
            dataStore.MainTableDownArray.append(DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%"))
            
        }
        mainTableViewDown.reloadData()
    }
  
    
    
    @IBAction func mainBarRemoveButtonPressed(_ sender: UIBarButtonItem) {
        
        if dataStore.MainTableUpArray.count > 0 {
            
            dataStore.MainTableUpArray.removeLast()
            mainTableViewUp.reloadData()
            dataStore.MainTableDownArray.remove(at: dataStore.MainTableUpArray.count)
            mainTableViewDown.reloadData()
        }
        else if dataStore.MainTableDownArray.count == 1   {
            dataStore.MainTableDownArray.removeLast()
            mainTableViewDown.reloadData()
        }
        
        print("count: \(dataStore.MainTableDownArray.count)")
        

        
    }
    
}
    


extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainTableViewUp {
            
print(dataStore.MainTableUpArray.count)
            
            return dataStore.MainTableUpArray.count
            
        }
        
        if tableView == mainTableViewDown {
            return dataStore.MainTableDownArray.count
        }
        return Int()
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainTableViewUp {
            let mainCellUp = tableView.dequeueReusableCell(withIdentifier: K.Main.Identifier.cellUp, for: indexPath)
            mainCellUp.textLabel?.text = dataStore.MainTableUpArray[indexPath.row]
            
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
            
            mainCellDown.activityLabel.text = dataStore.MainTableDownArray[indexPath.row].activity
            mainCellDown.achivedLabel.text = dataStore.MainTableDownArray[indexPath.row].achived
            mainCellDown.separatorLabel.text = dataStore.MainTableDownArray[indexPath.row].separator
            mainCellDown.goalLabel.text = dataStore.MainTableDownArray[indexPath.row].goal
            mainCellDown.unitLabel.text = dataStore.MainTableDownArray[indexPath.row].unit
            mainCellDown.precentLabel.text = dataStore.MainTableDownArray[indexPath.row].precent
            
            return mainCellDown
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if tableView == mainTableViewUp {
//
//            if editingStyle == .delete {
//
//                dataStore.MainTableUpArray.remove(at: indexPath.row)
//                mainTableViewUp.deleteRows(at: [indexPath], with: .fade)
//
//                removeLineFromDownTable(at: indexPath.row)
//
//            } else if editingStyle == .insert {
//                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//            }
//
//                   }
//    }
    
//    func removeLineFromDownTable(at index: Int) {
//        dataStore.MainTableDownArray.remove(at: index)
//        mainTableViewDown.reloadData()
//    }
    
    
    
    
}


