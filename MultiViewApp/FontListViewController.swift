//
//  FontListViewController.swift
//  MultiViewApp
//
//  Created by Viktor Bilyk on 2017-11-29.
//  Copyright © 2017 Shifty Land LLC. All rights reserved.
//

import UIKit

class FontListViewController: UITableViewController {

    var fontNames: [String] = []
    var showsFavorites:Bool = false
    private var cellPointSize: CGFloat!
    private static let cellIdentifier = "FontName"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let preferredTableViewFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        cellPointSize = preferredTableViewFont.pointSize
        tableView.estimatedRowHeight = cellPointSize
        
        if showsFavorites {
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
    
    func fontForDisplay(atIndexPath indexPath: NSIndexPath) -> UIFont {
        let fontName = fontNames[indexPath.row]
        return UIFont(name: fontName, size: cellPointSize)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showsFavorites {
            fontNames = FavoritesList.sharedFavoritesList.favorites
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FontListViewController.cellIdentifier, for: indexPath)
        
        cell.textLabel?.font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
        cell.textLabel?.text = fontNames[indexPath.row]
        cell.detailTextLabel?.text = fontNames[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!
        let font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
        
        if segue.identifier == "ShowFontSizes" {
            let sizesVC = segue.destination as! FontSizesViewController
            sizesVC.title = font.fontName
            sizesVC.font = font
        } else {
            let infoVC = segue.destination as! FontInfoViewController
            infoVC.title = font.fontName
            infoVC.font = font
            infoVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(font.fontName)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        FavoritesList.sharedFavoritesList.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        fontNames = FavoritesList.sharedFavoritesList.favorites
    }
    
    
    
    
    

}
