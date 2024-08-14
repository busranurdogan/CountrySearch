
import Foundation

class ViewModel {
    var countries : [Country] = []
    
    func doSearchByTerm(completionHandler: @escaping (Result<[Country], NetworkError>) -> Void) {
        let url = "https://restcountries.com/v3.1/all"
        
        Network.shared.request(url: url) { [weak self] (result: Result<[Country], NetworkError>)  in
            switch result {
                        case .success(let success):
                            self?.countries = success
                            completionHandler(.success(success))
                            
                        case .failure(let failure):
                            completionHandler(.failure(failure))
                        }
                    }
                }
    
    func getCountry(at index: Int) -> Country {
        return countries[index]
    }

    var numberOfCountries: Int {
        return countries.count
    }
    
    func searchCountries(with searchText: String) -> [Country] {
            return countries.filter { country in
                let nameMatch = country.name?.official?.range(of: searchText, options: .caseInsensitive)
                return nameMatch != nil
            }
        }
}
