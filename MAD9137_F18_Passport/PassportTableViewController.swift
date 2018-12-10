//
//  PassportTableViewController.swift
//  MAD9137_F18_Passport
//
//  Created by Ernilo Dallagnolo Junior on 2018-12-09.
//  Copyright © 2018 Ernilo Dallaagnolo Junior. All rights reserved.
//

import UIKit

// - create a tableViewController, a tableViewController class file, and assign the class to the tableView in the storyboard (3pt)
//  - embed a NavigationController in the tableView (1pt)
class PassportTableViewController: UITableViewController {
    
    // - create an appropriate JSON object to hold the data returned from http://lenczes.edumedia.ca/mad9137/final_api/passport/read/ (3 pt)
    var jsonObject: [String:[[String:Any]]]?
    
    //Variables
    let auth = "dall0078"
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //using optional binding to return json array count
        if let data = jsonObject {
            return data["locations"]!.count //returns data.count if it exist
        }else{
            //this block of code runs if jsondata doesnot exist
            return 0
        }
    }
    
    //   - add a navigationItem to the top of your PassportTableView, and add a barButtonItem to the right-hand side of the navigationItem (2 pt)
    // - the “Add” barButtonItem action must call the performSegue(withIdentifier, sender) function to segue to the AddViewController (2 pt)
    @IBAction func goToAddPage(_ sender: Any) {
        performSegue(withIdentifier: "ShowAddPage", sender: self)
    }
    
    // - override the tableView functions needed to populate the table with tableView cells, displaying the title stored in the JSON object (10 pt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //- give your prototype cell a reuse identifier (1 pt)
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        //using optional binding to access jsonData object if it exist
        if let dataArray = jsonObject {
            
            //getting the current dictionary with indexPath.row
            var item = dataArray["locations"]!
            var dataItem = item[indexPath.row]
            //setting each tableViewCell's textLabel with the 'eventTitle' and 'eventDate' from the current dictionary
            cell.textLabel?.text = "\(dataItem["title"]!)"
        }
        return cell
    }
    
    //  - in the viewWillAppear(_ animated:Bool) function, make a URLRequest to http://lenczes.edumedia.ca/mad9137/final_api/passport/read/ calling a requestTask upon completion (5 pt)
    override func viewWillAppear(_ animated: Bool) {
        // creating url for data request
        let url: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/")!
        
        // creating request using url
        var request: URLRequest = URLRequest(url: url)
        
        //creating Session using shared session
        let session: URLSession = URLSession.shared
        
        // Adding the header key "my-authentication" with the first eight characters of my email address
        //- within your URLRequest, you must add value to the URL’s header for the key “my-authentication”, and pass in the first 8 characters of your school’s email address (e.g. smit0052) as the value (3 pt)
        request.addValue(auth, forHTTPHeaderField: "my-authentication")
        
        // creating task object from the session by passing in request and the completion handler
        let task = session.dataTask(with: request, completionHandler: requestTask )
        
        //executing task
        task.resume()
    }
    
    // creating completion handler request task function to process server data and any errors if they exist
    //- write a requestTask to process the server data and any errors that are received by the server, and send it to your callback function (5 pt)
    func requestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.geoCallback(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.geoCallback(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    //- write a callback function that will process any errors if they exist and, if they don’t, process the response string from the server and serialize the JSON response in to your JSON object, then tell the tableView to reload the data (7 pt)
    func geoCallback(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        }else {
            print(responseString)
            //converting json string to data
            if let geoData:Data = responseString.data(using: String.Encoding.utf8){
                
                do{
                    
                    //converting data to json object and storing it in jsonObject
                    jsonObject = try JSONSerialization.jsonObject(with: geoData, options: []) as? [String:[[String:Any]]]
                    //                    print("\(jsonObject!)");
                }catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                
                self.tableView?.reloadData() //reloading tableView on main thread
            }
            
        }
    }
    
    //  - write a function that takes an integer for an id parameter and calls the URL http://lenczes.edumedia.ca/mad9137/final_api/passport/delete/?id= , passing the location’s id to the end of the delete query to delete (6 pt)
    func deletelocation(id:Int?){
        
        print("working")
        
        let deleteUrl: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/delete/?id=\(id!)")!
        
        // creating request using url
        var deleteURLRequest: URLRequest = URLRequest(url: deleteUrl)
        
        //creating Session using shared session
        let deleteSession: URLSession = URLSession.shared
        
        // Adding the header key "my-authentication" with the first eight characters of my email address
        //- within your URLRequest, you must add value to the URL’s header for the key “my-authentication”, and pass in the first 8 characters of your school’s email address (e.g. smit0052) as the value (3 pt)
        deleteURLRequest.addValue(auth, forHTTPHeaderField: "my-authentication")
        
        // creating task object from the session by passing in request and the completion handler
        let deleteTask = deleteSession.dataTask(with: deleteURLRequest, completionHandler: deleteRequestTask )
        
        //executing task
        deleteTask.resume()
    }
    
    // - write a deleteRequestTask to process the server data and any errors that are received by the server, and send it to a deleteCallback function (5 pt)
    func deleteRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void {
        
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.deleteCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.deleteCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
        
    }
    
    //- write a deleteCallback function that will process any errors if they exist and, if they don’t, tell the tableView to reload its data (4 pt)
    func deleteCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        }else {
            
            print(responseString)
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                
                self.tableView?.reloadData() //reloading tableView on main thread
            }
            
        }
    }
    
    //- override the tableView function to allow the user to delete a location out of the table, and call a function that will make a URLRequest (3 pt)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // delete from database
            if let passportDataArray = jsonObject {
                
                //getting the current dictionary with indexPath.row
                var passportDataItem = passportDataArray["locations"]!
                var dataItem = passportDataItem[indexPath.row]
                index = dataItem["id"] as? Int
                deletelocation(id: index)
                jsonObject?["locations"]!.remove(at: indexPath.row)
                print(index!)
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //   - when the user clicks a cell in the table, the prepare( for Segue, sender) must pass the correct dictionary when segueing to the InfoViewController (4 pt)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "ShowInfoPage" {
            // Get the new view controller using segue.destination.
            let nextViewController = segue.destination as? InfoViewController
            let index = tableView.indexPathForSelectedRow //getting index path from table
            
            if let segueDataArray = jsonObject {
                
                //getting the current dictionary with indexPath.row
                var passportDataItem = segueDataArray["locations"]!
                var dataItem = passportDataItem[index!.row]
                nextViewController?.jsonObj = dataItem //this refers to our ViewController class
                nextViewController?.identifier = dataItem["id"] as? Int
            }
            
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}
