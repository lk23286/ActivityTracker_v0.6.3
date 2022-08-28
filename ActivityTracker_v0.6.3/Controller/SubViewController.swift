//
//  ViewController.swift
//  pieChartStudy_v0.1.1
//
//  Created by Laszlo Kovacs on 2022. 08. 22..
//

import UIKit
import PieCharts

class SubViewController: UIViewController,
                            PieChartDelegate {
    
    //MARK: - Table
    @IBOutlet weak var subTableViewUp: UITableView!
    @IBOutlet weak var subTableViewDown: UITableView!
    
    var brain = Brain()
    var i = 0   // it defines which table..Arrays are used to the the Main Activity View
                // 0: MainActivities
                // 1: SubActivities of first Activity
                // 2: SubActivities of second Activity
                // 3: SubActivities of third Activity
                // 4: SubActivities of fourth Activity
                // 5: SubActivities of break Activity
    
    //MARK: - Pie Chart
    @IBOutlet weak var chartView1: PieChart!
    @IBOutlet weak var chartView2: PieChart!
    @IBOutlet weak var chartView3: PieChart!
    @IBOutlet weak var chartView4: PieChart!
    
    func onGenerateSlice(slice: PieSlice) {}
    func onStartAnimation(slice: PieSlice) {}
    func onEndAnimation(slice: PieSlice) {}
    func onSelected(slice: PieSlice, selected: Bool) {}

    fileprivate static let alpha: CGFloat = 0.5
    let colors = [
        UIColor.green.withAlphaComponent(0.5),
        UIColor.green.withAlphaComponent(0.1),
        
        UIColor.blue.withAlphaComponent(1),
        UIColor.blue.withAlphaComponent(0.1),
        
        UIColor.yellow.withAlphaComponent(1),
        UIColor.yellow.withAlphaComponent(0.1),
        
        UIColor.gray.withAlphaComponent(1),
        UIColor.gray.withAlphaComponent(0.1),
    ]
    
    fileprivate var currentColorIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//MARK: - Table ViewDidLoad
        subTableViewUp.delegate = self
        subTableViewUp.dataSource = self
        subTableViewDown.delegate = self
        subTableViewDown.dataSource = self
       
        subTableViewDown.register(UINib(nibName: K.Main.nibName, bundle: nil), forCellReuseIdentifier: K.Main.Identifier.cellDown)
        
        brain.tableUpArrays.append(brain.tableUpEmptyArray)
        brain.tableDownArrays.append(brain.tableDownEmptyArray)
        
        
//MARK: - Pie Chart ViewDidLoad
        
        self.chartView1.layers = [createPlainTextLayer1(), createTextWithLinesLayer1()]
        chartView1.delegate = self
        chartView1.models = createModels1()
 
        self.chartView2.layers = [createPlainTextLayer2(), createTextWithLinesLayer2()]
                chartView2.delegate = self
                chartView2.models = createModels2()
        
        self.chartView3.layers = [createPlainTextLayer3(), createTextWithLinesLayer3()]
        chartView3.delegate = self
        chartView3.models = createModels3()
   
        self.chartView4.layers = [createPlainTextLayer4(), createTextWithLinesLayer4()]
                chartView4.delegate = self
                chartView4.models = createModels4()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SubviewWillAppear")
        
        print(i)
        let x = brain.tableDownArrays[i]
        
        print(x)
    }
    
    @IBAction func subBarAddButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let index = brain.tableUpArrays[i].count

        if brain.tableUpArrays[i].count < K.maxNumberOfActivity {
           
            let alert = UIAlertController(title: "Add New Activity", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Activity", style: .default) { [self] (action) in
                
                if textField.text! != "" {
                    
                    brain.tableUpArrays[i].append(textField.text!)
                    addActivityToDownTable(activity: textField.text!)
                } else {
                    brain.tableUpArrays[i].append(brain.mainTableUpDefaultArray[index])
                    addActivityToDownTable(activity: brain.mainTableUpDefaultArray[index])
                }
                subTableViewUp.reloadData()
                   }
                alert.addTextField { [self] (alertTextField) in
                    
                    alertTextField.placeholder = brain.mainTableUpDefaultArray[index]
                    textField = alertTextField
                }
                alert.addAction(action)
                    present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func subBarRemovedButtonPressed(_ sender: UIBarButtonItem) {
        
        if brain.tableUpArrays[i].count == 4 {
             brain.tableDownArrays[i].remove(at: 4)
             subTableViewDown.reloadData()
         }
         
         if brain.tableUpArrays[i].count > 0 {
             brain.tableUpArrays[i].removeLast()
             subTableViewUp.reloadData()
             brain.tableDownArrays[i].remove(at: brain.tableUpArrays[i].count)
             subTableViewDown.reloadData()
         }

        
    }
    
    
    func addActivityToDownTable(activity: String) {
        
        
        let downTableRecord = DownTableRecord(activity: activity, achived: "1.0", goal: "2.0", precent: "50%")
        brain.tableDownArrays[i].append(downTableRecord)
        
        let index = brain.tableDownArrays[i].count - 1
        let achived = brain.tableDownArrays[i][index].achived
        let goal = brain.tableDownArrays[i][index].goal
        
        brain.modellValue[index].dark = Double(achived) ?? 0.0
        brain.modellValue[index].light = Double(goal) ?? 0.0
     
        
        if index == 4 {
            brain.tableDownArrays[i].append(DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%"))
        }
        subTableViewDown.reloadData()
    }
    
    
    

    fileprivate func createModels1() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: brain.modellValue[0].dark, color: colors[0]),
                PieSliceModel(value: brain.modellValue[0].light, color: colors[1])
            ]
            currentColorIndex = models.count
            return models
        }
 
    fileprivate func createModels2() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: brain.modellValue[1].dark, color: colors[2]),
                PieSliceModel(value: brain.modellValue[1].light, color: colors[3])
            ]
            currentColorIndex = models.count
            return models
        }
  
    fileprivate func createModels3() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: brain.modellValue[2].dark, color: colors[4]),
                PieSliceModel(value: brain.modellValue[2].light, color: colors[5]),
            ]
            currentColorIndex = models.count
            return models
        }
    
    fileprivate func createModels4() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: brain.modellValue[3].dark, color: colors[6]),
                PieSliceModel(value: brain.modellValue[3].light, color: colors[7])
            ]
            currentColorIndex = models.count
            return models
        }
    
    fileprivate func createPlainTextLayer1() -> PiePlainTextLayer {
           let textLayerSettings = PiePlainTextLayerSettings()
           textLayerSettings.viewRadius = 55
           textLayerSettings.hideOnOverflow = true
           textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
           textLayerSettings.label.textGenerator = {slice in
               return  ""
           }
           let textLayer = PiePlainTextLayer()
           textLayer.settings = textLayerSettings
           return textLayer
       }
    
    fileprivate func createPlainTextLayer2() -> PiePlainTextLayer {
           let textLayerSettings = PiePlainTextLayerSettings()
           textLayerSettings.viewRadius = 55
           textLayerSettings.hideOnOverflow = true
           textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
           textLayerSettings.label.textGenerator = {slice in
               return  ""
           }
           let textLayer = PiePlainTextLayer()
           textLayer.settings = textLayerSettings
           return textLayer
       }
    
    fileprivate func createPlainTextLayer3() -> PiePlainTextLayer {
           let textLayerSettings = PiePlainTextLayerSettings()
           textLayerSettings.viewRadius = 55
           textLayerSettings.hideOnOverflow = true
           textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
           textLayerSettings.label.textGenerator = {slice in
               return  ""
           }
           let textLayer = PiePlainTextLayer()
           textLayer.settings = textLayerSettings
           return textLayer
       }
    
    fileprivate func createPlainTextLayer4() -> PiePlainTextLayer {
           let textLayerSettings = PiePlainTextLayerSettings()
           textLayerSettings.viewRadius = 55
           textLayerSettings.hideOnOverflow = true
           textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
           textLayerSettings.label.textGenerator = {slice in
               return  ""
           }
           
           let textLayer = PiePlainTextLayer()
           textLayer.settings = textLayerSettings
           return textLayer
       }

    fileprivate func createTextWithLinesLayer1() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.black
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return  ""
        }
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
  
    fileprivate func createTextWithLinesLayer2() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.black
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return  ""
        }
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    
    fileprivate func createTextWithLinesLayer3() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.black
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return  ""
        }
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    
    fileprivate func createTextWithLinesLayer4() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.black
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return ""
        }
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }

}

