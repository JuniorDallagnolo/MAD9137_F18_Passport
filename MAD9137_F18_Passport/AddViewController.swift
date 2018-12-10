//
//  AddViewController.swift
//  MAD9137_F18_Passport
//
//  Created by Ernilo Dallagnolo Junior on 2018-12-09.
//  Copyright © 2018 Ernilo Dallaagnolo Junior. All rights reserved.
//

import UIKit
// - import CoreLocation framework, and create a CLLocationManager object (2 pt)
import CoreLocation

class AddViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var locTitle: UITextField!
    @IBOutlet weak var locDesc: UITextField!
    @IBOutlet weak var arrivalDate: UIDatePicker!
    @IBOutlet weak var departureDate: UIDatePicker!
    
    var geoManager = CLLocationManager()
    var newDictionary : [String : Any] = [:]
    var newData : Data?
    var newJsonString : String?
    var newLat : Double?
    var newLon : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geoManager.delegate = self
        locTitle.placeholder = "Location Title"
        locDesc.placeholder = "Description"
        
        geoManager.requestAlwaysAuthorization()
        geoManager.requestLocation()
        // Do any additional setup after loading the view.
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        newLat = locations[locations.count - 1].coordinate.latitude
        newLon = locations[locations.count - 1].coordinate.longitude
    }
    
    // Write the locationManagerDelegate method when an error occurred getting the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    @IBAction func saveNewInfo(_ sender: Any) {
        
        // if the textField has text entered in it, the “Save” action will make a URLRequest to the following URI https://lenczes.edumedia.ca/mad9137/final_api/passport/create/?data=, concatenating the outlet’s values converted to a JSON string on to the end of the URL (15 pt)
        guard let newTitle = locTitle.text, !newTitle.isEmpty else {
            return
        }
        
        //  - “Save” barButtonItem action must hide the keyboards (1 pt)
        view.endEditing(true)
        
        newDictionary ["title"] = newTitle
        newDictionary ["description"] = locDesc.text
        newDictionary ["arrival"] = String(arrivalDate.date.description.dropLast(9))
        newDictionary ["departure"] = String(departureDate.date.description.dropLast(9))
        newDictionary ["latitude"] = newLat
        newDictionary ["longitude"] = newLon
        
        print(newDictionary)
        
        // Try to convert the dictionary to JSON data, and the data to a utf8 encoded string
        do {
            newData = try JSONSerialization.data(withJSONObject: newDictionary, options: [])
            newJsonString = String(data: newData!, encoding: .utf8)
            
            // Encode all special characters to be web query compliant
            let encodedJSONString = newJsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(encodedJSONString!)
            let creationUrl: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/create/?data=\(encodedJSONString!)")!
            
            // creating request for creating location on database using url
            var creationURlRequest: URLRequest = URLRequest(url: creationUrl)
            
            //creating Session using shared session
            let creationSession: URLSession = URLSession.shared
            
            //creating authentification credentials
            let CreationAuth = "dall0078"
            
            // Adding the header key "my-authentication" with the first eight characters of my email address
            creationURlRequest.addValue(CreationAuth , forHTTPHeaderField: "my-authentication")
            //}
            
            // creating task object from the session by passing in request and the completion handler
            let creationTask = creationSession.dataTask(with: creationURlRequest, completionHandler: addRequestTask)
            
            //executing task
            creationTask.resume()
        }
        catch {
            print ("Coverted error = \(error.localizedDescription)")
        }
        
    }
    
    //   - write an addRequestTask to process the server data and any errors that are received by the server, and send it to the addCallback function (5 pt)
    func addRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void {
        
        if serverError != nil {
            
            self.addCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.addCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
        }
        
        
    }
    
    //    - write an addCallback function that will process any errors if they exist and, if they don’t, tell the navigationController to popToRootViewController (4 pt)
    func addCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        }else{
            print(responseString)
            
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                
                self.navigationController?.popToRootViewController(animated: true) //return to root view controller
            }
        }
        
    }
    
    //   - in the touchesBegan function, hide the keyboards (2 pt)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locTitle.resignFirstResponder()
        locDesc.resignFirstResponder()
        return false
    }
}


