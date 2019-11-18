//
//  ViewController.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 4/21/19.
//  Copyright © 2019 24. All rights reserved.
//

import UIKit
import Observable

class MovieCatalogViewController: UIViewController {
    
    weak var coordinator:MovieCatalogCoordinatorDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingFooter: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageRetryButton: UIButton!
    var model: MovieCatalogVMProtocol!
    var disposal: Disposal = Disposal()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addObserver()
        loadData()
    }
    
    func loadData() -> Void {
        model.load(page:1)
    }
    
    func addObserver() -> Void {
        
        model.moviesUpdated.observe {[weak self] (value, _ ) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.add(to: &disposal)
        
        model.networkActivity.observe {[weak self] (value, nil) in
            if value == true {
                self?.view.showLinearHud(Double(self?.view.layoutMargins.top ?? 0))
            }
            else {
                self?.view.hideLinearHud()
            }
        }.add(to: &disposal)
        
        model.error.observe {[weak self] (value, nil) in
            self?.showError(error: value)
            }.add(to: &disposal)
    }
    
    func showError(error: Error?) -> Void {
        if model.moviesCount == 0 {
            if let err = error {
                self.errorLabel.text = err.localizedDescription
                self.view.bringSubviewToFront(self.errorView)
            }
            else {
                self.errorLabel.text = ""
                self.view.sendSubviewToBack(self.errorView)
            }
        }
        else {
            self.pageRetryButton.isHidden = error == nil
        }
    }
    
    @IBAction func retryAction(_ sender: Any) {
        loadData()
    }
    
    @IBAction func pageRetryAction(_ sender: Any) {
        model.loadNextPage()
    }
}

extension MovieCatalogViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.moviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieCatalogCell.self)) as! MovieCatalogCell
        cell.movieVM = model.movie(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !model.isSearching, indexPath.row == model.moviesCount - 1{
            if model.isNextPageAvailable  {
                self.loadingFooter.isHidden = false
                model.loadNextPage()
            }
            else {
                self.loadingFooter.isHidden = true
            }
        }
        else {
            self.loadingFooter.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.didSelect(movieVM: model.movie(at: indexPath.row))
    }
    
    
    
}

extension MovieCatalogViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.filter = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    
}

