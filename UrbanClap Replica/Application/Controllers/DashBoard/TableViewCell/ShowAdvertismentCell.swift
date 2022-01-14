
//

import UIKit

class ShowAdvertismentCell: UITableViewCell {

  //MARK:- Outlet and Variables
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var bannerList = [BannerNew]()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
         collectionView?.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        // Initialization code
      //  let indexPath = IndexPath(row: itemIndex, section: sectionIndex)

       
        startTimer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- SetScrollTime
    func startTimer() {

        let timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)



      }
   
      @objc func scrollToNextCell(){
         
        if let coll  = collectionView {
               for cell in coll.visibleCells {
                   let indexPath: IndexPath? = coll.indexPath(for: cell)
                   if ((indexPath?.row)! < bannerList.count - 1){
                       let indexPath1: IndexPath?
                       indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)

                       coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                   }
                   else{
                       let indexPath1: IndexPath?
                       indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                       coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                   }

               }
           }

      }
    
    //MARK:- SetCollectionViewDelegate
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int)
    {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}

//MARK:- CollectionView DataSource and Delegate
extension ShowAdvertismentCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeIdentifiers.AdvertismentCollectionCell, for: indexPath) as? AdvertismentCollectionCell
         {
                cell.setView()
                cell.setBanner(bannerList:self.bannerList[indexPath.row])
                     return cell
         }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
      }
  

}

