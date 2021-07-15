//
//  DetalleComidaVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez.
//

import UIKit
import FirebaseAuth

var ClaseComida: Ccomida!

class DetalleComidaVC: UIViewController {
    @IBOutlet weak var LabDescripcion: UILabel!
    @IBOutlet weak var ImgComida: UIImageView!
    @IBOutlet weak var LabPrecio: UILabel!
    @IBOutlet weak var LabNombre: UILabel!
    @IBOutlet weak var TxtCantidad: UITextField!
    @IBOutlet weak var BtnSegmentoControlCantidad: UIStepper!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var BtnAgregarComida: UIButton!
    @IBOutlet weak var BtnLocation: UIButton!
    
    let firebaseAuth = Auth.auth()
    var gradient = CAGradientLayer()
    var image = UIImage()
    var name = ""; var tipo = "";var precio = "";var detalles = "";var ventapor = ""
    var Cantidad = "";var SubTotal = "";var SelectPicker = "";
    let litros = ["1/4 Litro","1/2 Litro","3/4 Litro","1 Litro","1 1/2 Litro","2 Litro","2 1/2 Litro"]
    private let Blanco = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    private let Rojo = UIColor(displayP3Red: 254/255, green: 64/255, blue: 64/255, alpha: 1)
    private let Naranja = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 1)
    private let NaranjaClaro = UIColor(displayP3Red: 254/255, green: 250/255, blue: 171/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        // ejecuta la Funcion para traer Datos
        ConfiguraciondeVista()
        TraerDatosLocalesMain()
    }

 func ConfiguraciondeVista() {
        
    

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(3, inComponent: 0, animated: true)
        
        BtnSegmentoControlCantidad.maximumValue = 10
        BtnSegmentoControlCantidad.minimumValue = 1
        
        BtnAgregarComida.backgroundColor = Blanco
        BtnAgregarComida.setTitleColor(Rojo, for: .normal)
        BtnAgregarComida.layer.cornerRadius = 5
        BtnAgregarComida.layer.borderColor = Rojo.cgColor
        BtnAgregarComida.layer.borderWidth = 1
        BtnAgregarComida.clipsToBounds = true
        
     //   BtnLocation.backgroundColor = Blanco
        BtnLocation.layer.cornerRadius = 5
        BtnLocation.layer.borderColor = NaranjaClaro.cgColor
        BtnLocation.layer.borderWidth = 2
        BtnLocation.clipsToBounds = true
        
        // background de la vista
        gradient.frame = view.bounds.intersection(CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height))
        gradient.colors = [UIColor.white.cgColor,  NaranjaClaro.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        
    }
   
    func MiSubTotal(Midouble: Double) {
        let PrecioString = precio
        var NprecioDouble = 0.0
        NprecioDouble = Double(PrecioString)!
        let Operacion = NprecioDouble * Midouble
        print(Operacion)
        SubTotal = String(Operacion)
        LabPrecio.text = SubTotal
    }
    func TraerDatosLocalesMain(){
        LabNombre.text = name
        ImgComida.image = image
        LabPrecio.text = precio
        LabDescripcion.text = detalles
    
        if ventapor == "Litro"{
            pickerView.isHidden = false
            TxtCantidad.isHidden = true
            BtnSegmentoControlCantidad.isHidden = true
        } else if ventapor == "Pieza" {
            BtnSegmentoControlCantidad.isHidden = false
            pickerView.isHidden = true
        }
    }
    @IBAction func CerrarSession(_ sender: Any) {
        do {
          try firebaseAuth.signOut()
    
            let VC = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginVC
            self.navigationController?.pushViewController(VC!, animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
  
    }
    @IBAction func MostrarTienda(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(identifier: "Acercade") as? Acercade
        self.navigationController?.pushViewController(VC!, animated: true)
    
    }
    
   
 
    @IBAction func EscogerLaCantidad(_ sender: UIStepper) {
        TxtCantidad.text = Int(sender.value).description
        let CostoUnitario = Double(TxtCantidad.text!)
        MiSubTotal(Midouble: CostoUnitario!)
    }
}




extension DetalleComidaVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return litros.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return litros[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valorSelecionado = litros[row] as String
        SelectPicker = valorSelecionado;
        switch valorSelecionado {
        case "1/4 Litro": MiSubTotal(Midouble: 0.25);break
        case "1/2 Litro": MiSubTotal(Midouble: 0.5);break
        case "3/4 Litro": MiSubTotal(Midouble: 0.75);break
        case "1 Litro": MiSubTotal(Midouble: 1);break
        case "1 1/2 Litro": MiSubTotal(Midouble: 1.5);break
        case "2 Litro": MiSubTotal(Midouble: 2);break
        case "2 1/2 Litro": MiSubTotal(Midouble: 2.5);break
        default:
            print("Error")
            break
        }
    }
    
}
