//
//  CambiarContraseñaVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez.
//

import UIKit

class CambiarPaswwordVC: UIViewController {

    @IBOutlet weak var BtnSpass: UIButton!
    var gradient = CAGradientLayer()
    private let Naranja = UIColor(displayP3Red: 248/255, green: 191/255, blue: 70/255, alpha: 1)
    private let NaranjaClaro = UIColor(displayP3Red: 254/255, green: 250/255, blue: 171/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUICambiarP()
        
    }
    func SetupUICambiarP() {
        BtnSpass.backgroundColor = Naranja
        BtnSpass.setTitleColor(.white, for: .normal)
        BtnSpass.layer.cornerRadius = 10
        BtnSpass.layer.borderColor = Naranja.cgColor
        BtnSpass.layer.borderWidth = 3
        BtnSpass.clipsToBounds = true
        // background de la vista
        gradient.frame = view.bounds.intersection(CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height))
        gradient.colors = [UIColor.white.cgColor,  NaranjaClaro.cgColor]
          view.layer.insertSublayer(gradient, at: 0)
    }
    @IBAction func BtnSpassSalir(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}



