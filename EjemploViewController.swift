//
//  EjemploViewController.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 12/04/21.
//
/*
import UIKit

class EjemploViewController: UIViewController {
 
    @IBOutlet weak var TablaEjemplo: UITableView!
    
    let data = [["0,0", "0,1", "0,2"], ["1,0", "1,1", "1,2"]]
    let headerTitles = ["Some Data 1", "KickAss"]
    var hiddenSections = Set<Int>()

  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
      

}
}

    extension EjemploViewController: UITableViewDataSource, UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            return data.count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
        
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEjemplo", for: indexPath)
                cell.textLabel?.text = data[indexPath.section][indexPath.row]
          

                return cell
    }
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section < headerTitles.count {
                    return headerTitles[section]
                }
            return nil
        }
    }
        
        */

   import UIKit

   class EjemploViewController: UIViewController {
    








}
