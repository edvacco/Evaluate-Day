//
//  CounterEditableSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

private enum CounterSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case separator
    case step
    case total
    case initial
}

class CounterEditableSection: ListSectionController, ASSectionController, EditableSection, TextTopViewControllerDelegate {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [CounterSettingsNodeType]()
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        self.nodesSource()
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let style = Themes.manager.cardSettingsStyle
        switch self.nodes[index] {
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.settings.general.title, style: style)
                return node
            }
        case .title:
            let title = Localizations.cardSettings.title
            let text = self.card.title
            return {
                let node = CardSettingsTextNode(title: title, text: text, style: style)
                return node
            }
        case .subtitles:
            let subtitle = Localizations.cardSettings.subtitle
            let text = self.card.subtitle
            return {
                let node = CardSettingsTextNode(title: subtitle, text: text, style: style)
                return node
            }
        case .separator:
            return {
                let separator = SeparatorNode()
                if index != 1 && index != self.nodes.count - 1 {
                    separator.insets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
                }
                return separator
            }
        case .step:
            let step = (self.card.data as! CounterCard).step
            return {
                let node = SettingsMoreNode(title: Localizations.cardSettings.counter.step, subtitle: String(format: "%.2f", step), image: nil, style: style)
                node.leftInset = 20.0
                return node
            }
        case .total:
            let title = Localizations.cardSettings.counter.sum.title
            let isOn = (self.card.data as! CounterCard).isSum
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn, style: style)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "isSum", (self.card.data as! CounterCard).isSum)
                    self.nodesSource()
                    self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
                return node
            }
        case .initial:
            let start = (self.card.data as! CounterCard).startValue
            return {
                let node = SettingsMoreNode(title: Localizations.cardSettings.counter.start, subtitle: String(format: "%.2f", start), image: nil, style: style)
                node.leftInset = 20.0
                return node
            }
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width = self.collectionContext!.containerSize.width
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if self.nodes[index] == .title {
            self.setTextHandler?(Localizations.cardSettings.title, "title", self.card.title)
        } else if self.nodes[index] == .subtitles {
            self.setTextHandler?(Localizations.cardSettings.subtitle, "subtitle", self.card.subtitle)
        } else if self.nodes[index] == .step {
            // Step value set
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "step"
            controller.delegate = self
            controller.titleLabel.text = Localizations.cardSettings.counter.step
            self.viewController?.present(controller, animated: true, completion: nil)
        } else if self.nodes[index] == .initial {
            // Start value
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "startValue"
            controller.delegate = self
            controller.titleLabel.text = Localizations.cardSettings.counter.start
            self.viewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        if let value = Double(text) {
            let counterCard = self.card.data as! CounterCard
            if counterCard.realm != nil {
                try! Database.manager.data.write {
                    counterCard[property] = value
                }
            } else {
                counterCard[property] = value
            }
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    // MARK: - Private
    private func nodesSource() {
        self.nodes.removeAll()
        
        self.nodes.append(.sectionTitle)
        self.nodes.append(.separator)
        self.nodes.append(.title)
        self.nodes.append(.separator)
        self.nodes.append(.subtitles)
        self.nodes.append(.separator)
        self.nodes.append(.step)
        self.nodes.append(.separator)
        self.nodes.append(.total)
        self.nodes.append(.separator)
        if (self.card.data as! CounterCard).isSum {
            self.nodes.append(.initial)
            self.nodes.append(.separator)
        }
    }
}
