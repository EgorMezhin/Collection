//
//  ViewController.swift
//  Collection
//
//  Created by Egor Mezhin on 27.07.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private struct Constants {
        static let cellIdentider = "Cell"
        static let topInset: CGFloat = 250
        static let insetForSection = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        static let minimumLineSpacingForSection: CGFloat = 10
        static let numberOfItems = 100
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellIdentider)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupUI()
    }
}

// MARK: - Private methods
extension ViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topInset),
            collectionView.heightAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.insetForSection
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let center = CGPoint(x: targetContentOffset.pointee.x + collectionView.bounds.width / 2,
                             y: targetContentOffset.pointee.y + collectionView.bounds.height / 2)
        guard let indexPath = collectionView.indexPathForItem(at: center),
              let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        
        let insets = collectionView.contentInset
        let itemSize = attributes.frame.size
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        let newX = round((targetContentOffset.pointee.x - insets.left) / (itemSize.width + spacing)) * (itemSize.width + spacing)
        
        targetContentOffset.pointee = CGPoint(x: newX, y: targetContentOffset.pointee.y)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentider,
                                                      for: indexPath)
        cell.backgroundColor = .cyan
        cell.layer.cornerRadius = 10
        return cell
    }
}
