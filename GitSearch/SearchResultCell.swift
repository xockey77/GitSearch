//
//  SearchResultCell.swift
//  GitSearch
//
//  Created by username on 02.10.2021.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    var dataTask: URLSessionDataTask?
    var followers = [SearchResult]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for result: SearchResult) {
        loginLabel.text = result.login
        urlLabel.text = result.followers_url
        
        avatarImageView.image = UIImage(systemName: "square")
        
        if let smallURL = URL(string: result.avatar_url) {
            downloadTask = avatarImageView.loadImage(url: smallURL)
        }
        /*
        if let followersURL = URL(string: result.followers_url) {
            dataTask = loadFollowers(url: followersURL)
        }*/
        //print("\(result.followers_url)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        dataTask?.cancel()
        dataTask = nil
    }

    
    func loadFollowers(url: URL) -> URLSessionDataTask {
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) {data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    self.followers = self.parseFollowers(data: data)
                    print(self.followers.count)
                    DispatchQueue.main.async {
                        self.urlLabel.text = "\(self.followers.count) followers"
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as? HTTPURLResponse
                    print("Error! Can't get foolowers count! \(httpResponse!.statusCode)")
                }
            }
        }
        dataTask.resume()
        return dataTask
    }


    func parseFollowers(data: Data) -> [SearchResult] {
        do {
            var followers = [SearchResult]()
            
            let decoder = JSONDecoder()
            followers = try decoder.decode([SearchResult].self, from: data)
            return followers
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}


