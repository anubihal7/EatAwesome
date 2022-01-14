//

//

import UIKit
import SkeletonView

class SubCatsVC: CustomController
{
    
    @IBOutlet var SubCatCollection: UICollectionView!
    
    var isSkeleton_Cats = true
    var skeletonItems_Cats = 4
    var apiData : [Subcategory]?
    let cellID_cats = "CellClass_SubCatsVC"
    var viewModel:SubCateCat_ViewModel?
    var catID =  "0"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewModel = SubCateCat_ViewModel.init(Delegate: self, view: self)
        self.viewModel!.getSubCategoryList(catID: "\(catID)")

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.viewModel!.getSubCategoryList(catID: "\(catID)")
    }
    
    @IBAction func movBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func actionGoToCart(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .CartListVC)as! CartListVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
}




extension SubCatsVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isSkeleton_Cats == true
        {
           return skeletonItems_Cats
        }
        
        return apiData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_cats, for: indexPath)as! CellClass_SubCatsVC
        
        if let obj = apiData?[indexPath.row]
        {
            let txt = obj.name
            cell.lblName.text! = txt
            let img = obj.thumbnail
            cell.ivCat.setImage(with: img, placeholder: kplaceholderImage)
            cell.ivCat.CornerRadius(radius: 10.0)
            
            
            cell.hideSkeleton()
        }
        else
        {
            cell.showAnimation()
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let obj = apiData?[indexPath.row]
        
        if (obj?.isService == true)
        {
           // let controller = Navigation.GetInstance(of: .CatServiceListVC)as! CatServiceListVC
           // controller.subCatID = obj?.id ?? "0"
          //  self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        else
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Sorry, services not available for this section")
        }
    }
    
   
}

extension SubCatsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let collectionViewWidth = self.SubCatCollection.frame.size.width
        return CGSize(width: (collectionViewWidth/2.2)+2, height: 220)
    }
}


extension SubCatsVC : SubCatVCDelegate
{
    func getData(subcats: [Subcategory])
    {
        DispatchQueue.main.async
        {
            if (subcats.count > 0)
            {
                self.apiData = subcats
                self.isSkeleton_Cats = false
                self.SubCatCollection.setEmptyMessage("")
                self.SubCatCollection.reloadData()
            }
            else
            {
                self.nothingFound()
            }
        }
    }
    
    func nothingFound()
    {
        self.isSkeleton_Cats = false
        self.SubCatCollection.setEmptyMessage("Categories not available!")
        self.SubCatCollection.reloadData()
    }
    
    
}
