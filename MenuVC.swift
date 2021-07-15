//
//  MenuVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez .
//

import UIKit
import Firebase
import FirebaseDatabase



var ref: DatabaseReference!
var Comidas = [Ccomida]()
var filtered = [Ccomida]()
var searchActive: Bool = false



class MenuVC: UIViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
   @IBOutlet weak var TablaMenu: UITableView! {
        didSet{
            TablaMenu.dataSource = self
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        
        
      
        // ** ESTO ES LO QUE BUSCABA
        TablaMenu.register(MenuCell.self, forCellReuseIdentifier: "cellcomida")
        // TAMBIEN SE CAMBIA EN EL DISEÑO DE MENUTVCELL A MENUCELL
        ref = Database.database().reference().child("ComidaDia/Hoy")
        
        
        ObtenerDatosFirebase()
   
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
        Mifilter(searchText: text)
    }
    func Mifilter(searchText: String) {
      //  filtered = Comidas.filter { $0.Nombre == searchText }
        filtered = Comidas.filter { $0.Nombre.contains(searchText) }
        print(filtered.count)

        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.TablaMenu.reloadData()
        self.TablaMenu.endUpdates()
    }
    
    //FUNCION PARA TRAER TODOS LOS DATOS DE LAS COMIDAS Y MOSTRAR EN LA TABLEVIEW
    func ObtenerDatosFirebase() {
        if Comidas.isEmpty {
            ref.observe(.childAdded){ (snapshot) in
                let key = snapshot.key
                guard let value = snapshot.value as? [String:AnyObject] else {return}
            
                if let Nombre = value["nombre"] as? String,
                   let Tipo = value["tipo"] as? String,
                   let UrlFotoComida = value["urlFotoComida"] as? String,
                   let Descripcion = value["descripcion"] as? String,
                   let PrecioLitro = value["precioLitro"] as? String,
                   let Ventapor = value["ventapor"] as? String {
                   let comida = Ccomida(IdC: key, Apodo: "yair", Nombre: Nombre, Tipo: Tipo, UrlFotoComida: UrlFotoComida, Descripcion: Descripcion, PrecioLitro: PrecioLitro, Cantidad: "yair", Ventapor: Ventapor)
               
                    Comidas.append(comida)
                    let indexPath = IndexPath(row: Comidas.count-1, section: 0)
                    self.TablaMenu.insertRows(at: [indexPath], with: .automatic)
             
                }
            }
        }
    }
}



extension MenuVC: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = TablaMenu.numberOfRows(inSection: 0)
          if indexPath.row == lastRowIndex - 1 {
          }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuCell = MenuCell()
        let exercise : Ccomida
            
           if (searchActive){
               exercise = filtered[indexPath.row] } else { exercise = Comidas[indexPath.row] }
        
        let VC = storyboard?.instantiateViewController(identifier: "DetalleComidaVC") as? DetalleComidaVC
        
        if let url = URL(string: exercise.UrlFotoComida){
             menuCell.imageIV.loadImage(form: url)
       
            if menuCell.imageIV.image != nil {
                let result = menuCell.imageIV.image! as UIImage
                     VC?.name = exercise.Nombre
                     VC?.image = result
                     VC?.tipo = exercise.Tipo
                     VC?.precio = exercise.PrecioLitro
                     VC?.detalles = exercise.Descripcion
                     VC?.ventapor = exercise.Ventapor
          
                self.navigationController?.pushViewController(VC!, animated: true)
    
            } else {
                print("no tiene imagen")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive){
            return filtered.count
        }else {
            return Comidas.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TablaMenu.dequeueReusableCell(withIdentifier: "cellcomida", for: indexPath)

        guard let menuTVCell = cell as? MenuCell else {
            return cell
        }
        
        let exercise : Ccomida
           if (searchActive){
               exercise = filtered[indexPath.row]
           } else {
               exercise = Comidas[indexPath.row]
           }
        menuTVCell.nameLabel.text = exercise.Nombre
        menuTVCell.precioLabel.text = exercise.PrecioLitro
        menuTVCell.tipoLabel.text = exercise.Tipo
        menuTVCell.signoLabel.text = "$"
        if let url = URL(string: exercise.UrlFotoComida){
            menuTVCell.imageIV.loadImage(form: url)
        
        }
           return cell
       }

}


