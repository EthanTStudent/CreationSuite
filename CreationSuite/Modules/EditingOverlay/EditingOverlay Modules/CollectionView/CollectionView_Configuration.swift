import Foundation
import UIKit

extension CollectionView {
    // MARK: - CollectionView Configuration
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("_____")
//        print("THIS IS BEING CALLED")
//        print("indexPath.row: \(indexPath.row)")
//        print(dataModel.operations!.getUnremovedIndexFromAgnosticInt(agnosticIndex: indexPath.row))
//        print("_____")
        let width = dataModel.operations!.getDisplayWidthOfCell(index: indexPath.row)
        let height = dataModel.operations!.getDisplayHeightOfCell(index: indexPath.row)
        return CGSize(width: width, height: height)
    }
    
    func configureCollectionViewLayoutItemSize() {
        layout.sectionInset = UIEdgeInsets(top: 0, left: dataModel.configuration!.inset, bottom: 0, right: dataModel.configuration!.inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.operations!.getCellCount()
    }
    
    //return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if dataModel.cellAttributes[indexPath.row].collectionViewCell != nil
//        {
//            print("they already have one of me at \(indexPath.row)")
//            return dataModel.cellAttributes[indexPath.row].collectionViewCell!
//        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        
        print("making one at \(indexPath.row)")
        
        dataModel.operations!.storeCellAndIndexPath(indexPath: indexPath, cell: cell)
        dataModel.operations!.configureCell(indexPath: indexPath)
        
        dataModel.cellAttributes[indexPath.row].collectionViewCell!.focusedCellBody = dataModel.cellAttributes[indexPath.row].focusedCellBody
        dataModel.cellAttributes[indexPath.row].collectionViewCell!.unfocusedCellBody = dataModel.cellAttributes[indexPath.row].unfocusedCellBody
        
        dataModel.cellAttributes[indexPath.row].collectionViewCell!.contentView.addSubview(dataModel.cellAttributes[indexPath.row].collectionViewCell!.focusedCellBody!)
        dataModel.cellAttributes[indexPath.row].collectionViewCell!.contentView.addSubview(dataModel.cellAttributes[indexPath.row].collectionViewCell!.unfocusedCellBody!)
        
        return cell
    }
    
}
