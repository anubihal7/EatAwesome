
//

import UIKit

class TiffinHomeVC: BaseUIViewController
{
    //MARK:- outlet and variables
    //NavBar
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewNavBar: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPickUp: UIView!
    @IBOutlet weak var viewServices: UIView!
    @IBOutlet weak var btnTabPickUp: UIButton!
    @IBOutlet weak var btnTabMyServices: UIButton!
    //Filter
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var collectionFilter: UICollectionView!
    
    var isSkeleton_Service = true
    var skeletonItems_Service = 5
    let cellID = "TiffinHomeCell"
    var apiData = [TiffinHomeBody]()
    var selectedFilterArray = [String]()
    var page = 1
    var limit = 10
    var isFetching:Bool = false
    var isScroll = false
    var viewModel : TiffinHomeViewModel?
    var itemType,packages,search : String?
    var orderByInfo = [String:Any]()
    var searchActive : Bool = false
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:- life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    //MARK:- other functions
    func setView(){
        viewModel = TiffinHomeViewModel.init(Delegate: self, view: self)
        self.viewNavBar.backgroundColor = Appcolor.get_category_theme()
        lblLocation.textColor =  Appcolor.get_category_theme()
        imgLocation.tintColor = Appcolor.get_category_theme()
    
        //SearchBar
        self.title = "Tiffin Services"
        self.setSearchBarInNavigationController(placeholderText: "Search...", navigationTitle:  "Tiffin Services", navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        //TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.reloadData()
        
        //Collection View
        self.collectionFilter.delegate = self
        self.collectionFilter.dataSource = self
        self.collectionFilter.reloadData()
        
        //hit api
        getServiceList()
        
    }
    
    //MARK:- api
    func getServiceList(){
        viewModel?.getTiffinServiceApi(itemType: itemType, page: page, lat: AppDefaults.shared.app_LATITUDE, limit: limit, lng: AppDefaults.shared.app_LONGITUDE, packages: packages, search: search, orderByInfo: orderByInfo, completion: { (responce) in
            print(responce)
            if let data = responce.body{
                if data.count > 0{
                    self.apiData = data
                    self.tableView.setEmptyMessage("")
                    self.tableView.reloadData()
                }
                else{
                    self.tableView.setEmptyMessage(kDataNothingTOSHOW)
                }
            }
        })
    }
    //MARK:- Actions
    @IBAction func barBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func bottomTabAction(_ sender: UIButton) {
        if (sender.tag == 0){
            viewServices.isHidden = false
            viewPickUp.isHidden = true
            btnTabMyServices.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btnTabPickUp.titleLabel?.font = .systemFont(ofSize: 16)
        }
        else{
            viewServices.isHidden = true
            viewPickUp.isHidden = false
            btnTabPickUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btnTabMyServices.titleLabel?.font = .systemFont(ofSize: 16)
        }
    }
    @IBAction func btnMenuAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    @IBAction func clearFilter(_ sender: Any) {
    }
    @IBAction func filterAction(_ sender: Any) {
        
        
    }
}

//MARK:- TableView Delegate
extension TiffinHomeVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return apiData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)as! TiffinHomeCell
        cell.setView(data:apiData[indexPath.row])
        
        return cell
    }
    
    
}

//MARK:- CollectionView Delegate

extension TiffinHomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1//selectedFilterArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionCell", for: indexPath)as! FilterCollectionCell
        //cell.lblTitle.text = selectedFilterArray[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->
        CGSize {return CGSize(width: 20.00, height: 20.00)}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}
//MARK:- UISearchController Bar Delegates
extension TiffinHomeVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        search = searchText
         self.apiData.removeAll()
         getServiceList()
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.self.apiData.removeAll()
            self.getServiceList()
            
        }
    }
}

////MARK:- SearchDelegate
//extension TiffinHomeVC:UISearchBarDelegate
//{
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//        
//        
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//     
//        self.search = searchText
//       // if searchText != ""{
//            searchActive = true;
//            //hitApi
//            getServiceList()
////        }
////        else{
////            apiData.removeAll()
////            searchActive = false
////            tableView.isHidden = false
////            self.tableView.reloadData()
////        }
//                
//    }
//}
