//
//  ViewController.swift
//  shareActivityTest
//
//  Created by Eugene Kireichev on 02.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton()
    let remoteUrl = URL(string: "https://my.domclick.ru/offer.pdf")!
    
    var data: Data {
        return try! Data(contentsOf: remoteUrl)
    }
    
    var tempUrl: URL {
        let path = NSTemporaryDirectory() + remoteUrl.lastPathComponent
        let tempURL = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: remoteUrl)
        try! data.write(to: tempURL)
        return tempURL
    }
    
    lazy var provider = ActivityItemProvider(url: remoteUrl)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }
    
    @objc
    func buttonTapped() {
        UIView.animate(withDuration: 0.2) {
            self.button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { [weak button] _ in
            UIView.animate(withDuration: 0.2) {
                button?.transform = .identity
            }
        }

        let activityVC = UIActivityViewController(activityItems: [provider],
                                                  applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

}

class ActivityItemProvider: UIActivityItemProvider {
    
    private let remoteUrl: URL
    private let tempUrl: URL
    
    override var item: Any {
        let data = try! Data(contentsOf: remoteUrl)
        try! data.write(to: tempUrl)
        return tempUrl
    }
    
    init(url: URL) {
        self.remoteUrl = url
        self.tempUrl = URL(fileURLWithPath: NSTemporaryDirectory() + url.lastPathComponent)
        super.init(placeholderItem: tempUrl)
    }
}

