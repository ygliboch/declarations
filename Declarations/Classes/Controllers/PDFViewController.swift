//
//  PDFViewController.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 24.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {
    
    //MARK: Properties & IBOutlets
    
    @IBOutlet weak var webView: WKWebView!
    var linkPDF = ""
    
    //MARK: Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDF()
    }
    
    //MARK: Business logic
    
    private func setupPDF() {
        if let url = URL(string: linkPDF) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            showAlert(title: "файл відсутній", message: "")
        }
    }
}
