//
//  AlternateIconItemTableViewController.swift
//  ChangeAppIcon
//
//  Created by TranBa Thiet on 5/24/18.
//  Copyright © 2018 TranBa Thiet. All rights reserved.
//

import UIKit

class AlternateIconItemTableViewController: UITableViewController {

    private let kCellIdentifier = String(describing: AlternateIconTableViewCell.self)
    private let rowHeight: CGFloat = 80
    private var alternateIconItems = [AlternateIconItem]()
    private var currentIconItem: AlternateIconItem?
    private var tableHeaderView: AlternateIconTableHeaderView?
    let viewHeight: CGFloat = {
        let kHeaderIconMarginTopAndBottom: CGFloat = 15
        let kHeaderIconSize: CGFloat = 60
        return (kHeaderIconSize + kHeaderIconMarginTopAndBottom * 2)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        createAlternateIconItems()
        createHeaderView()
    }

    private func createHeaderView() {
        guard let currentIconItem = currentIconItem else {
            return
        }
        tableView.register(AlternateIconTableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: viewHeight)
        tableHeaderView = AlternateIconTableHeaderView(alternateIconItem: currentIconItem, frame: frame)
        tableView.tableHeaderView = tableHeaderView
    }

    private func createAlternateIconItems() {
        guard let iconDict = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String : Any] else {
            return
        }
        guard let alternateIconsDict = iconDict["CFBundleAlternateIcons"] as? [String : Any] else {
            return
        }
        var currentIconName: String?
        if #available(iOS 10.3, *), let alternateIconName = UIApplication.shared.alternateIconName {
            currentIconName = alternateIconName
        } else {
            showLowVersionAlert()
        }
        var alternateIconItems = [AlternateIconItem]()
        let iconName: String = UIDevice.current.userInterfaceIdiom == .phone ? "AppIcon" : "AppIcon"
        guard let defaultIconTitle = iconDict["DefaultIconTitle"] as? String else {
            return
        }
        let alternateIconItem = AlternateIconItem(identifier: nil, title: defaultIconTitle , imageName: iconName)
        alternateIconItems.append(alternateIconItem)
        if (currentIconName == nil) {
            currentIconItem = alternateIconItem
        }
        for key in alternateIconsDict.keys {
            let alternateIconDict = alternateIconsDict[key] as? [String : Any]
            let imageName = (alternateIconDict?["CFBundleIconFiles"] as? [Any])?.first as? String
            let iconTitle = alternateIconDict?["IconTitle"] as? String
            let alternateIconItem = AlternateIconItem(identifier: key, title: iconTitle, imageName: imageName)
            alternateIconItems.append(alternateIconItem)
            if (currentIconName == alternateIconItem.identifier) {
                currentIconItem = alternateIconItem
            }
        }
        self.alternateIconItems = alternateIconItems
    }

    private func changeIconToItem(alternateIconItem: AlternateIconItem?) {
        if #available(iOS 10.3, *) {
            guard UIApplication.shared.supportsAlternateIcons else {
                return
            }
            guard let identifier = alternateIconItem?.identifier else {
                // Reset to default
                UIApplication.shared.setAlternateIconName(nil)
                self.didChangeIconToItem(alternateIconItem: alternateIconItem!)
                return
            }
            UIApplication.shared.setAlternateIconName(identifier) { error in
                if error != nil {
                    self.showIconChangeFailerAlert()
                }
            }
            didChangeIconToItem(alternateIconItem: alternateIconItem!)
        } else {
            showLowVersionAlert()
        }
    }

    private func didChangeIconToItem(alternateIconItem: AlternateIconItem) {
        self.currentIconItem = alternateIconItem
        self.tableHeaderView?.updateIconByIconItem(alternateIconItem: alternateIconItem)
    }

    private func showLowVersionAlert() {
        showAlert(title: "Error", message: "Version phải từ 10.13 trở lên")
    }

    private func showIconChangeFailerAlert() {
        showAlert(title: nil, message: "Error change fail alert")
    }

    private func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alternateIconItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as? AlternateIconTableViewCell else{
            return AlternateIconTableViewCell()
        }
        cell.updateCell(alternateIconItem: alternateIconItems[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "List AlternateIcon" : nil
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeIconToItem(alternateIconItem: alternateIconItems[indexPath.row])
    }
}
