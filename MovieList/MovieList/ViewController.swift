//
//  ViewController.swift
//  MovieList
//
//  Created by Viplav Rawal on 30/04/19.
//  Copyright © 2019 ViplavRawal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var movieListing = Array<Dictionary<String,Any>>()

    //MARK:- ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movie List"
        getMovieListingService()
        
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    //MARK:- TableView Delegate and DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath) as! ListingTableViewCell
        cell.titleLabel.text = movieListing[indexPath.row]["Title"] as? String ?? ""
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListing.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The user has selected the row with data: ", movieListing[indexPath.row])
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.movieData = movieListing[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- WebService
    func getMovieListingService(){
        //Used URLSession here instead of AlamoFire since there was just one API and pods were discouraged. Adding Alamofire manually for one API looked like an overkill
        let url = URL(string: "https://api.myjson.com/bins/itzx2")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let dict = self.convertToDictionary(text: String(data: data, encoding: .utf8)!)!
            self.movieListing = dict["movies"] as? [Dictionary<String, Any>] ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    //MARK:- Utility Methods
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

