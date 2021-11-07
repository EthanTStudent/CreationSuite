import Foundation
import UIKit

extension CollectionView {
    // MARK: - CollectionView Configuration
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("_____")
        print("THIS IS BEING CALLED")
        print("indexPath.row: \(indexPath.row)")
        print(dataModel.operations!.getUnremovedIndexFromAgnosticInt(agnosticIndex: indexPath.row))
        print("_____")
        let width = dataModel.operations!.getDisplayWidthOfCell(index: dataModel.operations!.getUnremovedIndexFromAgnosticInt(agnosticIndex: indexPath.row))
        let height = dataModel.operations!.getDisplayHeightOfCell(index: dataModel.operations!.getUnremovedIndexFromAgnosticInt(agnosticIndex: indexPath.row))
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        dataModel.operations!.storeCellAndIndexPath(indexPath: indexPath, cell: cell)
        dataModel.operations!.configureCell(indexPath: indexPath)
        
        return cell
    }
    
}
