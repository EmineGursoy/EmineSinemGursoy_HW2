//
//  NewsCell.swift
//  NewsApp
//
//  Created by Emine Sinem on 12.05.2023.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(model: Article) {
        titleLabel.text = model.title
        authorLabel.text = model.byline
        authorLabel.alpha = 0.8
        downloadImage(model: model)
        newsImageView.layer.borderWidth = 2
        newsImageView.layer.borderColor = UIColor.black.cgColor
        newsImageView.layer.cornerRadius = 10

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
