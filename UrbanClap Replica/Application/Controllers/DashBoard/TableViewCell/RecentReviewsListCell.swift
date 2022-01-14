
//

import UIKit

class RecentReviewsListCell: UITableViewCell {
    //MARK:- Outlet And Variables
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
         collectionView.delegate = self
         collectionView.dataSource = self
         collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK:- SetCollectionViewDelegate
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}

//MARK:- CollectionView DataSource and Delegate
extension RecentReviewsListCell:UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentReviewCollectionCell", for: indexPath) as? RecentReviewCollectionCell
                 {
                     return cell
                 }
        return UICollectionViewCell()
    }
}
