//
//  LoginVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez.
//

import UIKit
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import FirebaseInstanceID
import FirebaseMessaging

class LoginVC: UIViewController {
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var BtnEntrar: UIButton!
    
    private let Rojo = UIColor(displayP3Red: 254/255, green: 64/255, blue: 64/255, alpha: 1)
    private var MiToken: String?
    private let DBUsuarioLoguin = Database.database().reference()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Password.delegate = self
        
        RecuperarToken()
        SetupUILogin()
       
        // Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func AddImgUITextField(MiCampoTexto: UITextField, MiImagen: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: MiImagen.size.width, height: MiImagen.size.height))
        leftImageView.image = MiImagen
        leftImageView.tintColor = .lightGray
        MiCampoTexto.leftView = leftImageView
        MiCampoTexto.leftViewMode = .always
    }
    func SetupUILogin(){
        BtnEntrar.backgroundColor = Rojo
        BtnEntrar.setTitleColor(.white, for: .normal)
        BtnEntrar.layer.cornerRadius = 10
        BtnEntrar.layer.borderColor = Rojo.cgColor
        BtnEntrar.layer.borderWidth = 3
        BtnEntrar.clipsToBounds = true
        
        let Userimagen = UIImage(systemName: "person.circle.fill")
        AddImgUITextField(MiCampoTexto: UserName, MiImagen: Userimagen!)
        
        let pasworimagen = UIImage(systemName: "iphone")
        AddImgUITextField(MiCampoTexto: Password, MiImagen: pasworimagen!)
        
    }

    func Logueado() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as?  MainNavigationController else {
            return
        }
        mainNavigationVC.modalPresentationStyle = .fullScreen
        self.present(mainNavigationVC, animated: true, completion: nil)

    }
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
    func GuardarUsuarioenFirebase(auxCorreo: String, auxNombre: String, auxToken: String, auxPrivilegios: String, auxProvedor: String, auxUrlFoto: String, auxEntrega: String)  {
        
            let mUser = Auth.auth().currentUser
            let xpushc = mUser?.uid
        
               let objetoG: [String: Any] = [
                   "correo": auxCorreo as NSObject,
                   "entrega": auxEntrega as Any,
                   "nombre": auxNombre as Any,
                   "privilegios": auxPrivilegios as Any,
                   "provedor": auxProvedor as Any,
                   "token": auxToken as Any,
                   "urlFoto": auxUrlFoto as Any
               ]
            DBUsuarioLoguin.child("Usuarios").child(xpushc!).setValue(objetoG)
        print("Si Guardo Firebase")
    }
 
    @IBAction func EntrarConFace(_ sender: Any) {
    }
    @IBAction func EntrarConGmail(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func OlvideContraseña(_ sender: Any) {
    }
    @IBAction func Registrarse(_ sender: Any) {
    }
    @IBAction func BtnEntrar(_ sender: Any) {
        //1. Validar Datos
            if self.UserName.text == "" || self.Password.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Por favor introduce email y contraseña", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
            //2. Validar en la Base de Datos
                Auth.auth().signIn(withEmail: self.UserName.text!, password: self.Password.text!) { [self] (user, error) in
            //3. Comprobra si existe Error
                    if error == nil {
                    
                        self.Logueado()
                        
                    } else {
            //4. Indicar cual es el Error:
                        
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
    }
    
}




extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // textField.resignFirstResponder()
        UserName.resignFirstResponder()
        Password.resignFirstResponder()
        return true
    }
}



extension LoginVC: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        //  Compruebe si hay un error de inicio de sesión
            if let error = error {
                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                    print("El usuario no ha iniciado sesión antes o desde entonces ha cerrado la sesión.")
                } else {
                    print("\(error.localizedDescription)")
                }
                return
            }
            let MiCorreo = user.profile.email
            // Obtenga el objeto de la credencial utilizando el token de ID de Google y el token de acceso de Google
            guard let authentication = user.authentication else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            // Autenticarse con Firebase usando el objeto de credencial
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Se produce un error al autenticarse con Firebase: \(error.localizedDescription)")
                }
                
                let myTopPostsQuery = self.DBUsuarioLoguin.child("Usuarios").queryOrdered(byChild: "correo").queryEqual(toValue: user.profile.email)
                myTopPostsQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                 
                    if snapshot.exists() {
                        print("El usuario si esta Registrado")
                    } else {
                        print("El usuario no esta Registrado")
                        DispatchQueue.main.async {
                            
                             self.GuardarUsuarioenFirebase(auxCorreo: user.profile.email, auxNombre: user.profile.name, auxToken: user.authentication.idToken, auxPrivilegios: "usuario", auxProvedor: "Goggle",auxUrlFoto: "html", auxEntrega: "local")
                             self.Logueado()
                         }
                    }
                    
                    })
               
                self.Logueado()
            }
    }
    
}
