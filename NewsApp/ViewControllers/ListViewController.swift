//
//  ListViewController.swift
//  NewsApp
//
//  Created by Emine Sinem on 11.05.2023.
//


import NewsAPI
import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var articles = [Article]()
    
    var selectedArticle: Article?
    
    let pickerViewContainer = UIStackView()
    let picker = UIPickerView()
    
    let apiManager = APIManager()
    
    var selectedSectionIndex: Int?
    
    var sections: [String] = ["arts", "automobiles", "books", "business", "fashion", "food", "health", "home", "insider", "magazine", "movies", "nyregion", "obituaries", "opinion", "politics", "realestate", "science", "sports", "sundayreview", "technology", "theater", "t-magazine", "travel", "upshot", "us", "world"]
    
    var selectedSection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickerView()
        configureTableView()
        
        selectedSection = sections[7]
       
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
        apiManager.getData(section: selectedSection) { articles, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: "News data couldn't be retrieved")
            } else {
                DispatchQueue.main.async {
                    self.articles = articles
                    self.tableView.reloadData()
                }
            }
        }
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
