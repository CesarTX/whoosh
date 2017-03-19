//
//  ListOfActivities.swift
//  hwoosh
//
//  Created by Cesar Tejada on 3/9/17.
//  Copyright © 2017 hwoosh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListOfActivities: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    @IBAction func NextViewAction(_ sender: Any)
    {
        
    }
    //MARK: Private variables
    private var ref: FIRDatabaseReference!
    private var listOfActions :  NSMutableArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activitiesCollectionView.delegate = self
        ref = FIRDatabase.database().reference()
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.layer.cornerRadius = 8
        
        activitiesCollectionView.layer.borderWidth = 0.5
        activitiesCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        
        let userID = FIRAuth.auth()?.currentUser?.uid

        ref.child("activities").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            /*let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let user = User.init(username: username)*/
        
            self.listOfActions = snapshot.value as! NSMutableArray
            self.activitiesCollectionView.reloadData()
            
            for (index,activity) in self.listOfActions.enumerated()
            {
                let theDictionary  = activity as! NSMutableDictionary
                theDictionary.setValue(false, forKey: "Selected")
                
                
                self.listOfActions.replaceObject(at: index, with: theDictionary)
            }
            
            print(self.listOfActions)
            
            self.activitiesCollectionView.reloadData()
            
            self.activityIndicator.stopAnimating()
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK:UICollectionViewFunctions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCollectionViewCell
        
        
        // Create a reference to the file you want to download

        if listOfActions.count > 0
        {
        let activityDictionary = listOfActions[indexPath.row] as! NSDictionary
        
        
        cell.activityName.text = activityDictionary["name"]! as! String
        cell.activityName.adjustsFontSizeToFitWidth = true
        cell.activityImage.image = UIImage(named: activityDictionary["image_url"] as! String)
        
        }
        
        /*let activity = listOfActions[indexPath.row] as! NSMutableDictionary
        let selected = activity["Selected"] as! Bool
        if (selected)
        {
            cell.activityName.textColor = UIColor(red:1.00, green:0.40, blue:0.80, alpha:1.0)
            //cell.activityImage.tintColor = UIColor(red:1.00, green:0.40, blue:0.80, alpha:1.0)
        }
        else
        {
            cell.activityName.textColor = UIColor.black
            
            /*let tintedImage = cell.activityImage.image?.withRenderingMode(.alwaysTemplate)
            cell.activityImage.image = tintedImage*/
            //ell.activityImage.tintColor = UIColor.black
        }*/
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return listOfActions.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let activity = listOfActions[indexPath.row] as! NSMutableDictionary
        let selected = activity["Selected"] as! Bool
        let cell = collectionView.cellForItem(at: indexPath) as! ActivityCollectionViewCell

        if (selected)
        {
            cell.activityName.textColor = UIColor.lightGray
            activity["Selected"] = false
            
        }
        else
        {
            //UIColor(red:1.00, green:0.40, blue:0.80, alpha:1.0)
            cell.activityName.textColor = UIColor(red:0.40, green:1.00, blue:0.40, alpha:1.0)
            activity["Selected"] = true
        }
        
        self.listOfActions.replaceObject(at: indexPath.row, with: activity)
        
        //collectionView.reloadItems(at: [indexPath])
    }

}
