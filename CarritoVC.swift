//
//  CarritoVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 08/02/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

var refN: DatabaseReference!
var prueba = Ccomida.MiCarrito
var SubtotalCarrito = 0.00

class CarritoVC: UIViewController {
    @IBOutlet weak var LabSubtotal: UILabel!
    @IBOutlet weak var BtnFinCompras: UIButton!
    @IBOutlet weak var BtnSeguir: UIButton!
    private let DBPedido = Database.database().reference()
    var NombrePref = ""; var Entregapref = "";
   
    
    
    
    @IBOutlet weak var TablaMiCarrito: UITableView! {
        didSet{
            TablaMiCarrito.dataSource = self
            TablaMiCarrito.delegate = self
            
        }
    }
    private let Naranja = UIColor(displayP3Red: 248/255, green: 191/255, blue: 70/255, alpha: 1)
    private let Blanco = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        SubtotalCarrito = 0.00
        print(Ccomida.MiCarrito)
        
        TablaMiCarrito.register(CarritoCell.self, forCellReuseIdentifier: "cellcarrito")
        refN = Database.database().reference().child("Negocio")
        MiSession()
        Negocio()
        Totales()
        SetupUICar()
      
      
      
    }
    func SetupUICar() {
        BtnFinCompras.backgroundColor = Naranja
        BtnFinCompras.setTitleColor(.white, for: .normal)
        BtnFinCompras.layer.cornerRadius = 10
        BtnFinCompras.layer.borderColor = Naranja.cgColor
        BtnFinCompras.layer.borderWidth = 3
        BtnFinCompras.clipsToBounds = true
        BtnFinCompras.isEnabled = false
        
        BtnSeguir.backgroundColor = .white
        BtnSeguir.setTitleColor(Naranja, for: .normal)
        BtnSeguir.layer.cornerRadius = 10
        BtnSeguir.layer.borderColor = Naranja.cgColor
        BtnSeguir.layer.borderWidth = 1
        BtnSeguir.clipsToBounds = true
        
  
    }
    func Negocio()  {
    
            refN.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String:AnyObject] else {return}
             let MiEstatus = value["Estatus"] as? String
                
            if MiEstatus == "abierto"{
                self.BtnFinCompras.isEnabled = true
            }else {
                
                let AvisoCerrado = UIAlertController(title: "Atencion", message: "Los Pedidos estan temporalmente fuera de servicio", preferredStyle: .alert)
                AvisoCerrado.addAction(UIAlertAction(title: "Entendido", style: .default,handler: { action in
                    Ccomida.MiCarrito.removeAll()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                }))
               
                self.present(AvisoCerrado, animated: true, completion: nil)
                
            }
    
            })
    }
    func MiSession()  {
        //
        if Auth.auth().currentUser != nil {
            let defaults = UserDefaults.standard
              NombrePref = defaults.string(forKey: "Nombre") ?? "Usuario Desconocido"
              Entregapref = defaults.string(forKey: "Entrega") ?? "local"
           
        }
        else
        {
            print("El usuario no Esta Logueado")
        }
    }
    func Totales() {
        if Ccomida.MiCarrito.isEmpty {
            LabSubtotal.text = "0.00"
        }
        for cuenta in  Ccomida.MiCarrito {
            if cuenta.PrecioLitro != "" {
                let precioenString =  cuenta.PrecioLitro
                
                SubtotalCarrito = Double(precioenString)! + SubtotalCarrito
                LabSubtotal.text = String(SubtotalCarrito)
            }
        }
    }
    func generarNoPedido() -> String {
               //ahorita se escribe
        
              // let randomString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
               let randomS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
               let randomN = "0123456789"
               let a = (String((0..<5).map{ _ in randomN.randomElement()!}))
               let b = (String((0..<1).map{ _ in randomS.randomElement()!}))
               return a + b
             //  return (String((0..<6).map{ _ in randomString.randomElement()!}))
    }
    func generarFecha() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        return(dateFormatter.string(from: date))
    }
  
    
    func Aviso()  {
        let AvisoController = UIAlertController(title: "Importante", message: "Desea Confirmar su Pedido ?", preferredStyle: .alert)
        AvisoController.addAction(UIAlertAction(title: "Confirmar", style: .default,handler: { action in
         
            self.GuardarPedidoenFirebase()
            self.llamarespesifico()
            Ccomida.MiCarrito.removeAll()
            self.EnviarDatosLocales()
            
        }))
        AvisoController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    
        self.present(AvisoController, animated: true, completion: nil)
    }
    func llamarespesifico() {
        // enviar notificacion
    }
    func EnviarDatosLocales()  {
        // Enviar un msj si compro
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func GuardarPedidoenFirebase() {
        let pedidosRemix = Ccomida.MiCarrito
        
        let GidJ = DBPedido.child("LosPedidos").childByAutoId().key
        let mUser = Auth.auth().currentUser
        let NoPedido = generarNoPedido()
        let xidcliente = NombrePref
        let xentregaen = Entregapref
        let xpushc = mUser?.uid
        let xtotalp = String (SubtotalCarrito)
        let xfechap = generarFecha()
            
        let PedidoUno: [String: Any] = [
            "IdClienteP": xidcliente as NSObject,
            "PushCliente": xpushc as Any,
            "TotalP": xtotalp as Any,
            "NumeroP": NoPedido as Any,
            "FechaP": xfechap as Any,
            "EstadoPedido": "procesando" as Any,
            "Entregaen": xentregaen as Any,
         
        ]
         //   DBPedido.child("Usuarios").childByAutoId().setValue(object)
        
        DBPedido.child("Usuarios").child(xpushc!).child("MisPedidos").child(GidJ!).setValue(PedidoUno)
        DispatchQueue.main.async {
            self.DBPedido.child("LosPedidos").child(GidJ!).setValue(PedidoUno, withCompletionBlock: {
                                                            (error:Error?, ref:DatabaseReference) in
                                                            if let error = error {
                                                              print("Los Datos no se Guardaron: \(error).")
                                                            } else {
                                                                var contador = 0
                                                                for pedix in pedidosRemix {
                                                                    print("Este es el nombre de los productos que se pidieron \(pedix.Cantidad) \(pedix.Nombre)  \(pedix.PrecioLitro)")
                                                                    contador = contador + 1
                                                                    let AuxCantidad = pedix.Cantidad
                                                                    let AuxNombre = pedix.Nombre
                                                                    let AuxSubTotal = pedix.PrecioLitro
                                                                    let conta = String (contador)
                                                                    
                                                                    let PedidoUnoDetalle: [String: Any] = [
                                                                        "ConceptoP": AuxNombre as NSObject,
                                                                        "CantidadP": AuxCantidad as Any,
                                                                        "SubTotalP": AuxSubTotal as Any,
                                                                    ]
                                                                    self.DBPedido.child("LosPedidos").child(GidJ!).child("Detalles").child(conta).setValue(PedidoUnoDetalle)
                                                                    self.DBPedido.child("Usuarios").child(xpushc!).child("MisPedidos").child(GidJ!).child("Detalles").child(conta).setValue(PedidoUnoDetalle)
                                                                    
                                                                    print("Datos Guardados Correctamente \(conta) \(contador)")
                                                                }
                                                            
                                                            } })
        }
    }

  
    /*
    func GuardarPedidoenFirebase() {
        let pedidosRemix = Ccomida.MiCarrito
        
        let GidJ = DBPedido.child("LosPedidos").childByAutoId().key
        let mUser = Auth.auth().currentUser
        let NoPedido = generarNoPedido()
        let xidcliente = "Enrique yair"
        let xentregaen = "local"
        let xpushc = mUser?.uid
        let xtotalp = String (SubtotalCarrito)
        let xfechap = generarFecha()
            
        let PedidoUno: [String: Any] = [
            "IdClienteP": xidcliente as NSObject,
            "PushCliente": xpushc as Any,
            "TotalP": xtotalp as Any,
            "NumeroP": NoPedido as Any,
            "FechaP": xfechap as Any,
            "EstadoPedido": "procesando" as Any,
            "Entregaen": xentregaen as Any,
         
        ]
         //   DBPedido.child("Usuarios").childByAutoId().setValue(object)
        
        DBPedido.child("Usuarios").child(xpushc!).child("MisPedidos").child(GidJ!).setValue(PedidoUno) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
              print("Data could not be saved: \(error).")
            } else {
                DispatchQueue.main.sync {
                self.DBPedido.child("LosPedidos").child(GidJ!).setValue(PedidoUno, withCompletionBlock: {
                                                                    (error:Error?, ref:DatabaseReference) in
                                                                    if let error = error {
                                                                      print("Los Datos no se Guardaron: \(error).")
                                                                    } else {
                                                                        var contador = 0
                                                                        for pedix in pedidosRemix {
                                                                            print("Este es el nombre de los productos que se pidieron \(pedix.Cantidad) \(pedix.Nombre)  \(pedix.PrecioLitro)")
                                                                            contador = contador + 1
                                                                            let AuxCantidad = pedix.Cantidad
                                                                            let AuxNombre = pedix.Nombre
                                                                            let AuxSubTotal = pedix.PrecioLitro
                                                                            let conta = String (contador)
                                                                            
                                                                            let PedidoUnoDetalle: [String: Any] = [
                                                                                "ConceptoP": AuxNombre as NSObject,
                                                                                "CantidadP": AuxCantidad as Any,
                                                                                "SubTotalP": AuxSubTotal as Any,
                                                                            ]
                                                                            self.DBPedido.child("LosPedidos").child(GidJ!).child("Detalles").child(conta).setValue(PedidoUnoDetalle)
                                                                            self.DBPedido.child("Usuarios").child(xpushc!).child("MisPedidos").child(GidJ!).child("Detalles").child(conta).setValue(PedidoUnoDetalle)
                                                                            
                                                                            print("Datos Guardados Correctamente \(conta) \(contador)")
                                                                        }
                                                                    
                                                                    } })
                
                
            }
        }
        }
        
        
        
     
    }  */

    @IBAction func SeguirComprando(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func FinzalizarPedido(_ sender: Any) {
        
        
        if Ccomida.MiCarrito.isEmpty {
           print( "El Carrito esta Vacio")
        } else {
            
            //
            // aqui va lo de firstime de la aplicacion
            //
            //
            //
            Aviso()
            
        }
    
      
    }
}




extension CarritoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ccomida.MiCarrito.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MiCarritoItem = Ccomida.MiCarrito[indexPath.row]
        let cell = TablaMiCarrito.dequeueReusableCell(withIdentifier: "cellcarrito", for: indexPath)
        
        guard let MicarritoCell = cell as? CarritoCell else {
            return cell
        }
        MicarritoCell.namexLabel.text = MiCarritoItem.Nombre
        MicarritoCell.cantidadLabel.text = "Cantidad"
        MicarritoCell.cantidadxLabel.text = MiCarritoItem.Cantidad
        MicarritoCell.signopesosxLabel.text = "$"
        MicarritoCell.precioxLabel.text = MiCarritoItem.PrecioLitro
     //   cell.textLabel?.text = MiCarritoItem.Nombre
      //  cell.TxtNombreCarrito.text = MiCarritoItem.Nombre
      //  cell.TxtPrecioCarrito.text = MiCarritoItem.PrecioLitro
       // cell.TxtPiezasCarrito.text = MiCarritoItem.Cantidad
        return cell
    }
}



extension CarritoVC: UITableViewDelegate{
    private func BorrarCell(indexPath: IndexPath){
        
        Ccomida.MiCarrito.remove(at: indexPath.row)
        SubtotalCarrito = 0.00
        TablaMiCarrito.reloadData()
        Totales()
        
        //LabSubtotal.text = String(SubtotalCarrito)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Eliminar") { [weak self] (action, view, completionHandler) in
                                        self?.BorrarCell(indexPath: indexPath)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
}

