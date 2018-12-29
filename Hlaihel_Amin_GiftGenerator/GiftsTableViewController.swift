//
//  GiftsTableViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 29/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import UIKit
import SQLite






class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon_gift: UIImageView!
    
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var delete_icon: UIImageView!
}

class GiftsTableViewController: UITableViewController {
    
    var nombreInit : Int64 = 14
    var pk : Int64 = 1
    var identifiantModuleCellule = "GiftCell";
    var database: Connection!
    let gifts_table = Table("gifts")
    let GIFT_id = Expression<Int64>("id")
    let nom = Expression<String>("nom")
    let category = Expression<String>("category")
    let type = Expression<String>("type")
    let prix = Expression<Int>("prix")
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        do {let documentDirectory = try
            FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("gifts").appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)
            
        }catch {
            print ("error with fileURL")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var count = 0
        do{  count = try database.scalar(gifts_table.count)
            print ("count est \(count)")
            
            
        }catch{print("error while counting")}        // #warning Incomplete implementation, return the number of rows
        return count
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModuleCellule, for: indexPath)
            as! HeadlineTableViewCell
        
        
        do{
            
            let users = try
                self.database.prepare(self.gifts_table.filter(GIFT_id == self.pk) )
            for user in users {
                
                cell.nom?.text = String (user[self.nom])
                cell.price?.text = String ("prix :\(user[self.prix]) euro")
                cell.icon_gift?.image = UIImage (named: "gift_number_\(self.pk-1)")
                if(self.pk<15){
                    cell.delete_icon.isHidden = false
                }
                
                
                /* print ("id =", user[self.UE_id], ", name =",
                 user[self.sigle], ", email= ", user[self.parcours]) */
            }
            // Configure the cell...
            /*cell.textLabel?.text = query[self.sigle]
             cell.detailTextLabel?.text = " \(cursus[indexPath.row].categorie) \(cursus[indexPath.row].credit)"*/
        }catch{
            print("error selecting")
        }
        self.pk += 1
        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
