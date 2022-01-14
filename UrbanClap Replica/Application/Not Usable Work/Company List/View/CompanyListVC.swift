//

//

import UIKit
import VegaScrollFlowLayout

class CompanyListVC: CustomController
{
    
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var colletionViewCompanies: UICollectionView!
    
    let cellID = "cellClass_Companies"
    var catID = ""
    var apiData : [CompanyBody]?
    var viewModel:CompanyList_ViewModel?
    var tittle = "MENU"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = DynamicTextHandler.COMPNYLIST_TITLE
        self.viewModel = CompanyList_ViewModel.init(Delegate: self, view: self)
        
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.viewModel?.getCompanyList(catId:catID)
    }
    
    @IBAction func actionMoveBAck(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    func setUI()
    {
        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.makeCollectionViewFency(cllcnView:colletionViewCompanies,cellGap:5.0)
    }
}


extension CompanyListVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return apiData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)as! cellClass_Companies
        
        if let data = apiData?[indexPath.row]
        {
            cellnew.lblName.text = data.companyName
            let img = data.logo1 ?? ""
            cellnew.ivImg.setImage(with: img, placeholder: kplaceholderImage)
            cellnew.ivImg.CornerRadius(radius: 10.0)
            cellnew.setUI(lbl:cellnew.lblName)
        }
        
        return cellnew
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let controller = Navigation.GetInstance(of: .HomeVC)as! HomeVC
        let data = apiData?[indexPath.row]
        let compnyID = data?.id ?? ""
        let cartCompId = data?.cartCompanyID ?? ""
        
        if (cartCompId.count == 0)
        {
            AppDefaults.shared.companyID = compnyID
            controller.categoryID = catID
            controller.title = tittle
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        else
        {
            if(cartCompId == compnyID)
            {
                AppDefaults.shared.companyID = compnyID
                controller.categoryID = catID
                controller.title = tittle
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            else
            {
                self.AlertMessageWithOkCancelAction(titleStr: "Reminder", messageStr: "Are you sure you want to change the service vendor? Your current cart items will be removed!", Target: self)
                { (actn) in
                    if (actn == KYes)
                    {
                        self.viewModel?.clearCart()
                    }
                }
            }
        }
        
    }
    
    
}

extension CompanyListVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.colletionViewCompanies.frame.size.width-2, height: 190)
    }
}

extension CompanyListVC : CompanyListVCDelegate
{
    func getData(list: [CompanyBody])
    {
        if(list.count > 0)
        {
            self.apiData = list
            self.colletionViewCompanies.restore()
            self.colletionViewCompanies.reloadData()
        }
        else
        {
            self.nothingFound()
        }
    }
    
    func nothingFound()
    {
        self.colletionViewCompanies.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
        self.colletionViewCompanies.reloadData()
    }
}

