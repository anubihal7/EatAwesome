
//

import UIKit

class RatingListVC: CustomController
{
    @IBOutlet var tableViewRatings: UITableView!
    
    var apiDATA : [rateData]?
    let cellID = "CellClass_RatingList"
    var viewModel:RatingList_ViewModel?
    
    var row = 0
    var isSkeleton = true
    var skeletonItems = 5
    var pageCount = 1
    var serviceID = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewModel = RatingList_ViewModel.init(Delegate: self, viewMain: self, view: self)
        
        self.viewModel?.getRatingList(Page:pageCount,Limit:20,servcID:serviceID)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionMoveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
}

extension RatingListVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (isSkeleton == false)
        {
            return self.apiDATA?.count ?? 0
        }
        return skeletonItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CellClass_RatingList
        
        if let data =  self.apiDATA?[indexPath.row]
        {
            cell.hideAnimation()
            let name = "\(data.user.firstName) \(data.user.lastName)"
            cell.lblName.text = name
            cell.viewRating.rating = Double(data.rating) ?? 0.0
            let img = data.user.image ?? ""
            cell.ivUser.setImage(with: img, placeholder: kplaceholderImage)
            cell.ivUser.CornerRadius(radius: 10.0)
            
            if (img.count == 0)
            {
                cell.ivUser.image = UIImage(named: kplaceholderImage)
            }
            
            cell.lblDes.text = data.review
            if (data.review.count == 0)
            {
               cell.lblDes.text = "N/A"
            }
            
        }
        else
        {
            cell.showAnimation()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row+1 == self.apiDATA?.count
        {
            pageCount = pageCount+1
            self.viewModel?.getRatingList(Page:pageCount,Limit:20,servcID:serviceID)
        }
    }
    
}



extension RatingListVC : RatingListVCDelegate
{
    func getData(model: [rateData])
    {
        if (model.count > 0)
        {
            isSkeleton = false
            if (self.apiDATA?.count == nil)
            {
                self.apiDATA = model
            }
            else
            {
                self.apiDATA = self.apiDATA! + model
            }
            
            self.tableViewRatings.animateReload()
            self.tableViewRatings.restore()
        }
        else
        {
            if (self.apiDATA?.count == nil)
            {
                self.nothingFound()
            }
        }
    }
    
    func nothingFound()
    {
        if (self.apiDATA?.count == nil)
        {
            self.apiDATA = nil
           // self.tableViewRatings.setEmptyMessage("Reviews Not Available!")
            self.tableViewRatings.setAnimatingImage(fileName: kLottieEmpData ,msg :"Reviews Not Available!")
            self.isSkeleton = false
            self.tableViewRatings.animateReload()
        }
    }
}
