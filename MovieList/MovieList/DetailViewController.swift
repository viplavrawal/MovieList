//
//  DetailViewController.swift
//  MovieList
//
//  Created by Viplav Rawal on 30/04/19.
//  Copyright © 2019 ViplavRawal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var movieData = Dictionary<String, Any>()
    var titleArray = [String]()
    var subtitleArray = [String]()
    
    //MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movie Details"
        tableView.dataSource = self
        tableView.delegate = self
        
        createArrays()
        setImage()
    }
    
    //MARK:- TableView Delegates and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath)
        cell.detailTextLabel?.text = subtitleArray[indexPath.row]
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    //MARK:- Utility methods
    func createArrays(){
        let keys = Array(movieData.keys)
        for title in keys{
            if(title.trimmingCharacters(in: .whitespaces) == "Poster"){
                continue
            }else{
                titleArray.append(title)
                subtitleArray.append(movieData[title] as? String ?? "")
            }
        }
        tableView.reloadData()
        
    }
    func setImage(){
        let keys = Array(movieData.keys)
        for key in keys{
            if(key.contains("Poster")){         //Doing this since there are whitespaces in some keys.
                if let url = URL(string: (movieData[key] as? String ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
                    let data = try? Data(contentsOf: url)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        posterImageView.image = image
                    }
                }
            }
        }
        
    }
}
