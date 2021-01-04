//
//  PrivacyPolicyViewController.swift
//  Favr
//
//  Created by Aniket Gupta on 18/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import PDFKit

class PrivacyPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guard let path = Bundle.main.url(forResource: "FavrPrivacyPolicy", withExtension: "pdf") else { return }

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
    
}
