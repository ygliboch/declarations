//
//  FavoritesViewController.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 23.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import UIKit

protocol FavoritesDelegate {
    var favoritesPeople: [Human] { get set }
}

class FavoritesViewController: UIViewController {
    
    //MARK: Properties & IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    var favoritesPeople: [Human] = []
    var delegate: FavoritesDelegate?
    
    //MARK: Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesPeople = delegate?.favoritesPeople ?? []
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: TableView

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as? FavoritesTableViewCell
        cell?.human = favoritesPeople[indexPath.row]
        cell?.selectionStyle = .none
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
}

//MARK: FavoriteOptionsDelegate

extension FavoritesViewController: FavoriteOptionsDelegate {
    
    func removeFromFavorites(indexPath: IndexPath?) {
        guard indexPath != nil else { return }
        
        favoritesPeople.remove(at: indexPath!.row)
        delegate?.favoritesPeople = favoritesPeople
        tableView.reloadData()
    }
    
    func openPDF(indexPath: IndexPath?) {
        guard indexPath != nil else { return }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let PDFController = mainStoryboard.instantiateViewController(withIdentifier: "PDFController") as! PDFViewController
        PDFController.linkPDF = favoritesPeople[indexPath!.row].linkPDF ?? ""
        navigationController?.pushViewController(PDFController, animated: true)
    }
    
    func editComment(indexPath: IndexPath?) {
        guard indexPath != nil else { return }
        
        let alert = CommentAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.delegate = self
        alert.indexPath = indexPath
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: CommentAlertControllerDelegate

extension FavoritesViewController: CommentAlertControllerDelegate {
    func saveComment(comment: String, at indexPath: IndexPath) {
        favoritesPeople[indexPath.row].comment = comment
        tableView.reloadData()
    }
}
