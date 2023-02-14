//
//  SubMenuTableViewCell.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class SubMenuTableViewCell: UITableViewCell {
    let lang = LanguageManager.shared.language
    // Outlet
    @IBOutlet weak var productLabel : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    
    @IBOutlet weak var productContainerView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func setUpCell(){
        productContainerView.layer.cornerRadius = SIZE.RADIUS
        productLabel.font.withSize(SIZE.FONT_SIZE_CELL_LABEL)
    }
    
    func setData(product : Product){
        
        self.tag = product.id
        productLabel.text = "\(lang == "en" ? product.nameEn : product.nameKh)"
        let url = URL(string: product.imageUrl)
//        print(product.imageUrl, " : Image ")
        productImageView.kf.setImage(with: url, placeholder: UIImage(named: product.imageUrl))
    }
    
    func setData(package : Package){
        self.tag = package.id
        productLabel.text = "\(lang == "en" ? package.nameEn : package.nameKh)"
        let url = URL(string: package.imageUrl)
        productImageView.kf.setImage(with: url, placeholder: UIImage(named: package.imageUrl))
    }
    
    func setData(software : SoftwareSolution) {
        self.tag = software.id
        productLabel.text = "\(lang == "en" ? software.nameEn : software.nameKh)"
        let url = URL(string: software.imageUrl)
        productImageView.kf.setImage(with: url, placeholder: UIImage(named: software.imageUrl))
    }
    
    func setData(department : Department){
        self.tag = department.id
        productLabel.text = department.name
        let url = URL(string: department.image)
        productImageView.kf.setImage(with: url, placeholder:  UIImage(named: department.image))
    }
    
}
