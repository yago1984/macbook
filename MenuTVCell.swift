//
//  MenuTVCell.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez on 08/02/21.
//

import UIKit

class MenuTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    @IBOutlet weak var ImgeCellMenu: UIImageView!
    @IBOutlet weak var NombreTxtCellMenu: UILabel!
    @IBOutlet weak var PecioTxtCellMenu: UILabel!
    @IBOutlet weak var TipoTxtCellMenu: UILabel!
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
