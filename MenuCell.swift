//
//  MenuCell.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez.
//

import UIKit

class MenuCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let imageIV = CustomImageView()
    let nameLabel = UILabel()
    let precioLabel = UILabel()
    let signoLabel = UILabel()
    let tipoLabel = UILabel()
    private let colorAmarilloclaro = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 0.5)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error 405")
    }
    
    func setupView(){
        backgroundColor = UIColor.white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        layer.borderColor = colorAmarilloclaro.cgColor
        layer.borderWidth = 5
        
        clipsToBounds = true
      
        
        safeArea = layoutMarginsGuide
        setupImageView()
        setupNameLabel()
        setupPrecioLabel()
        setupTipoLabel()
        setupSignoLabel()
    }
    func setupImageView(){
        addSubview(imageIV)
        
        imageIV.translatesAutoresizingMaskIntoConstraints = false
        imageIV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        imageIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageIV.widthAnchor.constraint(equalToConstant: 110).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageIV.layer.cornerRadius = 5
        imageIV.clipsToBounds = true
    }
    func setupNameLabel(){
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: imageIV.trailingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        nameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        nameLabel.textColor = .gray
    }
    func setupPrecioLabel(){
        addSubview(precioLabel)
        
        precioLabel.translatesAutoresizingMaskIntoConstraints = false
        precioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 16).isActive = true
      
        precioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24).isActive = true
        
        precioLabel.font = UIFont(name: "Verdana-Bold", size: 16)
        precioLabel.textColor = .red
        
    }
    func setupTipoLabel(){
        addSubview(tipoLabel)
        
        tipoLabel.translatesAutoresizingMaskIntoConstraints = false
        tipoLabel.leadingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -96).isActive = true
        tipoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 14).isActive = true
        
        tipoLabel.font = UIFont(name: "Verdana", size: 16)
        tipoLabel.textColor = .gray
        
    }
    func setupSignoLabel(){
        addSubview(signoLabel)
        
        signoLabel.translatesAutoresizingMaskIntoConstraints = false
        signoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        signoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24).isActive = true
        
        signoLabel.font = UIFont(name: "Verdana-Bold", size: 16)
        signoLabel.textColor = .red
        
    }
    
}
