//
//  CollectionListSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionListSection: ListSectionController, ASSectionController {
    // MARK: - Variables
    var collection: Dashboard!
    var date: Date = Date()
    
    // MARK: - Init
    init(collection: Dashboard) {
        super.init()
        self.collection = collection
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let title = self.collection.title
        let image = UIImage(named: self.collection.image)!
        
        let cards = Database.manager.data.objects(Card.self).filter(Sources.predicate).filter("dashboard=%@", self.collection.id).sorted(byKeyPath: Sources.sorted, ascending: Sources.ascending)
        var previews = [ASCellNode]()
        for c in cards {
            if let card = c.data as? Collectible {
                if let cell = card.collectionCellFor(self.date) {
                    previews.append(cell)
                }
            }
        }
        
        let statCards = Database.manager.data.objects(Card.self).filter("isDeleted=%@ AND dashboard=%@", false, self.collection.id)
        var data = [(title: String, subtitle: String)]()
        data.append((title: "\(statCards.count)", subtitle: Localizations.Collection.Analytics.cards))
        data.append((title: "\(statCards.filter("archived=%@", true).count)", subtitle: Localizations.Activity.Analytics.Stat.archived))
        data.append((title: DateFormatter.localizedString(from: self.collection.created, dateStyle: .short, timeStyle: .none), subtitle: Localizations.Collection.Analytics.created))
        
        return {
            let node = CollectionListNode(title: title, image: image, previews: previews, data: data)
            node.editButton.addTarget(self, action: #selector(self.editCollectionButtonAction(sender:)), forControlEvents: .touchUpInside)
            return node
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
        let max = CGSize(width: width - 20.0, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width - 20.0, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if let nav = self.viewController?.navigationController {
            if let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as? EvaluateViewController {
                controller.collection = self.collection.id
                Feedback.player.select()
                nav.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - Actions
    @objc func editCollectionButtonAction(sender: ASButtonNode) {
        if let nav = self.viewController?.navigationController {
            let controller = UIStoryboard(name: Storyboards.editCollection.rawValue, bundle: nil).instantiateInitialViewController() as! EditCollectionViewController
            controller.collection = self.collection
            Feedback.player.notify(type: UINotificationFeedbackGenerator.FeedbackType.success)
            nav.pushViewController(controller, animated: true)
        }
    }
}
