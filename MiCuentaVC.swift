//
//  MiCuentaVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 18/03/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

class MiCuentaVC: UIViewController {
    @IBOutlet weak var MiImagenP: UIImageView!
    @IBOutlet weak var MyFullName: UILabel!
    @IBOutlet weak var MyEmail: UILabel!
    @IBOutlet weak var MyNumberPhone: UITextField!
    @IBOutlet weak var BtnEditarPerfil: UIButton!
    @IBOutlet weak var BtnSalirPerfil: UIButton!
    @IBOutlet weak var BtnGuardaPerfil: UIButton!
    @IBOutlet weak var ViewDomicilio: UIView!
    @IBOutlet weak var SegmentEntrega: UISegmentedControl!
    @IBOutlet weak var MyColonia: UITextField!
    @IBOutlet weak var MyCalle: UITextField!
    @IBOutlet weak var MyNumero: UITextField!
    
    private let DBUsuarioLoguin = Database.database().reference()
    
    var gradient = CAGradientLayer()
    private let Naranja = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 1)
    private let Verde = UIColor(displayP3Red: 105/255, green: 255/255, blue: 65/255, alpha: 1)
    private let colorAzulclaro = UIColor(displayP3Red: 56/255, green: 117/255, blue: 233/255, alpha: 1)
    private let NaranjaClaro = UIColor(displayP3Red: 254/255, green: 250/255, blue: 171/255, alpha: 1)
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SegmentEntrega.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        MyNumberPhone.delegate = self
        MyColonia.delegate = self
        MyCalle.delegate = self
        MyNumero.delegate = self
        Session()
        

        // Do any additional setup after loading the view.
    //    MiPerfil()
        SetupUIPerfil()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
 
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
         }
        
         var shouldMoveViewUp = false
         // if active text field is not nil
         if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
           // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
             shouldMoveViewUp = true
           }
         }
        
         if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
         }
       }
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
     
       
     
       }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
      
    }
    func MiPerfil() {
      
        
            let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
            let fullName = user.profile.name
            let email = user.profile.email
            MyFullName.text = fullName?.description
            MyEmail.text = email?.description
        // descargar la imagen
        /*    if user.profile.hasImage {
            let userDP = user.profile.imageURL(withDimension: 200)
                
            self.sampleImageView.sd_setImage(with: userDP, placeholderImage: UIImage(named: “default-profile”))
            } else {
            self.sampleImageView.image = UIImage(named: “default-profile”)
             */      
        }
    func Session(){
        if Auth.auth().currentUser != nil {
            let defaults = UserDefaults.standard
             let Nombre = defaults.string(forKey: "Nombre") ?? "Usuario Desconocido"
             let Correo = defaults.string(forKey: "Correo") ?? nil
            if Correo != nil {
                MiQuery(Correo: Correo!)
                self.MyFullName.text = Nombre
                self.MyEmail.text = Correo
            }
        }
        else
        {
            print("El usuario no Esta Logueado")
        }
    }
    func MiQuery(Correo: String) {
       
        let myTopPostsQuery = self.DBUsuarioLoguin.child("Usuarios").queryOrdered(byChild: "correo").queryEqual(toValue: Correo)
        myTopPostsQuery.observeSingleEvent(of: .value, with: { [self] (snapshot) in
         
            if snapshot.exists() {
                guard let value = snapshot.value as? [String:AnyObject] else {return}
              //  print ("Esta es la llave \(key) y este es el valor \(value)")
                var Telefono = ""; var Colonia = ""; var Calle = ""; var NumeroCasa = ""; var URlFoto = ""; var Entregaen = ""
                for dato in  value.values {
                
                    Telefono = dato["telefono"] as? String ?? "nil"
                    Colonia = dato["colonia"] as? String ?? "nil"
                    Calle = dato["calle"] as? String ?? "nil"
                    NumeroCasa = dato["numerocasa"] as? String ?? "nil"
                    URlFoto = dato["urlFoto"] as? String ?? "nil"
                    Entregaen = dato["entrega"] as? String ?? ""
                }
               
                    //codigo
                if Entregaen != "" {
                    if Entregaen == "domicilio"{
                       
                        SegmentEntrega.selectedSegmentIndex = 1
                        ViewDomicilio.isHidden = false
                    }
                }
                if Telefono != "nil" {
                    self.MyNumberPhone.text = Telefono
                }
                if Colonia != "nil" {
                    self.MyColonia.text = Colonia
                }
                if Calle != "nil" {
                    self.MyCalle.text = Calle
                }
                if NumeroCasa != "nil" {
                    self.MyNumero.text = NumeroCasa
                }
                if URlFoto != "nil" {
                    self.CargarImagen(miURL: URlFoto)
                }
             
            } else {
                print("La Consulta fue nula")
               
            }
            
            })
        
    }
    func ActualizarDatos(micorreo: String) {
        
        
        let myTopPostsQuery = self.DBUsuarioLoguin.child("Usuarios").queryOrdered(byChild: "correo").queryEqual(toValue: micorreo)
        myTopPostsQuery.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            var AuxTelefono = "";  var AuxColonia = ""; var AuxCalle = ""; var AuxNumero = ""; var AuxEstado = ""
            
            if snapshot.exists() {
                AuxTelefono = MyNumberPhone.text ?? ""
                AuxColonia = MyColonia.text ?? ""
                AuxCalle = MyCalle.text ?? ""
                AuxNumero = MyNumero.text ?? ""
             
            if SegmentEntrega.selectedSegmentIndex == 0{
                AuxEstado = "local"
            } else {
                AuxEstado = "domicilio"
            }
        print (AuxTelefono, AuxColonia, AuxEstado, AuxCalle, AuxNumero)
    
            }
            
            let mUser = Auth.auth().currentUser
            let xpushc = mUser?.uid
        
               let updateUsuario: [String: Any] = [
                   "telefono": AuxTelefono as NSObject,
                   "colonia": AuxColonia as Any,
                   "calle": AuxCalle as Any,
                   "numerocasa": AuxNumero as Any,
                   "entrega": AuxEstado as Any,
                  
               ]
 
            DBUsuarioLoguin.child("Usuarios").child(xpushc!).updateChildValues(updateUsuario)
            updateshare(auxColonia: AuxColonia,auxCalle: AuxCalle,auxNumero: AuxNumero,auxTelefono: AuxTelefono,auxEstado: AuxEstado)
            
        
            
            
            
        }
        )
    }
    func updateshare(auxColonia: String,auxCalle: String, auxNumero: String, auxTelefono: String, auxEstado: String)  {
      
        let defaults = UserDefaults.standard
        defaults.setValue(auxColonia, forKey: "Colonia")
        defaults.setValue(auxCalle, forKey: "Calle")
        defaults.setValue(auxNumero, forKey: "Numero")
        defaults.setValue(auxTelefono, forKey: "Telefono")
        defaults.setValue(auxEstado, forKey: "Entrega")
        defaults.synchronize()

    }
    func BorrarCampos() {
        MyNumero.text = ""
        MyNumberPhone.text = ""
        MyColonia.text = ""
        MyCalle.text = ""
        
    }
    func CamposVacios()-> Bool {
        if MyColonia.text!.count >= 5 && MyCalle.text!.count >= 5 && MyNumero.text!.count >= 1{
            return false
        }
        return true
    }
    func AvisoantesdeSalir()  {
        let alert = UIAlertController(title: "Atencion", message: "Tienes que agregar una direccion valida", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))

        self.present(alert, animated: true)

      
    }
    func GuardarUsuario()  {
        BtnSalirPerfil.isEnabled = false
        BtnEditarPerfil.isEnabled = false
        
        ActualizarDatos(micorreo: MyEmail.text!)
        BtnGuardaPerfil.isEnabled = false
        BtnGuardaPerfil.layer.borderColor = colorAzulclaro.cgColor
        
        BtnSalirPerfil.isEnabled = true
        BtnEditarPerfil.isEnabled = true
    }
 
    
    var task: URLSessionDataTask!
    func CargarImagen (miURL: String){
    
        if let url = URL(string: miURL){
          
            task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               guard let data = data,
                     let newImage = UIImage(data: data)
               
               
               else {
                     print("no se cargo la imagen ")
                     return
               }
                DispatchQueue.main.async {
                 //   let resizable = newImage.resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), resizingMode: .stretch)
                   
                    self.MiImagenP.image = newImage
                    self.MiImagenP.layer.cornerRadius = (self.MiImagenP.frame.size.width ?? 0.0) / 2
                  //  self.MiImagenP.layer.borderWidth = 3.0
                    
                    //self.MiImagenP.contentMode = .scaleAspectFit
                    self.MiImagenP.clipsToBounds = true
                    
                 
                    
                   
                    
                    
                }
            }
            task.resume()
        }
    }
    func SetupUIPerfil(){
        MyFullName.adjustsFontSizeToFitWidth = true
        MyEmail.adjustsFontSizeToFitWidth = true
       
        ViewDomicilio.isHidden = true
        
        BtnSalirPerfil.backgroundColor = .white
        BtnSalirPerfil.setTitleColor(Naranja, for: .normal)
        BtnSalirPerfil.layer.cornerRadius = 5
        BtnSalirPerfil.layer.borderColor = Naranja.cgColor
        BtnSalirPerfil.layer.borderWidth = 3
        BtnSalirPerfil.clipsToBounds = true
        
        BtnEditarPerfil.backgroundColor = Naranja
        BtnEditarPerfil.setTitleColor(.white, for: .normal)
        BtnEditarPerfil.layer.cornerRadius = 5
        BtnEditarPerfil.layer.borderColor = Naranja.cgColor
        BtnEditarPerfil.layer.borderWidth = 3
        BtnEditarPerfil.clipsToBounds = true
        
        BtnGuardaPerfil.backgroundColor = Verde
        BtnGuardaPerfil.setTitleColor(.white, for: .normal)
        BtnGuardaPerfil.layer.cornerRadius = 5
        BtnGuardaPerfil.layer.borderColor = Verde.cgColor
        BtnGuardaPerfil.layer.borderWidth = 3
        BtnGuardaPerfil.clipsToBounds = true
        
        
        gradient.frame = view.bounds.intersection(CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height))
        gradient.colors = [UIColor.white.cgColor,  NaranjaClaro.cgColor]
          view.layer.insertSublayer(gradient, at: 0)
        
    }
 
    @IBAction func Entrega_segment(_ sender: Any) {
        switch SegmentEntrega.selectedSegmentIndex
            {
            case 0:
                ViewDomicilio.isHidden = true
            case 1:
                ViewDomicilio.isHidden = false
            default:
                break
            }
    }
    @IBAction func BtnEPerfil(_ sender: Any) {
        BorrarCampos()
        BtnGuardaPerfil.isEnabled = true
        BtnGuardaPerfil.layer.borderColor = Verde.cgColor
    }
    @IBAction func BtnGPerfil(_ sender: Any) {
        if SegmentEntrega.selectedSegmentIndex == 0 {
        
            GuardarUsuario()
        }
        if SegmentEntrega.selectedSegmentIndex == 1 {
            if CamposVacios() {
               AvisoantesdeSalir()
            } else {
        GuardarUsuario()
            
        }
        }
        
       
        
    }
    @IBAction func BtnSPerfil(_ sender: Any) {
      /*
        if SegmentEntrega.selectedSegmentIndex == 1 {
          //  let a = CamposVacios()
            if CamposVacios() {
               AvisoantesdeSalir()
                
            } else {
                let Maildos = MyEmail.text!
                ActualizarDatos(micorreo: Maildos)
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
            
        } else {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        
       */
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
}

          
   


extension MiCuentaVC: UITextFieldDelegate{
    // when user select a textfield, this method will be called
     func textFieldDidBeginEditing(_ textField: UITextField) {
            self.activeTextField = textField
     }
     // when user click 'done' or dismiss the keyboard
     func textFieldDidEndEditing(_ textField: UITextField) {
       self.activeTextField = nil
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
