//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Emine Sinem on 13.05.2023.
//

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

        guard let selectedNewsTitle = selectednews?.title else {return}
        print(selectedNewsTitle)
        authorLabel.text = selectednews?.byline
        titleLabel.text = selectednews?.title
        descriptionLabel.text = selectednews?.abstract
        downloadImage(model: selectednews!)
        
        seeMoreButton.addTarget(self, action: #selector(openNews), for: .touchUpInside)
        
        seeMoreButton.layer.cornerRadius = 20
        //seeMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func openNews() {
        guard let url = selectednews?.url else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .black
        present(safariViewController, animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
