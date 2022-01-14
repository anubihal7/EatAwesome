
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol AutoCompleteAddress_Protocol
{
    //  func initializeAndGetAddress(delegate:AutoCompleteAddress_Protocol)
    func getAddressFromAPI(address:String)
    func foundError(err:String)
}

class AutoCompleteAddress_Google : UIViewController,GMSMapViewDelegate
{
    var placesClient: GMSPlacesClient!
    var delegate : AutoCompleteAddress_Protocol?
    var controller : UIViewController?
    
    
    func initializeAndGetAddress(dlgate:AutoCompleteAddress_Protocol,contrllr:UIViewController)
    {
        
        self.placesClient = GMSPlacesClient.shared()
        GMSPlacesClient.provideAPIKey(GoogleAPIKey)
        //  GoogleApi.shared.initialiseWithKey(GoogleAPIKey)
        
        self.delegate = dlgate
        self.controller = contrllr
        self.open_google_autoFill()
    }
    
    func open_google_autoFill()
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField.all
        autocompleteController.placeFields = fields
        // let filter = GMSAutocompleteFilter()
        //filter.country = "uk"
        //filter.type = .noFilter
        // autocompleteController.autocompleteFilter = filter
        // Display the autocomplete view controller.
        self.controller!.present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    
}

extension AutoCompleteAddress_Google: GMSAutocompleteViewControllerDelegate
{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        self.controller!.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        self.delegate?.foundError(err:error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        self.controller!.dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool
    {
        let selcetyedCityStr = prediction.attributedFullText.string
        delegate?.getAddressFromAPI(address: selcetyedCityStr)
        return true
    }
    
}
