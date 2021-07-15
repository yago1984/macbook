//
//  ComidasListVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 17/02/21.
//

import UIKit
import Firebase
import FirebaseDatabase




    class ComidasListVC: UIViewController {
        let tableView = UITableView()
        var safeArea: UILayoutGuide!
   // let imageIV = CustomImageView()
        var ComidasLista = ["gordas","tacos","hambuerguesas"]
        var MisComidas = [Ccomida]()
        var refT2: DatabaseReference!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
     
        
        refT2 = Database.database().reference().child("ComidaDia/Hoy")
        ObtenerDatosFirebaseT2()
      
       
        
    }
        
        func setupTableView() {
            view.addSubview(tableView)
            
            tableView.register(MenuCell.self, forCellReuseIdentifier: "micell")
            tableView.dataSource = self
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }
  
   
 
   
     

        func ObtenerDatosFirebaseT2() {
            refT2.observe(.childAdded){ [self] (snapshot) in
                let key = snapshot.key
                guard let value = snapshot.value as? [String:AnyObject] else {return}
              //  print ("Esta es la llave \(key) y este es el valor \(value)")
                if let Nombre = value["nombre"] as? String,
                   let Tipo = value["tipo"] as? String,
                   let UrlFotoComida = value["urlFotoComida"] as? String,
                   let Descripcion = value["descripcion"] as? String,
                   let PrecioLitro = value["precioLitro"] as? String,
                   let Ventapor = value["ventapor"] as? String {
                   let comida = Ccomida(IdC: key, Apodo: "yair", Nombre: Nombre, Tipo: Tipo, UrlFotoComida: UrlFotoComida, Descripcion: Descripcion, PrecioLitro: PrecioLitro, Cantidad: "yair", Ventapor: Ventapor)
                  
                    //Comidas.append(comida)
                    MisComidas.append(comida)
                   
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: MisComidas.count-1, section: 0)
                        self.tableView.reloadData()
                    }
                   
                     
                  
                
                }
                
            }
            
        }

}

extension ComidasListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MisComidas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "micell", for: indexPath)
        let comidasmix = MisComidas[indexPath.row]
        guard let menuCell = cell as? MenuCell else {
            return cell
        }
     
     //   menuCell.textLabel?.text = "Hola mundo"
        menuCell.nameLabel.text = comidasmix.Nombre
        menuCell.precioLabel.text = comidasmix.PrecioLitro
        
       
      
        
        return cell
    }
    
    
    
}
