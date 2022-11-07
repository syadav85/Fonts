//
//  FontListViewController.swift
//  Fonts
//
//  Created by Satender Yadav on 11/5/22.
//

import UIKit

class FontListViewController: UITableViewController {
    
    var fontNames: [String] = []
     var showsFavorites:Bool = false
     private var cellPointSize: CGFloat!
     private static let cellIdentifier = "FontName"
    

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         if showsFavorites {
              fontNames = FavoritesList.sharedFavoritesList.favorites
              tableView.reloadData()
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontNames = (UIFont.familyNames as [String]).sorted()
        let preferredTableViewFont =
            UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cellPointSize = preferredTableViewFont.pointSize
        tableView.estimatedRowHeight = cellPointSize
    }
    


    func fontForDisplay(atIndexPath indexPath: NSIndexPath) -> UIFont {
         let fontName = fontNames[indexPath.row]
         return UIFont(name: fontName, size: cellPointSize)!
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fontNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell =  tableView.dequeueReusableCell(
                withIdentifier: FontListViewController.cellIdentifier,
                for: indexPath)
         
         cell.textLabel?.font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
         cell.textLabel?.text = fontNames[indexPath.row]
         cell.detailTextLabel?.text = fontNames[indexPath.row]
         
         return cell
        }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller.
            let tableViewCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: tableViewCell)!
            let font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
            
             let sizesVC =  segue.destination as! FontSizesViewController
             sizesVC.title = font.fontName
             sizesVC.font = font
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return showsFavorites
        }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if !showsFavorites {
                return
            }
            
            if editingStyle == UITableViewCell.EditingStyle.delete {
                // Delete the row from the data source
                let favorite = fontNames[indexPath.row]
                FavoritesList.sharedFavoritesList.removeFavorite(fontName: favorite)
                fontNames = FavoritesList.sharedFavoritesList.favorites
                
                tableView.deleteRows(at: [indexPath],
                                     with: UITableView.RowAnimation.fade)
            }

        }

}
