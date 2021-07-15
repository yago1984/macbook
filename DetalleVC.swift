//
//  ViewController.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 17/01/21.
//

import UIKit
import FirebaseAnalytics

class DetalleVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var comidaNombreLab: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var BtnAgregarP: UIButton!
    
    var image = UIImage()
    var name = ""
    var tipo = ""
    var precio = ""
    var detalles = ""
    var ventapor = ""
    var miURL = ""
    var task: URLSessionDataTask!
    private let Rojo = UIColor(displayP3Red: 254/255, green: 64/255, blue: 64/255, alpha: 1)
    private let Blanco = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ejecuta la Funcion para traer Datos
        TraerDatosLocalesMain()
 
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        
        
        // Analitics Event
        Analytics.logEvent("iniciar ", parameters: ["Mensaje":"Sirvio el Evento"])
    
    }
    
    func TraerDatosLocalesMain(){
        comidaNombreLab.text = name
        photoImageView.image = image
        print(tipo)
        print(precio)
        print(detalles)
        print(ventapor)
    }
 
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide Keyboard
        textField.resignFirstResponder()
        return true
            
    }
    func  textFieldDidEndEditing(_ textField: UITextField) {
        comidaNombreLab.text = textField.text
    }
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Descarta el selector si el usuario Cancelo
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // El diccionario de información puede contener múltiples representaciones de la imagen. Quieres usar el original.
        guard let selectedImage = info [.originalImage] as? UIImage else { fatalError("Se esperaba un diccionario que contenía una imagen, pero se proporcionó lo siguiente: \(info)")
        }
        // Configure photoImageView para mostrar la imagen seleccionada.
        photoImageView.image = selectedImage
        // Despedir al selector.
        dismiss ( animated : true , completion : nil )
    }
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the Keyboard
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController ()
        // Only allow photos to be picked, not taken.
        imagePickerController . sourceType = . photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController . delegate = self
        present ( imagePickerController , animated : true , completion : nil )
        
    }
    @IBAction func setDefaulLabelText(_ sender: UIButton) {
        comidaNombreLab.text = "Defaul text"
    }
   
}

//MARK: Funciones que Pueden servir


/* Funcion Para cargar una imagen Desde URL en un Hilo Diferente
 comidaNombreLab.text = name
 if let url = URL(string: miURL){
   
     task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data,
              let newImage = UIImage(data: data)
        
        
        else {
              print("no se cargo la imagen ")
              return
        }
         DispatchQueue.main.async {
           //  let resizable = newImage.resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), resizingMode: .stretch)
             self.photoImageView.image = newImage
             self.photoImageView.contentMode = .scaleAspectFit
             self.photoImageView.layer.cornerRadius = 5
             self.photoImageView.clipsToBounds = true
             
          
             
            
             
             
         }
     }
     task.resume()
 }
*/
