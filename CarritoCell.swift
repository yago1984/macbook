//
//  CarritoCell.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 22/02/21.
//

import UIKit

class CarritoCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let namexLabel = UILabel()
    let precioxLabel = UILabel()
    let cantidadLabel = UILabel()
    let cantidadxLabel = UILabel()
    let signopesosxLabel = UILabel()

    @IBOutlet weak var TxtNombreCarrito: UILabel!
    @IBOutlet weak var TxtPrecioCarrito: UILabel!
    @IBOutlet weak var TxtPiezasCarrito: UILabel!
    private let colorAmarilloclaro = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 0.5)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("no ha sido implementado")
    }
    func setupViewCell()  {
        backgroundColor = UIColor.white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderColor = colorAmarilloclaro.cgColor
        layer.borderWidth = 5
        clipsToBounds = true
        
        safeArea = layoutMarginsGuide
        setupNamexLabel()
        setupCantidadLabel()
        setupCantidadxLabel()
        setupSignoLabel()
        setupPrecioLabel()
        
    }
    func setupNamexLabel(){
        addSubview(namexLabel)
        
        namexLabel.translatesAutoresizingMaskIntoConstraints = false
        namexLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        namexLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        namexLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        namexLabel.textColor = .gray
    }
    func  setupCantidadLabel(){
        addSubview(cantidadLabel)
        
        cantidadLabel.translatesAutoresizingMaskIntoConstraints = false
        cantidadLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        cantidadLabel.topAnchor.constraint(equalTo: namexLabel.bottomAnchor, constant: 24).isActive = true
        
        cantidadLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        cantidadLabel.textColor = .gray
    }
    func  setupCantidadxLabel(){
        addSubview(cantidadxLabel)
        
        cantidadxLabel.translatesAutoresizingMaskIntoConstraints = false
        cantidadxLabel.leadingAnchor.constraint(equalTo: cantidadLabel.trailingAnchor, constant: 24).isActive = true
        cantidadxLabel.topAnchor.constraint(equalTo: namexLabel.bottomAnchor, constant: 24).isActive = true
        
        cantidadxLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        cantidadxLabel.textColor = .gray
    }
    func  setupSignoLabel(){
        addSubview(signopesosxLabel)
        
        signopesosxLabel.translatesAutoresizingMaskIntoConstraints = false
        signopesosxLabel.leadingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80).isActive = true
        signopesosxLabel.topAnchor.constraint(equalTo: namexLabel.bottomAnchor, constant: 8).isActive = true
        
        signopesosxLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        signopesosxLabel.textColor = .red
    }
    func  setupPrecioLabel(){
        addSubview(precioxLabel)
        
        precioxLabel.translatesAutoresizingMaskIntoConstraints = false
        precioxLabel.leadingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64).isActive = true
        precioxLabel.topAnchor.constraint(equalTo: namexLabel.bottomAnchor, constant: 8).isActive = true
        
        precioxLabel.font = UIFont(name: "Verdana-Bold", size: 20)
        precioxLabel.textColor = .red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
