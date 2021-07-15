//
//  Acercade.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez.
//

import UIKit

class Acercade: UIViewController {
    @IBOutlet weak var BotonS: UIButton!
    @IBOutlet weak var BotonL: UIButton!
    
    var gradient = CAGradientLayer()
    private let colorAzulclaro = UIColor(displayP3Red: 56/255, green: 117/255, blue: 233/255, alpha: 1)
    private let Naranja = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 1)
    private let NaranjaClaro = UIColor(displayP3Red: 254/255, green: 250/255, blue: 171/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        SetupUIAcercaDe()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func SetupUIAcercaDe(){
        
        BotonS.backgroundColor = UIColor.white
        BotonS.setTitleColor(Naranja, for: .normal)
        BotonS.layer.cornerRadius = 5
        BotonS.layer.borderColor = Naranja.cgColor
        BotonS.layer.borderWidth = 3
        BotonS.clipsToBounds = true
        
        BotonL.backgroundColor = UIColor.white
        BotonL.setTitleColor(.red, for: .normal)
        BotonL.layer.cornerRadius = 5
        BotonL.layer.borderColor = Naranja.cgColor
        BotonL.layer.borderWidth = 3
        BotonL.clipsToBounds = true
        
        // background de la vista
        gradient.frame = view.bounds.intersection(CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height))
        gradient.colors = [UIColor.white.cgColor,  NaranjaClaro.cgColor]
          view.layer.insertSublayer(gradient, at: 0)
    }
    @IBAction func Botonsalir(_ sender: UIButton) {
        BotonS.backgroundColor = UIColor.red
        BotonS.setTitleColor(UIColor.black, for: .selected)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
