
import UIKit
import MapKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalCityLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    
    var country = Country(name: nil, capital: nil, population: 0, flags: nil, capitalInfo: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countryNameLabel.text = country.name?.official
        capitalCityLabel.text = country.capital?.first
        populationLabel.text = "\(country.population)"
        if let url = URL(string: country.flags?.png ?? "") {
            imageView.kf.setImage(with: url)
        }
        
        let latitude = country.capitalInfo?.latlng?[0] ?? 0.0
        let longitude = country.capitalInfo?.latlng?[1] ?? 0.0
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = country.capital?.first
        annotation.subtitle = country.name?.official
        
        mapView.addAnnotation(annotation)
    }
    

}
