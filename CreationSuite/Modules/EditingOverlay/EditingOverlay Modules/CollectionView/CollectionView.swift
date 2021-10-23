import Foundation
import UIKit

class CollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    static let identifier = "CollectionView"
        
    //MARK: - Initital Load
    
    let dataModel: DataModel
    
    let layout = UICollectionViewFlowLayout()
    
    let generator = UISelectionFeedbackGenerator()
    var initialLoaded: Bool = false
    
    var autoScroll: Bool = false 
    var jumping: Bool = false
    
    let collectionViewFrameHeight: CGFloat = 140
    
    init(model: DataModel, yCenter: CGFloat){
        dataModel = model

        super.init(frame: CGRect(x: 0, y: yCenter - (collectionViewFrameHeight / 2), width: UIScreen.main.bounds.width, height: collectionViewFrameHeight), collectionViewLayout: layout)
        
        self.dataSource = self
        self.bounces = false
        self.backgroundColor = .clear
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizesSubviews = false
    
        self.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    
        self.layout.minimumInteritemSpacing = dataModel.configuration!.interItemSpacing
        self.layout.scrollDirection = .horizontal
    
        self.generator.prepare()
                
        model.collectionView = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCollectionViewLayoutItemSize()  
        guard initialLoaded else {
            _ = dataModel.operations!.cellUpdateDetected(index: dataModel.operations!.getCurrentFocused())
            self.contentOffset.x = 0
            initialLoaded = true
            return
        }
    }
}
   
