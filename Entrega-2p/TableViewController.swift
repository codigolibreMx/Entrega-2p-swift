//
//  TableViewController.swift
//  Entrega-2p
//
//  Created by UX Lab - ISC Admin on 4/4/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var randomText: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
}
class TableViewController: UITableViewController {

    
    @IBOutlet var tableview: UITableView!
    var usuario = ""
    var contraseña = ""
    var tok = ""
    
    
    

    
    var data = NSArray()
    var names = [String]()
    var dates = [String]()
    var latitude = [Double]()
    var longitude = [Double]()
    var randomtext = [String]()
    
    override func viewDidLoad() {
        
        
        let backgroundImage = UIImage(named: "Background.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        
        self.tableview.backgroundView = imageView
        print("prueba")
        print(usuario)
        print(tok)
        tableView.tableFooterView = UIView()
        Alamofire.request("https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/posts/", method: .post, parameters: ["username" : "\(usuario)", "token" :"\(tok)"
            ],encoding: JSONEncoding.default, headers: nil)
            .responseJSON{  response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            let dataObject = JSON["data"] as! NSArray
                            self.data = dataObject
                            print(self.data)
                            self.names = dataObject.value(forKey: "name") as! [String]
                            self.dates = dataObject.value(forKey: "date") as! [String]
                            self.latitude = dataObject.value(forKey: "latitude") as! [Double]
                            self.longitude = dataObject.value(forKey: "longitude") as! [Double]
                            self.randomtext = dataObject.value(forKey: "content") as! [String]
                            self.tableview.reloadData()
                        }
                        
                    default:
                        print("error with response status: \(status)")
                    }
                }
        }
        print("aquí está el pedo")
        super.viewDidLoad()
        //self.tableView.dataSource = self
        //self.tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.titleLabel?.text = self.names[indexPath.row] as? String
        cell.date?.text = self.dates[indexPath.row] as? String
        cell.randomText?.text = self.randomtext[indexPath.row] as? String
//        cell.titleLabel?.text = "prueba"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "pushMap", sender: self)

//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "pushMap", sender: self)
//            
//        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "pushMap") {
//            let vc = segue.destination as! MapViewController
//            vc.latitude = "-0.5"
//            vc.longitude = "1.5"
//        }
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let detailVC = segue.destination as! MapViewController
            
            detailVC.latitude =  String(describing: self.latitude[selectedRow])
            detailVC.longitude = String(describing: self.longitude[selectedRow])
        }
    }
  
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
