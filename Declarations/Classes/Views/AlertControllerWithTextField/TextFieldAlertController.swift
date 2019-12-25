//
//  TextFieldAlertController.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 24.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import UIKit

protocol CommentAlertControllerDelegate {
    func saveComment(comment: String, at indexPath: IndexPath)
}

class CommentAlertController: UIAlertController {
    
    //MARK: Properties & IBOutlets
    
    private var titleLable: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .black
        title.textAlignment = .center
        title.text = "Додайте коментар"
        return title
    }()
    
    private var textView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var delegate: CommentAlertControllerDelegate?
    var indexPath: IndexPath?
    
    //MARK: Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupTextView()
        addActions()
    }
    
    //MARK: Business logic
    
    private func setupTitle() {
        view.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        titleLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        titleLable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        titleLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 8).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func addActions() {
        let saveAction = UIAlertAction(title: "зберегти", style: .cancel) { (_) in
            guard self.indexPath != nil else { return }
            self.delegate?.saveComment(comment: self.textView.text, at: self.indexPath!)
        }
        self.addAction(saveAction)
    }
}
