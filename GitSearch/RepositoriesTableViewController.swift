//
//  RepositoriesTableViewController.swift
//  GitSearch
//
//  Created by username on 03.10.2021.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {

    var searchResult: SearchResult!
    var repositories = [ReposInfo]()
    var isLoading = true
    
    struct TableView {
        struct CellIdentifiers {
            static let repositCell = "RepositCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.repositCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.repositCell)
       
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        self.clearsSelectionOnViewWillAppear = false
        
        print("\(searchResult.repos_url)")
        loadRepositories(searchResult.repos_url)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if repositories.count == 0 {
            return 1
        } else {
            return repositories.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if repositories.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.repositCell, for: indexPath) as! RepositCell
            cell.nameLabel.text = repositories[indexPath.row].name
            cell.descriptionLabel.text = repositories[indexPath.row].description
            cell.urlLabel.text = repositories[indexPath.row].html_url
            cell.updated_atLabel.text = repositories[indexPath.row].updated_at
            cell.stargazers_countLabel.text = "⭐️ \(repositories[indexPath.row].stargazers_count)"
            cell.forks_countLabel.text = "⑂ \(repositories[indexPath.row].forks_count)"
            cell.languageLabel.text = repositories[indexPath.row].language
        return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: repositories[indexPath.row].html_url!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if repositories.count == 0 || isLoading {
            return nil
        }
        else {
            return indexPath
        }
    }
}

extension RepositoriesTableViewController {
    
    func loadRepositories(_ urlString: String) {
        
        var dataTask: URLSessionDataTask?
        
            
            dataTask?.cancel()
            isLoading = true
            tableView.reloadData()
            
            repositories = []
            
            let url = URL(string: urlString)
            
            let session = URLSession.shared
            dataTask = session.dataTask(with: url!) {data, response, error in
                if let error = error as NSError?, error.code == -999 {
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.repositories = self.parse(data: data)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                        //self.showNetworkError()
                    }
                }
                
            }
            dataTask?.resume()
        }

    func parse(data: Data) -> [ReposInfo] {
        do {
            var repositories = [ReposInfo]()
            
            let decoder = JSONDecoder()
            repositories = try decoder.decode([ReposInfo].self, from: data)
            return repositories
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
