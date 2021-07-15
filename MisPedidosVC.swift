//
//  MisPedidosVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 20/03/21.
//





import UIKit
import Firebase
import FirebaseDatabase

var refP: DatabaseReference!

class MisPedidosVC: UIViewController {
    @IBOutlet weak var BtnllamaralNegocio: UIButton!
    @IBOutlet weak var BtnSalirMispedidos: UIButton!
    @IBOutlet weak var TablaPedidos: UITableView!
    var ExpanderButton: UIButton!
    var Bandera: Bool!
    var cerrar = UIImage(systemName: "chevron.forward")
    var abrir = UIImage(systemName: "chevron.down")

    
    private let Naranja = UIColor(displayP3Red: 248/255, green: 191/255, blue: 70/255, alpha: 1)
    var MisPedidosdos = [Ccomida]()

 /*
    var PedidosEstru = [MiPedidoEstructura]()
    struct MiPedidoEstructura {
        var NoPedido: String
        var EstadodelPedido: String
        var pedido: [Ccomida]
        
        
        init(NoPedido: String,EstadodelPedido: String, pedido: [Ccomida]) {
            self.NoPedido = NoPedido
            self.EstadodelPedido = EstadodelPedido
            self.pedido = pedido
        
          }
      
    }
*/
    var PedidosEstructura = [MiPedidodeEstructura]()
   // var twoDimensionalArray = [ExpandableNames]()
    struct MiPedidodeEstructura {
   // struct ExpandableNames {
        var NoPedido: String
        var EstadodelPedido: String
        var isExpanded: Bool
        let Elpedido: [Ccomida]
        
        init(NoPedido: String,EstadodelPedido: String,isExpanded: Bool, Elpedido: [Ccomida]) {
            self.NoPedido = NoPedido
            self.EstadodelPedido = EstadodelPedido
            self.Elpedido = Elpedido
            self.isExpanded = isExpanded
            
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        let mUser = Auth.auth().currentUser
        let xpushc = mUser?.uid
        ref = Database.database().reference().child("Usuarios").child(xpushc!).child("MisPedidos")
        refP = Database.database().reference().child("Usuarios").child(xpushc!).child("MisPedidos")
        
        
        GetDatosFirebase()

        TablaPedidos.register(MisPedidosCell.self, forCellReuseIdentifier: "cellpedido")
       
        setupUIMisPedidos()
        
       
      Bandera = true
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let NumeroDePedidos = self.PedidosEstructura.count
        if NumeroDePedidos != 0 {
            self.CerrarTodo(secciones: NumeroDePedidos)
          
        }
       Bandera = false
     
    }
    func CerrarTodo( secciones:Int) {
            
            for i in 0...secciones - 1 {
                cerrarTodasSecciones(sender: i)
             
             
            }
        }
  
