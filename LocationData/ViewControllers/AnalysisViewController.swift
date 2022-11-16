//
//  LocationServiceViewController.swift
//  LocationData
//
//  Created by Fauzi Achmad B D on 14/11/22.
//

import UIKit

class AnalysisViewController: UIViewController {

    
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location Analysis View Controller"
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.center = view.center
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