//MARK: - Table
extension SubViewController: UITableViewDataSource, UITableViewDelegate {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if tableView == subTableViewUp {
                
                return brain.tableUpArrays[i].count
                
            }
            
            if tableView == subTableViewDown {
                return brain.tableDownArrays[i].count
            }
            return Int()
            
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if tableView == subTableViewUp {
                let cellUp = tableView.dequeueReusableCell(withIdentifier: K.Sub.Identifier.cellUp, for: indexPath)
                cellUp.textLabel?.text = brain.tableUpArrays[i][indexPath.row]
                
                switch indexPath.row {
                case 0:
                    cellUp.textLabel?.textColor = UIColor.green
                case 1:
                    cellUp.textLabel?.textColor = UIColor.blue
                case 2:
                    cellUp.textLabel?.textColor = UIColor.yellow
                case 3:
                    cellUp.textLabel?.textColor = UIColor.gray
                default:
                    cellUp.textLabel?.textColor = UIColor.white
                }
                cellUp.backgroundColor = UIColor.black
                cellUp.textLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
                return cellUp
            }
            
            if tableView == subTableViewDown {
                let cellDown = tableView.dequeueReusableCell(withIdentifier: K.Sub.Identifier.cellDown, for: indexPath) as! MainDownTableViewCell
                
                switch indexPath.row {
                case 0:
                    cellDown.activityLabel.textColor = UIColor.green
                case 1:
                    cellDown.activityLabel.textColor = UIColor.blue
                case 2:
                    cellDown.activityLabel.textColor = UIColor.yellow
                case 3:
                    cellDown.activityLabel.textColor = UIColor.gray
                case 4:
                    cellDown.activityLabel.textColor = UIColor.white
                default:
                    cellDown.activityLabel.textColor = UIColor.blue
                }
                cellDown.goalLabel.textColor = UIColor.green
                
                cellDown.activityLabel.text = brain.tableDownArrays[i][indexPath.row].activity
                cellDown.achivedLabel.text = brain.tableDownArrays[i][indexPath.row].achived
                cellDown.separatorLabel.text = brain.tableDownArrays[i][indexPath.row].separator
                cellDown.goalLabel.text = brain.tableDownArrays[i][indexPath.row].goal
                cellDown.unitLabel.text = brain.tableDownArrays[i][indexPath.row].unit
                cellDown.precentLabel.text = brain.tableDownArrays[i][indexPath.row].precent
                
                return cellDown
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            
            return true
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if tableView == subTableViewUp {
                performSegue(withIdentifier: K.Sub.Identifier.segue, sender: self)
            }
            if tableView == subTableViewDown {
                
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
                        subTableViewDown.reloadData()
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


