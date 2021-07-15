//
//  MisPedidosCell.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 22/04/21.
//

import UIKit

class MisPedidosCell: UITableViewCell {
    @IBOutlet weak var LabelNoPedido: UILabel!
    var milabuno = UILabel()
    var milabdos = UILabel()
    var safeArea: UILayoutGuide!
    private let colorAmarilloclaro = UIColor(displayP3Red: 251/255, green: 217/255, blue: 104/255, alpha: 0.5)
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCellPedido()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("no ha sido implementado")
        }
    func setupViewCellPedido(){
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        layer.borderColor = colorAmarilloclaro.cgColor
        layer.borderWidth = 5
        
        clipsToBounds = true
        
        
           safeArea = layoutMarginsGuide
           setupLabdos()
           setupLabuno()
           
       }
    func setupLabuno() {
        addSubview(milabuno)
        milabuno.translatesAutoresizingMaskIntoConstraints = false
        milabuno.leadingAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -60).isActive = true
        milabuno.topAnchor.constraint(equalTo: topAnchor, constant: 48).isActive = true
                
        milabuno.font = UIFont(name: "Verdana-Bold", size: 18)
        milabuno.textColor = .red
    }
    func setupLabdos() {
        addSubview(milabdos)
               
        milabdos.translatesAutoresizingMaskIntoConstraints = false
        milabdos.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        milabdos.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
               
        milabdos.font = UIFont(name: "Verdana", size: 18)
        milabdos.textColor = .systemBlue
        
    }

}
