//
//  Menu.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 11/03/21.
//
/*
import UIKit
import SideMenu
import FirebaseAuth


class Menu: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    @IBOutlet weak var Tabla: UITableView!
    let firebaseAuth = Auth.auth()
    var Indice = [Miindice]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        view.addSubview(Tabla)
        Tabla.register(UITableViewCell.self, forCellReuseIdentifier: "cellyair")
        self.Tabla.dataSource = self
        self.Tabla.delegate = self
      
        cargarIndice()
    }
    func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
    defaults.removeObject(forKey: key)
    }
    }
 //   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   //     return Indice[section].Titulo
  //  }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Tabla.frame.width, height: 70))
        view.backgroundColor = .red
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 8, height: 40))
        label.text = Indice[section].Titulo
        label.textColor = .white
       // label.font = label.font.withSize(20)
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        view.addSubview(label)
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func cargarIndice() {
        Indice.append(Miindice.init(Titulo: "", SubTitulo: ["Menu del Dia","Carrito","Mis Pedidos"]))
        Indice.append(Miindice.init(Titulo: "Perfil", SubTitulo: ["Mi Cuenta","Cambiar Contraseña","Cerrar Sesion","Administrador"]))
        Indice.append(Miindice.init(Titulo: "Comunicate", SubTitulo: ["Quejas y Sujerencias","Acerca de:"]))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return Indice.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Indice[section].Subtitulo?.count ?? 0
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Tabla.dequeueReusableCell(withIdentifier: "cellyair", for: indexPath)
        cell.textLabel?.text = Indice[indexPath.section].Subtitulo?[indexPath.row]
        cell.imageView?.image = UIImage(systemName: (Indice[indexPath.section].Subtitulo?[indexPath.row])! )
        cell.imageView?.image = UIImage(named: (Indice[indexPath.section].Subtitulo?[indexPath.row])!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Tabla.deselectRow(at: indexPath, animated: true)
        let selectedItem = Indice[indexPath.section].Subtitulo?[indexPath.row]
      
        
      //  delegate?.didSelectMenuItem(name: selectedItem)
        print(selectedItem)
  
      
        switch selectedItem {
        case "Menu del Dia":
            dismiss(animated: true, completion: nil)
        case "Cambiar Contraseña":
            let VC = storyboard?.instantiateViewController(identifier: "CambiarPaswwordVC") as? CambiarPaswwordVC
            self.navigationController?.pushViewController(VC!, animated: true)
            dismiss(animated: true, completion: nil)
        case "Cerrar Sesion":
            do {
              try firebaseAuth.signOut()
                
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "email")
                defaults.synchronize()
                
                
                let VC = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginVC
                self.navigationController?.pushViewController(VC!, animated: true)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            dismiss(animated: true, completion: nil)
        case "Administrador":
            if Auth.auth().currentUser != nil {
              print("usuario Loguiado")
                var s = "Elias"
                if  s == UserDefaults.standard.string(forKey: "Nombre") {
                    print("Mi Nombre es \(s)")
                }
                if  "Martinez" == UserDefaults.standard.string(forKey: "Nombre") {
                    print("Mi Nombre es Yair")
                }
                
                
                let defaults = UserDefaults.standard
                let name = defaults.string(forKey: "Nombre") ?? "Usuario Desconocido"
                let Correo = defaults.string(forKey: "Correo") ?? "Desconocido"
                let age = defaults.integer(forKey: "age") ?? 0
                
                print("mi nombr es \(name) y mi correo es \(Correo) y tengo \(age) Años")
                
             //   Borra el UserDefaul
                resetDefaults()
                
                
                
                
                
            } else {
                print("usuario sin loguear")
            }
            dismiss(animated: true, completion: nil)
         
        case "Acerca de:":
            let VC = storyboard?.instantiateViewController(identifier: "Acercade") as? Acercade
            self.navigationController?.pushViewController(VC!, animated: true)
            dismiss(animated: true, completion: nil)
        default:
            print("Error en el menu")
        }
    }
}
class Miindice {
    var Titulo: String?
    var Subtitulo: [String]?
    
    init(Titulo: String, SubTitulo: [String]) {
        self.Titulo = Titulo
        self.Subtitulo = SubTitulo
    }
 }*/
