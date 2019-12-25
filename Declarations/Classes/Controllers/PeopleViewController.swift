//
//  PeopleViewController.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 23.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import UIKit
import Moya
import MBProgressHUD

class PeopleViewController: UIViewController {

    //MARK: Properties & IBOutlets
    
    private enum State {
      case loading
      case ready
      case error
    }
    
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
            MBProgressHUD.hide(for: view, animated: true)
            tableView.reloadData()
        case .loading:
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.bezelView.layer.cornerRadius = 15
        case .error:
            MBProgressHUD.hide(for: view, animated: true)
            showAlert(title: "Щось пішло не так", message: "Будь ласка, перевірте своє з'єднання")
        }
      }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let provider = MoyaProvider<NazkApi>()
    private var currentPage = 1
    private var people: [Human] = []
    var favoritesPeople: [Human] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        getPeopleList(query: "") { (peopleList) in
            self.people = peopleList.items ?? []
            self.currentPage = peopleList.page?.currentPage ?? 0
            self.tableView.reloadData()
        }
    }
    
    //MARK: Business logic
    
    private func getPeopleList(query: String, complation: @escaping ((PeopleList)->Void)) {
        state = .loading
        provider.request(.peoplesList(query, currentPage)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let peopleList = try (response.map(PeopleList.self))
                    self.state = .ready
                    complation(peopleList)
                } catch {
                    self.state = .error
                }
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    @IBAction func openFavorites(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let favoritesController = mainStoryboard.instantiateViewController(withIdentifier: "FavoritesController") as! FavoritesViewController
        favoritesController.delegate = self
       navigationController?.pushViewController(favoritesController, animated: true)
    }
    
}

//MARK: TableView

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as? PeopleTableViewCell
        cell?.human = people[indexPath.row]
        cell?.inFavorites = favoritesPeople.contains(people[indexPath.row])
        cell?.selectionStyle = .none
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard state != .loading else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHight = scrollView.contentSize.height

        if offsetY > contentHight - scrollView.frame.height * 3 {
            currentPage += 1
            getPeopleList(query: searchBar.text ?? "") { (peopleList) in
                self.people.append(contentsOf: peopleList.items ?? [])
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: DeclarationOptionsDelegate

extension PeopleViewController: DeclarationOptionsDelegate {
    
    func openPdf(indexPath: IndexPath?) {
        guard indexPath != nil else { return }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let PDFController = mainStoryboard.instantiateViewController(withIdentifier: "PDFController") as! PDFViewController
        PDFController.linkPDF = people[indexPath!.row].linkPDF ?? ""
        navigationController?.pushViewController(PDFController, animated: true)
    }
    
    func changeDeclarationStatus(indexPath: IndexPath?) {
        guard indexPath != nil else { return }
        
        if favoritesPeople.contains(people[indexPath!.row]) {
            removeFromFavorites(indexPath: indexPath!)
        } else {
            showCommentAlert(indexPath: indexPath!)
        }
    }
    
    private func removeFromFavorites(indexPath: IndexPath) {
        let index = favoritesPeople.lastIndex(where: { (human) -> Bool in
            return human == people[indexPath.row]
        })
        if index != nil {
            favoritesPeople.remove(at: index!)
        }
    }
    
    private func showCommentAlert(indexPath: IndexPath) {
        let alert = CommentAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.delegate = self
        alert.indexPath = indexPath
        present(alert, animated: true, completion: nil)
    }
}

//MARK: CommentAlertControllerDelegate

extension PeopleViewController: CommentAlertControllerDelegate {
    func saveComment(comment: String, at indexPath: IndexPath) {
        var human = people[indexPath.row]
        human.comment = comment
        favoritesPeople.append(human)
    }
}

//MARK: SearchBar

extension PeopleViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard state != .loading else { return }
        
        getPeopleList(query: searchText) { (peopleList) in
            self.people = peopleList.items ?? []
            self.currentPage = peopleList.page?.currentPage ?? 0
            self.tableView.reloadData()
        }
    }
}

//MARK: FavoritesDelegate

extension PeopleViewController: FavoritesDelegate {
}

