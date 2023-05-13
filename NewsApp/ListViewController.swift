//
//  ListViewController.swift
//  NewsApp
//
//  Created by Emine Sinem on 11.05.2023.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var articles = [Article]()
    var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "New York Times"
        configureTableView()
        getData()
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
    }
   
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getData() {
        
        let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=ws8eBdyNMkVjdEk8GlkA2m7hQLSA5l86")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: "News data couldn't be retrieved")
            } else {
                
                if let data = data {
                    do {
                        let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
                        self.articles = articleResponse.results
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func goDetail(news: Article) {
        selectedArticle = news
        performSegue(withIdentifier: "toDetailPage", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toDetailPage" {
               let detailVC = segue.destination as! DetailViewController
               detailVC.selectednews = selectedArticle
           }
       }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        cell.configureCell(model: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goDetail(news: articles[indexPath.row])
    }
}

// API'dan gelen response objesi modellenir
private struct ArticleResponse: Decodable {
    let results: [Article]
}
