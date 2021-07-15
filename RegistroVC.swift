//
//  RegistroVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez .
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseInstanceID
import FirebaseMessaging



class RegistroVC: UIViewController {
    
    @IBOutlet weak var RNombre: UITextField!
    @IBOutlet weak var RCorreo: UITextField!
    @IBOutlet weak var RPassword: UITextField!
    @IBOutlet weak var RrecordarPass: UITextField!
    @IBOutlet weak var BtnRegistrarse: UIButton!
    @IBOutlet weak var NavigatorYes: UINavigationBar!
    @IBOutlet weak var viewMove: UIView!
    
    private let DBUsuario = Database.database().reference()
    private var MiToken: String?
    private let Rojo = UIColor(displayP3Red: 254/255, green: 64/255, blue: 64/255, alpha: 1)
    var activeTextField : UITextField? = nil
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RecuperarToken()
        SetupUIRegistro()
        
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
        self.NavigatorYes.frame.origin.y = 40
       
     
       }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
      
    }
    
    /*FUNCIONES ELABORADAS*/
    
    // funcion para Mejorar la Vista de ViewController
    func SetupUIRegistro(){
        BtnRegistrarse.backgroundColor = Rojo
        BtnRegistrarse.setTitleColor(.white, for: .normal)
        BtnRegistrarse.layer.cornerRadius = 10
        BtnRegistrarse.layer.borderColor = Rojo.cgColor
        BtnRegistrarse.layer.borderWidth = 3
        BtnRegistrarse.clipsToBounds = true
        
        let Nombreimagen = UIImage(systemName: "person.circle.fill")
        AddImgUITextField(MiCampoTexto: RNombre, MiImagen: Nombreimagen!)
        
        let Rpasworimagen = UIImage(systemName: "iphone")
        AddImgUITextField(MiCampoTexto: RPassword, MiImagen: Rpasworimagen!)
        AddImgUITextField(MiCampoTexto: RrecordarPass, MiImagen: Nombreimagen!)
        
        let Remail = UIImage(systemName: "mail.fill")
        AddImgUITextField(MiCampoTexto: RCorreo, MiImagen: Remail!)
        
    }
    // funcion para recupertar el Token del Dispositivo
    func RecuperarToken() {
        InstanceID.instanceID().instanceID { result, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.MiToken = result.token
            }
        }
    }
    // funcion para Agregarle una imagen a un UITextField
    func AddImgUITextField(MiCampoTexto: UITextField, MiImagen: UIImage){
        
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: MiImagen.size.width, height: MiImagen.size.height))
        
        leftImageView.image = MiImagen
        leftImageView.tintColor = .lightGray
       
        MiCampoTexto.leftView = leftImageView
        MiCampoTexto.leftViewMode = .always
        
    }
    func validarNombre(string: String) -> Bool {
        return !RNombre.text!.isEmpty
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
    }
    func validadContraseña() -> Bool {
        var contraseña: String
        var ContraseñaRepetida: String
        contraseña = RPassword.text ?? "uno"
        ContraseñaRepetida = RrecordarPass.text ?? "dos"
        if contraseña.elementsEqual(ContraseñaRepetida){
            if contraseña.count > 5 && contraseña.count <= 16 {
                return true
            } else{return false}
        } else {return false}
    }
    func GuardarUsuarioenFirebase(correo:String, nombre: String)  {
        
        let mUser = Auth.auth().currentUser
        let xpushc = mUser?.uid
        
        let xcorreo = correo
        let xentrega = "local"
        let xnombre = nombre
        let xprivilegios = "usuario"
        let xprovedor = "Correo"
        let xtoken = MiToken
        let xurl = ""
            
        let object: [String: Any] = [
            "correo": xcorreo as NSObject,
            "entrega": xentrega as Any,
            "nombre": xnombre as Any,
            "privilegios": xprivilegios as Any,
            "provedor": xprovedor as Any,
            "token": xtoken as Any,
            "urlFoto": xurl as Any
        ]
        DBUsuario.child("Usuarios").child(xpushc!).setValue(object)
        
         
           
    }
    func SuscribirNotificacionesFirebase()  {
        Messaging.messaging().subscribe(toTopic: "enviaratodos") { error in
          print("Subscribed to weather topic")
        }
        
    }
    func GuardarPreferencias(auxCorreo: String, auxNombre: String, auxToken: String, auxPrivilegios: String, auxProvedor: String){
        let defaults = UserDefaults.standard
        defaults.setValue(auxCorreo, forKey: "Correo")
        defaults.setValue(auxNombre, forKey: "Nombre")
        defaults.setValue(auxToken, forKey: "Token")
        defaults.setValue(auxPrivilegios, forKey: "Privilegios")
        defaults.setValue(auxProvedor, forKey: "Provedor")
        defaults.synchronize()
    }
    
    
    /* ACCIONES DE LOS BOTONES*/
    
    @IBAction func Cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func BtnRegistrarse(_ sender: Any) {
       
        let AuxCorreo = RCorreo.text
        let AuxNombre = RNombre.text
      
        
        if isValidEmail(email: AuxCorreo!) && validadContraseña() && validarNombre(string: AuxNombre!) {
            Auth.auth().createUser(withEmail: AuxCorreo! , password: RPassword.text!) { authResult, error in
                if let error = error as NSError? {
                        print("Error: \(error.localizedDescription)")
                  } else {
                    
                    self.BtnRegistrarse.isEnabled = false
                    let newUserInfo = Auth.auth().currentUser
                    let email = newUserInfo?.email
                   
                    DispatchQueue.main.async {
                        // Guardar Firebase
                        self.SuscribirNotificacionesFirebase()
                        self.GuardarUsuarioenFirebase(correo: email!, nombre: AuxNombre!)
                        self.GuardarPreferencias(auxCorreo: AuxCorreo!, auxNombre: AuxNombre!, auxToken: self.MiToken!, auxPrivilegios: "usuario", auxProvedor: "Correo")
                    }
                    
                  }
                if Auth.auth().currentUser != nil {
                    let VC = self.storyboard?.instantiateViewController(identifier: "MainNavigationController") as? MainNavigationController
                   VC?.modalPresentationStyle = .fullScreen
                   self.present(VC!, animated: true, completion: nil)
                  
                } else {
                    let ErrorController = UIAlertController(title: "Error", message: "Error: Intenta registrarte nuevamente", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    ErrorController.addAction(defaultAction)
                    self.present(ErrorController, animated: true, completion: nil)
                }
            }
        }
    }
}





extension RegistroVC: UITextFieldDelegate{
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
