//
//  QuejasVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 18/03/21.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth


class QuejasVC: UIViewController{
    private let database = Database.database().reference()
    @IBOutlet weak var BtnEnviarQ: UIButton!
    @IBOutlet weak var BtnSalirQ: UIButton!
    @IBOutlet weak var BtnBorrarQ: UIButton!
    @IBOutlet weak var TxtMensajeQ: UITextView!
    @IBOutlet weak var segmentedQuejas: UISegmentedControl!
    var formattedDate: String?
    var gradient = CAGradientLayer()
    private let Naranja = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 1)
    private let Rojo = UIColor(displayP3Red: 254/255, green: 64/255, blue: 64/255, alpha: 1)
    private let Verde = UIColor(displayP3Red: 105/255, green: 255/255, blue: 65/255, alpha: 1)
    private let NaranjaClaro = UIColor(displayP3Red: 254/255, green: 250/255, blue: 171/255, alpha: 1)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TxtMensajeQ.text = "Escribe tu Comentario por Favor!!"
        TxtMensajeQ.textColor = UIColor.lightGray
        
        TxtMensajeQ.delegate = self
        TxtMensajeQ.layer.masksToBounds = true
        segmentedQuejas.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
       
        // Do any additional setup after loading the view.
        SetupUIQuejas()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yy"
        formattedDate = format.string(from: date)
        print(formattedDate)
        BtnEnviarQ.isEnabled = false
        
 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
           self.view.frame.origin.y = -300
       }
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
       }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func SetupUIQuejas(){
        BtnEnviarQ.backgroundColor = Verde
        BtnEnviarQ.setTitleColor(.white, for: .normal)
        BtnEnviarQ.layer.cornerRadius = 5
        BtnEnviarQ.layer.borderColor = Verde.cgColor
        BtnEnviarQ.layer.borderWidth = 3
        BtnEnviarQ.clipsToBounds = true
        
        BtnBorrarQ.backgroundColor = Rojo
        BtnBorrarQ.setTitleColor(.white, for: .normal)
        BtnBorrarQ.layer.cornerRadius = 5
        BtnBorrarQ.layer.borderColor = Rojo.cgColor
        BtnBorrarQ.layer.borderWidth = 3
        BtnBorrarQ.clipsToBounds = true
        
        BtnSalirQ.backgroundColor = UIColor.white
        BtnSalirQ.setTitleColor(Naranja, for: .normal)
        BtnSalirQ.layer.cornerRadius = 5
        BtnSalirQ.layer.borderColor = Naranja.cgColor
        BtnSalirQ.layer.borderWidth = 3
        BtnSalirQ.clipsToBounds = true
        
        // background de la vista
        
        gradient.frame = view.bounds.intersection(CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height))
        gradient.colors = [UIColor.white.cgColor,  NaranjaClaro.cgColor]
          view.layer.insertSublayer(gradient, at: 0)
    }
    func Session() -> String{
        var Nombre = ""
        if Auth.auth().currentUser != nil {
            let defaults = UserDefaults.standard
              Nombre = defaults.string(forKey: "Nombre") ?? "Usuario Desconocido"
        }
        else
        {
            print("El usuario no Esta Logueado")
        }
        return Nombre
    }
    @IBAction func BtnBorrarQ(_ sender: Any) {
       TxtMensajeQ.text = ""
        BtnEnviarQ.isEnabled = true
        
       /*   Ver el Comentario Guardado
         
        database.child("Comentarios").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else{
            return
            }
            print("Value: \(value)")
        })
        
        */
        
    }
    @IBAction func BtnEnviarQ(_ sender: Any) {
        /* GUARDA EL COMENTARIO EN LA BASE DE DATOS TOMANDO ENCUENTA A Q TIPO DE QUEJA ES.
        */
        if TxtMensajeQ.text!.isEmpty {
        print("Escribe un Comentario")
        
        } else{
        let Cliente = Session()
        let comentario = TxtMensajeQ.text?.description
        let Tipo = self.segmentedQuejas.titleForSegment(at: segmentedQuejas.selectedSegmentIndex)
            
        let object: [String: Any] = [
            "Cliente": Cliente as NSObject,
            "Comentario": comentario as Any,
            "Tipo": Tipo as Any
        ]
            database.child("Comentarios").child(formattedDate!).childByAutoId().setValue(object)
             TxtMensajeQ.text = "Gracias Por Tus Comentarios"
            BtnEnviarQ.isEnabled = false
        }
    }
    @IBAction func BtnSalirQ(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
       
    }
}
extension QuejasVC: UITextViewDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        BtnEnviarQ.isEnabled = true
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Escribe tu Comentario por Favor!!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
}
