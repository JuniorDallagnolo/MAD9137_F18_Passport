//
//  InfoViewController.swift
//  MAD9137_F18_Passport
//
//  Created by Ernilo Dallagnolo Junior on 2018-12-09.
//  Copyright © 2018 Ernilo Dallaagnolo Junior. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    // - create a dictionary that will hold the location’s JSON object passed from the PassportTableViewController (2 pt)
    var jsonObj: [String:Any]?
    var identifier:Int?
    
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var locTitle: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable user interaction for these textview
        locTitle.isUserInteractionEnabled = false
        desc.isUserInteractionEnabled = false
    }
    
    // - in the viewDidLoad() function, call the URL http://lenczes.edumedia.ca/mad9137/final_api/passport/read/?id=, passing the location’s id to the end of the query (5 pt)
    override func viewWillAppear(_ animated: Bool) {
        // creating url for data request
        let detailsUrl: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/?id=\(identifier!)")!
        
        // creating request using url
        var detailsURLRequest: URLRequest = URLRequest(url: detailsUrl)
        
        //creating Session using shared session
        let detailsSession: URLSession = URLSession.shared
        
        //  - within your URLRequest, you must add value to the URL’s header for the key “my-authentication”, and pass in the first 8 characters of your school’s email address (e.g. smit0052) as the value (3 pt)
        let detailsAuth = "dall0078"
        
        // Adding the header key "my-authentication" with the first eight characters of my email address
        detailsURLRequest.addValue(detailsAuth, forHTTPHeaderField: "my-authentication")
        //}
        
        // creating task object from the session by passing in request and the completion handler
        let detailsTask = detailsSession.dataTask(with: detailsURLRequest, completionHandler: requestTask )
        
        //executing task
        detailsTask.resume()
    }
    
    // creating completion handler request task function to process server data and any errors if they exist
    // - write a requestTask to process the server data and any errors that are received by the server, and send it to your callback function (5 pt)
    func requestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.detailsCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.detailsCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    //  - write a callback function that will process any errors if they exist and, if they don’t, process the response string from the server and serialize the JSON response in to your JSON object, then output the title, id, description, latitude, longitude, arrival, and departure to the textView (10 pt)
    func detailsCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        }else {
            print(responseString)
            //converting json string to data
            if let detailsData:Data = responseString.data(using: String.Encoding.utf8){
                
                do{
                    
                    //converting data to json object and storing it in jsonObject
                    jsonObj = try JSONSerialization.jsonObject(with: detailsData, options: []) as? [String:Any]
                    print("\(jsonObj!)");
                    
                }catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                if let data = self.jsonObj{
                    self.locTitle.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
                    self.locTitle.text = "Details for \(data["title"]!)"
                    self.desc.text = "Title: \(data["title"]!) \n\n Location Id: \(data["id"]!) \n\n Description: \(data["description"]!) \n\n Latitude: \(data["latitude"]!) \n\n Longitude: \(data["longitude"]!)"
                }
            }
            
        }
    }
}

