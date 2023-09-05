//
//  UIScrollView+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/18.
//

import UIKit

public protocol ReuseableView: AnyObject {
    static var reuseIdntifier: String { get }
}

public extension ReuseableView {
    static var reuseIdntifier: String { String(describing: self) }
}

extension UITableViewCell: ReuseableView {}

extension UICollectionViewCell: ReuseableView {}

extension UITableViewHeaderFooterView: ReuseableView {}

public extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: T.reuseIdntifier)
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        register(aClass, forHeaderFooterViewReuseIdentifier: T.reuseIdntifier)
    }
    
    func dequeueReuseableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdntifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdntifier)")
        }
        return cell
    }
    
    func dequeueReuseableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdntifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdntifier)")
        }
        return view
    }

}

public extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseIdntifier)
    }
    
    func dequeueReuseableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdntifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdntifier)")
        }
        return cell
    }
    
}