    func setupUIMisPedidos() {
        BtnllamaralNegocio.backgroundColor = Naranja
        BtnllamaralNegocio.setTitleColor(.white, for: .normal)
        BtnllamaralNegocio.layer.cornerRadius = 10
        BtnllamaralNegocio.layer.borderColor = Naranja.cgColor
        BtnllamaralNegocio.layer.borderWidth = 3
        BtnllamaralNegocio.clipsToBounds = true
        
        BtnSalirMispedidos.backgroundColor = .white
        BtnSalirMispedidos.setTitleColor(Naranja, for: .normal)
        BtnSalirMispedidos.layer.cornerRadius = 10
        BtnSalirMispedidos.layer.borderColor = Naranja.cgColor
        BtnSalirMispedidos.layer.borderWidth = 1
        BtnSalirMispedidos.clipsToBounds = true
    }
    func GetDatosFirebase(){
      //
        refP.observeSingleEvent(of:.value) { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let dict = child.value as? [String:AnyObject] ?? [:]
                
                if let Xpedido = dict["NumeroP"] as? String{
                   let Xestado = dict["EstadoPedido"] as? String
                   let AuxDetalle = dict["Detalles"] as? [AnyObject]
                
                    for i in 1 ..< AuxDetalle!.count {
                        let a = AuxDetalle![i] as? [String:AnyObject]
                        let a1 = a!["ConceptoP"] as? String
                        let a2 = a!["CantidadP"] as? String
                        let a3 = a?["SubTotalP"] as? String
            
                self.MisPedidosdos.append(Ccomida(Carrito:  a1!, PrecioLitro:  a3!, Cantidad: a2!))
                  
              //          MiPedidodeEstructura(isExpanded: true, Elpedido: [Ccomida(Carrito: a1!, PrecioLitro: a2!, Cantidad: a3!)])
                    }
              //      self.PedidosEstructura.append(contentsOf: [MiPedidodeEstructura(isExpanded: true, Elpedido: self.MisPedidosdos)])
                 
                    self.PedidosEstructura.append(contentsOf: [MiPedidodeEstructura(NoPedido: Xpedido, EstadodelPedido: Xestado!, isExpanded: true, Elpedido: self.MisPedidosdos)])
                    
                    
                    
               //     self.PedidosEstru.append(contentsOf: [MiPedidoEstructura(NoPedido: Xpedido, EstadodelPedido: Xestado!, pedido: self.MisPedidosdos)])
                    
                  
                    self.MisPedidosdos.removeAll()
            
       }
            self.TablaPedidos.reloadData()
                
                
                
   //     self.TablaPedidos.insertRows(at: [IndexPath(row: self.PedidosEstru.count-1, section: self.PedidosEstru.count)], with: UITableView.RowAnimation.automatic)
    }
        }
    }
     /*      ESTO FUNCIONA SOLO SI QUIERES TENER ESCUCHANDO EN TODO MOMENTO EL CODIGO DE ARRIBA SOLO CUANDO SE EJECUTA LA FUNCION
      //
       refP.observe(.childAdded){ [self] (snapshot) in
      // este observador se lo quite para que deje de estar escuchando simepre
            guard let value = snapshot.value as? [String:AnyObject] else {return}

                if let Xpedido = value["NumeroP"] as? String{
                let AuxDetalle = value["Detalles"] as? [AnyObject]
                
                    for i in 1 ..< AuxDetalle!.count {
                        let a = AuxDetalle![i] as? [String:AnyObject]
                        let a1 = a!["ConceptoP"] as? String
                        let a2 = a!["CantidadP"] as? String
                        let a3 = a?["SubTotalP"] as? String
            
                self.MisPedidosdos.append(Ccomida(Carrito:  a1!, PrecioLitro:  a3!, Cantidad: a2!))
                    
      
        }
                    self.PedidosEstru.append(contentsOf: [MiPedidoEstructura(NoPedido: Xpedido, pedido: self.MisPedidosdos)])
                    self.MisPedidosdos.removeAll()
                    
                   
       }
            
            self.TablaPedidos.reloadData()
         
    }
     
    }
   */
    @IBAction func BtnLlamarNegocio(_ sender: Any) {
        
        if let url = URL(string: "tel://\("4921131849")") {
          UIApplication.shared.openURL(url)
        }
     
    }
    @IBAction func BtnSalirMisPedidos(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
}






extension MisPedidosVC: UITableViewDelegate,UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        return PedidosEstructura.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !PedidosEstructura[section].isExpanded {
            return 0
        }
        return PedidosEstructura[section].Elpedido.count
    }
   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TablaPedidos.dequeueReusableCell(withIdentifier: "cellpedido", for: indexPath)
      
        guard let MipedidoCell = cell as? MisPedidosCell else {
                    return cell
                }
      //  MipedidoCell.milabuno.text = self.PedidosEstru[indexPath.section].pedido[indexPath.row].Nombre
        //MipedidoCell.milabdos.text = self.PedidosEstru[indexPath.section].pedido[indexPath.row].Cantidad
        MipedidoCell.milabuno.text = self.PedidosEstructura[indexPath.section].Elpedido[indexPath.row].Nombre
        MipedidoCell.milabdos.text = self.PedidosEstructura[indexPath.section].Elpedido[indexPath.row].Cantidad
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                var Ecirculo = ""
                let estadop = PedidosEstructura[section].EstadodelPedido
                switch estadop {
                case "procesando": Ecirculo = "circulonaranja"
                case "listo": Ecirculo = "circuloverde"
                case "visto": Ecirculo = "circuloazul"
                case "error": Ecirculo = "circulorojo"
                case "entregado": Ecirculo = "google"
                default:
                    Ecirculo = "circulorojo"
                }
                let miimagen = UIImage(named: Ecirculo)
              
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
                view.backgroundColor = .white
                view.layer.cornerRadius = 15
                view.layer.borderColor = .init(red: 248/255, green: 191/255, blue: 70/255, alpha: 0.5)
                view.layer.borderWidth = 3
                view.clipsToBounds = true
                
                
                ExpanderButton = UIButton(frame: CGRect(x: 15, y: 10, width: 32, height: 32))
                ExpanderButton.tintColor = .systemBlue
                if Bandera == true {
                    ExpanderButton.setImage(cerrar, for: .normal)
                } else {
                    let isExpanded = PedidosEstructura[section].isExpanded
                    ExpanderButton.setImage(isExpanded ? abrir : cerrar, for: .normal)
                }
              
                ExpanderButton.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
                ExpanderButton.tag = section
              
                let imagenView = UIImageView(image: miimagen)
                imagenView.frame = CGRect(x: 300, y: 10, width: 35, height: 35)
                
              
                let label = UILabel(frame: CGRect(x: 90, y: 10, width: view.frame.width - 8, height: 40))
                label.text = PedidosEstructura[section].NoPedido
                label.textColor = .systemBlue
                label.font = UIFont.boldSystemFont(ofSize: 22.0)
                
                
                view.addSubview(label)
                view.addSubview(ExpanderButton)
                view.addSubview(imagenView)
                
        return view
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
       
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in PedidosEstructura[section].Elpedido.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = PedidosEstructura[section].isExpanded
        PedidosEstructura[section].isExpanded = !isExpanded
     
        button.tintColor = .systemBlue
        button.setImage(isExpanded ? cerrar : abrir, for: .normal)
        
        if isExpanded {
            TablaPedidos.deleteRows(at: indexPaths, with: .fade)
        } else {
            TablaPedidos.insertRows(at: indexPaths, with: .fade)
        }
    }
    private func cerrarTodasSecciones (sender: Int){
      
        let section = sender

        var indexPaths = [IndexPath]()
        for row in PedidosEstructura[section].Elpedido.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = PedidosEstructura[section].isExpanded
        PedidosEstructura[section].isExpanded = !isExpanded
        

        if isExpanded {
            TablaPedidos.deleteRows(at: indexPaths, with: .fade)
        } else {
            TablaPedidos.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    }
    
    





 
 

 
 

 
 
 

 




