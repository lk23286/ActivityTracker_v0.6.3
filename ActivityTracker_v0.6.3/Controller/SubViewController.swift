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
    
    @IBAction func subBarAddButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let index = brain.tableUpArrays[i].count

        if brain.tableUpArrays[i].count < K.maxNumberOfActivity {
            print(brain.tableUpArrays[i].count, K.maxNumberOfActivity)
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
 //        else if dataStore.mainTableUpArray.count == 0   {
 //            dataStore.tableDownArrays[i].removeAll()
 //            mainTableViewDown.reloadData()
 //        }
        
    }
    
    

    func addActivityToDownTable(activity: String) {
        
        let downTableRecord = DownTableRecord(activity: activity, achived: "1.0", goal: "2.0", precent: "50%")
        brain.tableDownArrays[i].append(downTableRecord)
        if brain.tableDownArrays[i].count == 4 {
            brain.tableDownArrays[i].append(DownTableRecord(activity: "Break", achived: "1.0", goal: "2.0", precent: "50%"))
        }
        subTableViewDown.reloadData()
    }
    
    
        

    fileprivate func createModels1() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: 20, color: colors[0]),
                PieSliceModel(value: 80, color: colors[1])
            ]
            currentColorIndex = models.count
            return models
        }
 
    fileprivate func createModels2() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: 15, color: colors[2]),
                PieSliceModel(value: 85, color: colors[3])
            ]
            currentColorIndex = models.count
            return models
        }
  
    fileprivate func createModels3() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: 60, color: colors[4]),
                PieSliceModel(value: 40, color: colors[5]),
            ]
            currentColorIndex = models.count
            return models
        }
    
    fileprivate func createModels4() -> [PieSliceModel] {
            let models = [
                PieSliceModel(value: 90, color: colors[6]),
                PieSliceModel(value: 10, color: colors[7])
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
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}


