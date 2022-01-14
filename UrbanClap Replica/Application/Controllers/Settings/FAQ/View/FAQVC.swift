
//

import UIKit

class FAQVC: UIViewController
{
    
    @IBOutlet var viewNav: UIView!
    @IBOutlet var viewTopQsns: UIView!
    @IBOutlet var collTopQstn: UICollectionView!
    @IBOutlet var tblView: UITableView!
    
    var cellID = "CellClass_FAQ"
    
    var viewModel:FAQViewModel?
    var apiData : [FAQResult]?
    var apiDataTop : [catDEC]?
    var selectedCellID = -1
    var selectdTop = -1
    var selectdCat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideNAV_BAR(controller: self)
        self.setStatusBarColor(view:self.view,color:kpurpleTheme)
        self.viewNav.backgroundColor = kpurpleTheme
      //  self.viewTopQsns.roundCorners_TOPLEFT_TOPRIGHT(val: 10)
        
        self.viewTopQsns.layer.cornerRadius = 20
        self.viewTopQsns.layer.masksToBounds = true
        
        self.viewModel = FAQViewModel.init(Delegate: self, view: self)
        
        self.viewModel?.getFAQList()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    @IBAction func moveBAck(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
}

extension FAQVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return apiData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CellClass_FAQ
        
        
        if let obj = apiData?[indexPath.row]
        {
            let qsn = "Q. \(indexPath.row+1)  "
            cell.lblTitle.text = "\(qsn)\(obj.question ?? "")"
            
//            if(self.selectedCellID == indexPath.row)
//            {
//                cell.lblDesc.isHidden = false
//                cell.ivArroe.image = UIImage(named: "downarrow")
//                cell.bgView.backgroundColor = UIColor.init(red: 246/255.0, green: 193/255.0, blue: 204/255.0, alpha: 1.0)
//                cell.lblTitle.textColor = Appcolor.get_category_theme()
//            }
//            else
//            {
//                cell.lblDesc.isHidden = true
//                cell.ivArroe.image = UIImage(named: "uparrow")
//                cell.bgView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1.0)
//                cell.lblTitle.textColor = Appcolor.kTextColorBlack
//            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        100.0
    //    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       // self.selectedCellID = indexPath.row
        //self.tblView.reloadData()
        
        let obj = apiData?[indexPath.row]
        
        let controller = Navigation.GetInstance(of: .FAQDetailsVC)as! FAQDetailsVC
        controller.qsn = obj?.question ?? ""
        controller.ansr = obj?.answer ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
}

extension FAQVC : FAQVCDelegate
{
    func getData(model: [FAQResult],cats:[catDEC])
    {
        if(cats.count > 0)
        {
            self.apiDataTop = cats
            self.collTopQstn.reloadData()
            self.collTopQstn.restore()
        }
        else
        {
            self.apiDataTop = nil
            self.collTopQstn.reloadData()
            self.collTopQstn.setEmptyMessage(kDataNothingTOSHOW)
        }
        
        
        if(model.count > 0)
        {
            self.apiData = model
            self.tblView.animateReload()
            self.collTopQstn.reloadData()
            self.tblView.restore()
        }
        else
        {
            self.nothingFound()
        }
    }
    
    func nothingFound()
    {
        self.apiData = nil
        self.tblView.setAnimatingImage(fileName: kLottieEmpData ,msg :kDataNothingTOSHOW)
    }
}


extension FAQVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.apiDataTop?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClass_Top", for: indexPath)as! CellClass_Top
        let data = self.apiDataTop?[indexPath.row].catName
        cellnew.lblTitle.text = data
        
        if (selectdTop == indexPath.row)
        {
            cellnew.lblTitle.textColor = UIColor.white
            cellnew.lblTitle.backgroundColor = kpurpleTheme
            
            cellnew.lblTitle.layer.borderColor = UIColor.clear.cgColor
            cellnew.lblTitle.layer.borderWidth = 1.0
        }
        else
        {
            cellnew.lblTitle.textColor = UIColor.darkGray
            cellnew.lblTitle.backgroundColor = UIColor.white
            
            cellnew.lblTitle.layer.borderColor = UIColor.darkGray.cgColor
            cellnew.lblTitle.layer.borderWidth = 0.5
        }
        
        cellnew.lblTitle.layer.cornerRadius = 10
        cellnew.lblTitle.layer.masksToBounds = true
        return cellnew
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectdTop = indexPath.row
        self.selectdCat = self.apiDataTop?[indexPath.row].id ?? 0
        self.collTopQstn.reloadData()
        self.viewModel?.getFAQList()
    }
    
}



extension FAQVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.apiDataTop![indexPath.item].catName
        label.sizeToFit()
        return CGSize(width: label.frame.size.width+50, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5.0
    }
    
    
}
