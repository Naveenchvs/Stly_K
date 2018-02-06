//
//  FACategoryVC.swift
//  Wardrober
//
//  Created by Yogi on 06/06/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

import UIKit

class FACategoryVC: UIViewController
{

    let categoriesCount = 21
    var categoriesCellListOrdered = [Int]()
    
    var categoryArray:[FACategory] = [FACategory]()

    @IBOutlet var tableView : UITableView!
    
    
    var homeContainerVC : HomeContainerVC!
    
    var selectedCategoryIndex : Int? = nil
    
    let ToModelVCSegueId = "CategoryVCtoModelVC"
    
    var categoryWithPendingImgDownloads = [FACategory]()
    var processingCategoryImgDownloads = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if Wardrober.shared().state == WardroberState.categoriesFetched
        {
           self.categoriesFetched()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(FACategoryVC.categoriesFetched), name: NSNotification.Name(rawValue: Constants.kCategoriesFetchedNotification) , object: nil)
        
    }
    
    
    @objc func categoriesFetched()
    {
        
        self.categoryArray.append(contentsOf: Wardrober.shared().categories)
        //categoryArray.sort{ $0.categoryId < $1.categoryId }

        self.refreshCategoryListView()
        
        categoryWithPendingImgDownloads.removeAll()
        categoryWithPendingImgDownloads.append(contentsOf: Wardrober.shared().categories)
        
        if processingCategoryImgDownloads == false
        {
            self.processCategoryImgFetch()
        }
    }
    
    func processCategoryImgFetch()
    {

        if categoryWithPendingImgDownloads.count > 0
        {
            processingCategoryImgDownloads = true
            
            let category = categoryWithPendingImgDownloads.first!
            categoryWithPendingImgDownloads.removeFirst()
            if let imgUrl = category.categoryImageUrl
            {
                CommonHelper.checkAndDownloadAsset(imageUrl: imgUrl, completion: { (success : Bool, errorMsg : String?) in
                    
                    //self.categoryArray.append(category)
                    
                    //self.refreshCategoryListView()
                    
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)

                    self.processCategoryImgFetch()
                    
                })
            }
            else
            {
                //self.categoryArray.append(category)
                
                //self.refreshCategoryListView()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                    
                self.processCategoryImgFetch()
            }
           
            
        }
        else
        {
            processingCategoryImgDownloads = false
        }
    }
    
    
    func refreshCategoryListView()
    {
        self.computeAndArrangeCategoriesCell()
        self.tableView.reloadData()
    }

    func loadCategories()
    {
        categoryArray.removeAll()
        
        //get Images from server
        let callCategory1=FACategory()
        callCategory1.categoryId = "1"
        callCategory1.categoryImageName = "fash1"
        callCategory1.categoryName = "NEW"
        categoryArray.append(callCategory1)
        
        let callCategory2=FACategory()
        callCategory2.categoryId = "2"
        callCategory2.categoryImageName = "fash2"
        callCategory2.categoryName = "AUTUMN"
        categoryArray.append(callCategory2)
        
        let callCategory3=FACategory()
        callCategory3.categoryId = "3"
        callCategory3.categoryImageName = "fash3"
        callCategory3.categoryName = "SPRING"
        categoryArray.append(callCategory3)
        
        let callCategory4=FACategory()
        callCategory4.categoryId = "4"
        callCategory4.categoryImageName = "fash4"
        callCategory4.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory4)
        
        let callCategory5=FACategory()
        callCategory5.categoryId = "5"
        callCategory5.categoryImageName = "fash5"
        callCategory5.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory5)
        
        let callCategory6=FACategory()
        callCategory6.categoryId = "6"
        callCategory6.categoryImageName = "fash6"
        callCategory6.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory6)
        
        let callCategory7=FACategory()
        callCategory7.categoryId = "7"
        callCategory7.categoryImageName = "fash7"
        callCategory7.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory7)
        
        let callCategory8=FACategory()
        callCategory8.categoryId = "8"
        callCategory8.categoryImageName = "fash8"
        callCategory8.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory8)
        
        let callCategory9=FACategory()
        callCategory9.categoryId = "9"
        callCategory9.categoryImageName = "fash9"
        callCategory9.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory9)
        
        let callCategory10=FACategory()
        callCategory10.categoryId = "10"
        callCategory10.categoryImageName = "fash10"
        callCategory10.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory10)
        
        let callCategory11=FACategory()
        callCategory11.categoryId = "11"
        callCategory11.categoryImageName = "fash11"
        callCategory11.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory11)
        
        let callCategory12=FACategory()
        callCategory12.categoryId = "12"
        callCategory12.categoryImageName = "fash12"
        callCategory12.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory12)
        
        let callCategory13=FACategory()
        callCategory13.categoryId = "13"
        callCategory13.categoryImageName = "fash13"
        callCategory13.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory13)
        
        let callCategory14=FACategory()
        callCategory14.categoryId = "14"
        callCategory14.categoryImageName = "fash14"
        callCategory14.categoryName = "SUMMER WEAR"
        categoryArray.append(callCategory14)
        
        
        categoryArray.sort{ $0.categoryId < $1.categoryId }
    }
    
    
    func computeAndArrangeCategoriesCell()
    {

        self.categoriesCellListOrdered =  self.getCategoriesCellList(remainingCategoriesCount: categoryArray.count, categoriesCellListOrdered: [Int]())
        
        ///print(self.categoriesCellListOrdered)
        
    }
    
    func getCategoriesCellList(remainingCategoriesCount : Int, categoriesCellListOrdered : [Int]) -> [Int]
    {
        var categoriesCellList = [Int]()
        categoriesCellList.append(contentsOf: categoriesCellListOrdered)
        if remainingCategoriesCount >= 3
        {

            let cellType3List = categoriesCellList.filter({ (cellType : Int) -> Bool in
                
                return cellType == 3
            })
            
            let cellType2List = categoriesCellList.filter({ (cellType : Int) -> Bool in
                
                return cellType == 2
            })
            
            if cellType3List.count == cellType2List.count
            {
                categoriesCellList.append(3)
            }
            else
            {
                categoriesCellList.append(2)
                categoriesCellList.append(1)

            }
            
            let newRemainingCategoriesCount = remainingCategoriesCount - 3
            
            return getCategoriesCellList(remainingCategoriesCount: newRemainingCategoriesCount, categoriesCellListOrdered: categoriesCellList)
            
            
        }
        else
        {
            if remainingCategoriesCount == 2
            {
                categoriesCellList.append(2)
                
                ///recursion should terminate
                
                return categoriesCellList
            }
            else if remainingCategoriesCount == 1
            {
                categoriesCellList.append(1)

                ///recursion should terminate
                return categoriesCellList

            }
            else
            {
                return categoriesCellList
            }
        }
        
    }
    
    func didSelectCategoryIndex(index : Int)
    {
        self.selectedCategoryIndex = index
        
        self.performSegue(withIdentifier: self.ToModelVCSegueId, sender: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

        if segue.identifier == self.ToModelVCSegueId
        {
            let modelVC =  segue.destination as! ModelVC

            modelVC.homeContainerVC = self.homeContainerVC
            modelVC.selectedCategoryIndex = self.selectedCategoryIndex!
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FACategoryVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return categoriesCellListOrdered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let unitHeight = self.tableView.bounds.height / CGFloat(3)
        let cellType = self.categoriesCellListOrdered[indexPath.row]
        
        if self.categoryArray.count <= 3
        {
            ///to fit screen
            return 3 * unitHeight
        }
        else if self.categoryArray.count <= 5
        {
             ///to fit screen
            switch cellType
            {
                
            case 3:
                
                return 2 * unitHeight
                
            default :
                return unitHeight
                
            }
        }
        else
        {
             ///to reveal a bit of the categories below
            switch cellType
            {
                
            case 3:
                
                return 2 * unitHeight - 20
                
            default :
                return unitHeight - 20
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellType = self.categoriesCellListOrdered[indexPath.row]
        
        var renderedCount = 0
        for i in 0 ..< indexPath.row
        {
            
           renderedCount += self.categoriesCellListOrdered[i]
        }
        let startCount = renderedCount
        
        
        switch cellType
        {
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellType3") as! FACategoryCellType3
            let firstCategory = self.categoryArray[startCount]
            let secondCategory = self.categoryArray[startCount + 1]
            let thirdCategory = self.categoryArray[startCount + 2]

            cell.categoryView1.titleLabel.text = firstCategory.categoryName
            if let imageUrl = firstCategory.categoryImageUrl
            {
                cell.categoryView1.imageView.image = ClothingItemImageView.imageForImageUrl(url: imageUrl)
            }
            else
            {
                cell.categoryView1.imageView.image = nil
                
            }
            cell.categoryView1.button.tag = startCount
            
            cell.categoryView2.titleLabel.text = secondCategory.categoryName
            if let imageUrl = secondCategory.categoryImageUrl
            {
                cell.categoryView2.imageView.image = ClothingItemImageView.imageForImageUrl(url: imageUrl)
            }
            else
            {
                cell.categoryView2.imageView.image = nil
               
            }
            cell.categoryView2.button.tag = startCount + 1

            cell.categoryView3.titleLabel.text = thirdCategory.categoryName
            if let imageUrl = thirdCategory.categoryImageUrl
            {
                cell.categoryView3.imageView.image = ClothingItemImageView.imageForImageUrl(url: imageUrl)
            }
            else
            {
                cell.categoryView3.imageView.image = nil

            }
            cell.categoryView3.button.tag = startCount + 2
            
            
            
            for view in cell.stackView1.arrangedSubviews
            {
                view.isHidden = true
            }
            for view in cell.stackView2.arrangedSubviews
            {
               view.isHidden = true
            }

            cell.delegate = self
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellType2") as! FACategoryCellType2
            
            let firstCategory = self.categoryArray[startCount]
            let secondCategory = self.categoryArray[startCount + 1]
            
            cell.categoryView1.titleLabel.text = firstCategory.categoryName
            if let imageUrl = firstCategory.categoryImageUrl
            {
                cell.categoryView1.imageView.image = ClothingItemImageView.imageForImageUrl(url: imageUrl)
            }
            else
            {
                cell.categoryView1.imageView.image = nil
                
            }
            cell.categoryView1.button.tag = startCount
            
            cell.categoryView2.titleLabel.text = secondCategory.categoryName
            if let imageUrl = secondCategory.categoryImageUrl
            {
                 cell.categoryView2.imageView.image = ClothingItemImageView.imageForImageUrl(url: imageUrl)
            }
            else
            {
                cell.categoryView2.imageView.image = nil
            }
            cell.categoryView2.button.tag = startCount + 1


            for view in cell.stackView.arrangedSubviews
            {
                view.isHidden = true
            }
            
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellType1")  as! FACategoryCellType1
            
            let firstCategory = self.categoryArray[startCount]
            
            cell.categoryView.titleLabel.text = firstCategory.categoryName
            if let imageUrl = firstCategory.categoryImageUrl
            {
                cell.categoryView.imageView.image = ClothingItemImageView.imageForImageUrl(url: imageUrl)
            }
            else
            {
                cell.categoryView.imageView.image = nil
                
            }
            cell.categoryView.button.tag = startCount
            
            cell.delegate = self
            return cell
            
            
        default:
            
            let cell = UITableViewCell()
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.isKind(of: FACategoryCellType3.self)
        {
            let c = cell as! FACategoryCellType3
            
            //c.categoryView1.layoutIfNeeded()
            //c.categoryView2.layoutIfNeeded()
            //c.categoryView3.layoutIfNeeded()
            c.categoryView1.adjustConstraints()
            c.categoryView2.adjustConstraints()
            c.categoryView3.adjustConstraints()

            for view in c.stackView1.arrangedSubviews
            {
                view.isHidden = false
            }
            for view in c.stackView2.arrangedSubviews
            {
                view.isHidden = false
            }
        }
        else if cell.isKind(of: FACategoryCellType2.self)
        {
            let c = cell as! FACategoryCellType2
            
            c.categoryView1.adjustConstraints()
            c.categoryView2.adjustConstraints()

            for view in c.stackView.arrangedSubviews
            {
                view.isHidden = false
            }
            
        }
        else if cell.isKind(of: FACategoryCellType1.self)
        {
            let c = cell as! FACategoryCellType1

            c.categoryView.adjustConstraints()

        }
    }
}

extension FACategoryVC : FACategoryCellType3Delegate, FACategoryCellType2Delegate, FACategoryCellType1Delegate
{
    func categoryView(categoryView: FACategoryView, didDetectButtonTapInCategory3Cell cell: FACategoryCellType3)
    {
        self.didSelectCategoryIndex(index: categoryView.button.tag)
    }
    
    func categoryView(categoryView: FACategoryView, didDetectButtonTapInCategory2Cell cell: FACategoryCellType2)
    {
        self.didSelectCategoryIndex(index: categoryView.button.tag)
    }
    
    func categoryView(categoryView: FACategoryView, didDetectButtonTapInCategory1Cell cell: FACategoryCellType1)
    {
        self.didSelectCategoryIndex(index: categoryView.button.tag)
    }
}




