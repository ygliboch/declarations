//
//  PeopleTableViewCell.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 23.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import UIKit

protocol DeclarationOptionsDelegate {
    func openPdf(indexPath: IndexPath?)
    func changeDeclarationStatus(indexPath: IndexPath?)
}

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var placeOfWorkLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var changeStatusButton: UIButton!
    var delegate: DeclarationOptionsDelegate?
    
    var inFavorites: Bool = false {
        didSet {
            var imageName = ""
            switch inFavorites {
            case true:
                imageName = "star.fill"
            case false:
                imageName = "star"
            }
            changeStatusButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    var human: Human? {
        didSet {
            guard human != nil else { return }
            initialsLabel.text = human!.firstname ?? "" + (human!.lastname ?? "")
            placeOfWorkLabel.text = human!.placeOfWork ?? ""
            positionLabel.text = "посада: " + (human!.position ?? "-")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func openPDF(_ sender: Any) {
        delegate?.openPdf(indexPath: indexPath)
    }
    
    @IBAction func changeDeclarationStatus(_ sender: Any) {
        delegate?.changeDeclarationStatus(indexPath:    indexPath)
    }
}
