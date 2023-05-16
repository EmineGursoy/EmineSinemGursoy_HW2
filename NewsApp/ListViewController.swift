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
    
    let picker = UIPickerView()
    var sections: [String] = ["arts", "automobiles", "books", "business", "fashion", "food", "health", "home", "insider", "magazine", "movies", "nyregion", "obituaries", "opinion", "politics", "realestate", "science", "sports", "sundayreview", "technology", "theater", "t-magazine", "travel", "upshot", "us", "world"]
    
    var selectedSection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //title = "New York Times"
        selectedSection = sections[7]
        picker.delegate = self
        picker.dataSource = self
        
        makeClickable()
        configureTableView()
        getData()
    }
    
    func makeClickable() {
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.backgroundColor = .black
        button.setTitle(selectedSection.uppercased(), for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.gray.cgColor
        navigationItem.titleView = button
    }
    
    @objc func clickOnButton() {
        
        picker.isHidden = false
    
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)

        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        picker.backgroundColor = UIColor(white: 1, alpha: 0.85)
        
        picker.selectRow(7, inComponent: 0, animated: true)
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
        
        //let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=ws8eBdyNMkVjdEk8GlkA2m7hQLSA5l86")
        let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/\(selectedSection).json?api-key=ws8eBdyNMkVjdEk8GlkA2m7hQLSA5l86")
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

extension ListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSection = sections[row]
        print(selectedSection)
        makeClickable()
        picker.isHidden = true
        getData()
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
     */
}
