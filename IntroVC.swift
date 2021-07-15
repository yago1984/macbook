//
//  IntroVC.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez .
//

import UIKit
import Network
import GoogleSignIn
import FirebaseAuth
let L = LoginVC()

class IntroVC: UIViewController {
    let networkMonitor = NWPathMonitor()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let user = Auth.auth().currentUser
        if user?.uid != nil {
            
             let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as?  MainNavigationController
            mainNavigationVC?.modalPresentationStyle = .fullScreen
            self.present(mainNavigationVC!, animated: true, completion: nil)
           
        //Show Login Screen
        } else {
      
            let loginNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as?  LoginVC
           loginNavigationVC?.modalPresentationStyle = .fullScreen
           self.present(loginNavigationVC!, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ComprobarInternet()
    }
    func ComprobarInternet() {
        networkMonitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("Estás conectado a la red")
                } else {
                    print("No estás conectado a la red")
                }
            }

            let queue = DispatchQueue(label: "Network connectivity")
        networkMonitor.start(queue: queue)
        
    }
}
