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
    
    let pickerViewContainer = UIStackView()
    let picker = UIPickerView()
    
    var selectedSectionIndex: Int?
    
    var sections: [String] = ["arts", "automobiles", "books", "business", "fashion", "food", "health", "home", "insider", "magazine", "movies", "nyregion", "obituaries", "opinion", "politics", "realestate", "science", "sports", "sundayreview", "technology", "theater", "t-magazine", "travel", "upshot", "us", "world"]
    
    var selectedSection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickerView()
        configureTableView()
        
        selectedSection = sections[7]
       
        //makeClickable()
        getData()
    }
    
    @IBAction func rightBarButtonAction(_ sender: Any) {
        clickOnButton()
    }
    
    func configurePickerView() {
        picker.delegate = self
        picker.dataSource = self
        
        pickerViewContainer.isHidden = true
        
        pickerViewContainer.axis = .vertical
        pickerViewContainer.addArrangedSubview(createToolbar())
        pickerViewContainer.addArrangedSubview(picker)
        
        view.addSubview(pickerViewContainer)
        
        pickerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        pickerViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pickerViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pickerViewContainer.addArrangedSubview(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 1, height: 50))))
        
        pickerViewContainer.backgroundColor = UIColor(white: 1, alpha: 1)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        navigationItem.title = sections[7].uppercased()
    }
    
    // Makes the navigation item clickable and sets the text that will be written on the navigation item
    /*
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
    */
    // Shows pickerview for topics
    @objc func clickOnButton() {
        pickerViewContainer.isHidden = false
        
        if let selectedSectionIndex = selectedSectionIndex {
            picker.selectRow(selectedSectionIndex, inComponent: 0, animated: true)
        } else {
            picker.selectRow(7, inComponent: 0, animated: true)
        }
    }
    
    // Creates tool bar
    func createToolbar() -> UIToolbar {
       
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
    
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        doneButton.tintColor = UIColor.black
        toolbar.setItems([doneButton], animated: true)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return toolbar
    }
      
    // Loads the section at the selected index of picker view
    @objc func donePressed() {
        if let selectedSectionIndex = selectedSectionIndex {
            changeSection(to: selectedSectionIndex)
        }
        
        //makeClickable()
        pickerViewContainer.isHidden = true
        navigationItem.title = selectedSection.uppercased()
        self.view.endEditing(true)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // News data on the selected section is retrieved
    func getData() {
        
        let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/\(selectedSection).json?api-key=ws8eBdyNMkVjdEk8GlkA2m7hQLSA5l86")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: "News data couldn't be retrieved")
            } else {
                
                if let data = data {
                    do {
                        let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
                        
                        // Filter articles without data
                        self.articles = articleResponse.results.filter {
                            guard let title = $0.title,
                                  let abstract = $0.abstract else {
                                return false
                            }
                            
                            return title.count > 0 && abstract.count > 0
                        }
                        
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
   
    // Detail page of the selected news is opened
    func goDetail(news: Article) {
        selectedArticle = news
        performSegue(withIdentifier: "toDetailPage", sender: nil)
    }

    // Data of the detail page is prepared
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailPage" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.selectednews = selectedArticle
        }
    }
    
    // Change the selected section and retrieve the news data for that section
    func changeSection(to index: Int) {
        selectedSection = sections[index]
        getData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

// The response object from the API is modeled
private struct ArticleResponse: Decodable {
    let results: [Article]
    
    enum CodingKeys: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let throwables = try container.decode([Throwable<Article>].self, forKey: .results)
        self.results = throwables.compactMap { $0.value }
    }
}

enum Throwable<T: Decodable>: Decodable {
    case success(T)
    case failure(Error)

    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        } catch let error {
            self = .failure(error)
        }
    }
}

extension Throwable {
    var value: T? {
        switch self {
        case .failure(_):
            return nil
        case .success(let value):
            return value
        }
    }
}

// Picker view settings are made
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
        selectedSectionIndex = row
    }
}
