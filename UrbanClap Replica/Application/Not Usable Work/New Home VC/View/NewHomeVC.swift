
//

import UIKit

class NewHomeVC: UIViewController
{
    
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var tableViewHome: UITableView!

    var BannersTableCell = "BannersTableCell"
    var TopPicksTableCell = "TopPicksTableCell"
    var VendorsNewTableCell = "VendorsNewTableCell"
    var TrendingTableCell = "TrendingTableCell"
    var BestSellerTableCell = "BestSellerTableCell"
    var OffersTableCell = "OffersTableCell"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
}

////MARK:- TableView Delegate and DataSource
//extension NewHomeVC:UITableViewDelegate,UITableViewDataSource
//{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return 6
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//
//        switch indexPath.row
//        {
//        case 0:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: BannersTableCell, for: indexPath) as? BannersTableCell
//            {
////                if let bannerData = self.allData?.sales
////                {
////                    cell.bannerList = bannerData
////                    cell.collectionView.setEmptyMessage("")
////                    cell.collectionView.reloadData()
////                }
////                else
////                {
////                    cell.bannerList.removeAll()
////                    cell.collectionView.setEmptyMessage("No Record Found!")
////                }
//
//
//                cell.bannerCollectionView.reloadData()
//                return cell
//            }
//            break
//        case 1:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: TopPicksTableCell, for: indexPath) as? TopPicksTableCell
//            {
//                cell.topPicksCollcnView.reloadData()
//                return cell
//            }
//            break
//        case 2:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: VendorsNewTableCell, for: indexPath) as? VendorsNewTableCell
//            {
//
//
//                return cell
//            }
//            break
//        case 3:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableCell, for: indexPath) as? TrendingTableCell
//            {
//
//                cell.trendingCollcnView.reloadData()
//                return cell
//            }
//            break
//        case 4:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: BestSellerTableCell, for: indexPath) as? BestSellerTableCell
//            {
//
//
//                return cell
//            }
//            break
//
//         case 5:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: OffersTableCell, for: indexPath) as? OffersTableCell
//            {
//
//                cell.offersCollcnView.reloadData()
//                return cell
//            }
//            break
//
//        default:
//            break
//
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//}
