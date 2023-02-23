//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-22.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    // Initialize web view
    private let webView: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()

    // title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        // enable auto layout
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Porter"
        return label
    }()
    
    // over view label
    private let overViewLabel: UILabel = {
        let label = UILabel()
        // enable auto layout
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.text = "This is the best movie to binge watch during the holiday"
        return label
    }()
    
    // download button
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        
        view.backgroundColor = .systemBackground
        addConstraints()

    }
    
    func addConstraints() {
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
//
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverview
        
        // url string
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeiew.id.videoId)") else {
            return
        }
        // load the webview with the url string created
        webView.load(URLRequest(url: url))
    }
}
