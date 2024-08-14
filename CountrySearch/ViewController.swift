
import UIKit
import Kingfisher
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController:UISearchController!
    private var viewModel = ViewModel()
    var routeData : CapitalInfo?
    var routeCoordinates : [CLLocation] = []
    var searchResults:[Country] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by official country name"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.orange
        
        getCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    private func getCountries() {
        
        viewModel.doSearchByTerm { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                DispatchQueue.main.async { () -> Void in
                    if success.count == 0 {
                        print("Sonuç bulunamadı")
                        
                        let alert = UIAlertController(title: "", message: "Sonuç bulunamadı", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        
                        self?.present(alert, animated: true, completion: nil)
                        
                    }
                }
 
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    let cellIdentifier = "ItemCellIdentifier"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        let country = (searchController.isActive) ? searchResults[indexPath.row] : viewModel.getCountry(at: indexPath.row)
        
        cell.cellCountryName.text = country.name?.official
        cell.cellCapitalCity.text = country.capital?.first ?? ""
        cell.cellPopulation.text = "\(country.population)"
        
        self.loadViewIfNeeded()
        if let url = URL(string: country.flags?.png ?? "") {
            cell.cellImage?.kf.setImage(with: url)
            cell.cellImage.roundedImage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if searchController.isActive {
                return false
            } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return viewModel.numberOfCountries
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selected = viewModel.getCountry(at: indexPath.row)
        if searchController.isActive {
            selected = searchResults[indexPath.row]
        }
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
            
            detailVC.country.name?.official = selected.name?.official ?? ""
            detailVC.country.capital = selected.capital
            detailVC.country.population = selected.population
            detailVC.country.capitalInfo = selected.capitalInfo
            detailVC.loadViewIfNeeded()
            if let url = URL(string: selected.flags?.png ?? "") {
                detailVC.imageView.kf.setImage(with: url)
            }

            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
     
     func updateSearchResults(for searchController: UISearchController) {
         if let searchText = searchController.searchBar.text {
             searchResults = viewModel.searchCountries(with: searchText)
         }   else {
             searchResults = []
         }
         tableView.reloadData()
         }
}
     

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = (self.frame.size.width) / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}


