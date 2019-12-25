//
//  FavoritesTableViewCell.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 24.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import UIKit

protocol FavoriteOptionsDelegate {
    func removeFromFavorites(indexPath: IndexPath?)
    func openPDF(indexPath: IndexPath?)
    func editComment(indexPath: IndexPath?)
}

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var placeOfWorkLabel: UILabel!
    
    var delegate: FavoriteOptionsDelegate?
    
    var human: Human? {
        didSet {
            guard human != nil else { return }
            initialsLabel.text = human!.firstname ?? "" + (human!.lastname ?? "")
            placeOfWorkLabel.text = human!.placeOfWork ?? ""
            positionLabel.text = "посада: " + (human!.position ?? "-")
            commentLabel.text = "коментар: " + (human!.comment ?? "-")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func removeFavoriteButton(_ sender: Any) {
        delegate?.removeFromFavorites(indexPath: indexPath)
    }
    
    @IBAction func editCommentButton(_ sender: Any) {
        delegate?.editComment(indexPath: indexPath)
    }
    
    @IBAction func openPDFButton(_ sender: Any) {
        delegate?.openPDF(indexPath: indexPath)
    }
}
