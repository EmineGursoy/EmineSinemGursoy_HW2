//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Emine Sinem on 13.05.2023.
//

import NewsAPI
import UIKit
import SafariServices

class DetailViewController: UIViewController {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!
    
    var selectednews: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        configureDetailPage()
    }
    
    // Detail page is configured with the data of the selected news
    func configureDetailPage() {
        authorLabel.text = selectednews?.byline
        titleLabel.text = selectednews?.title
        descriptionLabel.text = selectednews?.abstract
        downloadImage(model: selectednews!)
        seeMoreButton.layer.cornerRadius = 20
        
        seeMoreButton.addTarget(self, action: #selector(openNews), for: .touchUpInside)
        
        if selectednews?.byline == "" {
            authorLabel.text = "No Data"
        }
        if selectednews?.title == "" {
            titleLabel.text = "No Data"
        }
        if selectednews?.abstract == "" {
            descriptionLabel.text = "No Data"
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    // News article is opened on safari
    @objc func openNews() {
        guard let url = selectednews?.url else { return }
        
        let index = url.absoluteString.index(of: ":") ?? url.absoluteString.endIndex
        let result = url.absoluteString[..<index]
        if result == "https" || result == "http" {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.preferredControlTintColor = .black
            present(safariViewController, animated: true, completion: nil)
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "News data couldn't found")
        }
    }

    private func downloadImage(model: Article) {
        
        guard let imageURL = model.multimedia?.first?.url else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: imageURL) { data, response, error in
            if error != nil {
                
            } else {
                
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        self.newsImageView.image = image
                    }
                }
            }
        }
        task.resume()
    }

}
