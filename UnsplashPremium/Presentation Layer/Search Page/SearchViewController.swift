//
//  SearchViewController.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 27.04.2022.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    var categoriesConstants = ["Nature", "Black and White", "Space", "Textures", "Abstract", "Minimal", "Animals", "Sky", "Flowers", "Travel", "Underwater", "Drones", "Architecture", "Gradients"]
    var categories: [CategoryCellEntity] = []
    var discovers: [DiscoverCellEntity] = []
    var categoryResults: [Resulted] = []
    var discoverResults: [Resulted] = []
    //Section titles
    enum Section: Int, CaseIterable {
        case  categories, discover
        
        func description() -> String {
            switch self {
            case .categories:
                return "Browse by Category"
            case .discover:
                return "Discover"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = categoryCast()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        fetchCategories()
    }
    
    private func fetchCategories(){
        guard let url = URL(string: "\(EndPoint.baseUrl)search/photos?page=1&per_page=\(categoriesConstants.count)&query=random&\(EndPoint.clientIdParameter)") else { return }
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do{
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                print(jsonResult.results.count)
                DispatchQueue.main.async {
                    self?.categoryResults = jsonResult.results
                    self?.categories = self?.categoryCast() ?? []
                    self?.reloadData()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    private func fetchDiscovers(){
        guard let url = URL(string: "\(EndPoint.baseUrl)search/photos?page=50&per_page=100&query=random&\(EndPoint.clientIdParameter)") else { return }
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do{
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                print(jsonResult.results.count)
                DispatchQueue.main.async {
                    self?.discoverResults = jsonResult.results
                    self?.reloadData()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.categories, .discover])
        snapshot.appendItems(categories, toSection: .categories)
        snapshot.appendItems(discovers, toSection: .discover)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func categoryCast() -> [CategoryCellEntity] {
        var categories = [CategoryCellEntity]()
        var index = 0
        categoryResults.forEach {
            categories.append(CategoryCellEntity(id: index, full: "", regular: "", small: $0.urls.small, title: ""))
            index += 1
        }
        return categories
    }
    
    //MARK: - Setup UI
    private func setupSearchBar(){
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverCell.reuseId)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseId)
    }
    
    // MARK: - Data Source
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView,
                                                                              cellProvider: { [self] collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError()
            }
            switch section {
            case .categories:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseId, for: indexPath) as? CategoryCell,
                      let data = item as? CategoryCellEntity
                else { return UICollectionViewCell() }
                cell.configure(data: data)
                cell.categoryImage.af.setImage(withURL: URL(string: categoryResults[indexPath.item].urls.small)!)
                cell.categoryTitle.text = categoriesConstants[indexPath.item]
                return cell
            case .discover:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCell.reuseId, for: indexPath) as? DiscoverCell,
                      let data = item as? DiscoverCellEntity
                else { return UICollectionViewCell() }
                cell.configure(data: data)
                cell.discoverImage.af.setImage(withURL: URL(string: discoverResults[indexPath.item].urls.regular)!)
                cell.backgroundColor = .yellow
//                cell.nameOfAuthor.text = categoriesConstants[indexPath.item]
            }
            return UICollectionViewCell()
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can not create new section header") }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            sectionHeader.configure(text: section.description(),
                                    font: .systemFont(ofSize: 26, weight: .bold),
                                    textColor: .white)
            return sectionHeader
        }
    }

    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    //    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //        <#code#>
    //    }
}


// MARK: - Setup Compositional layout
extension SearchViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .discover:
                return self.createDiscovers()
            case .categories:
                return self.createCategories()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createCategories() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width/3 - 15),
                                               heightDimension: .absolute(view.frame.width/3*2-15))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createDiscovers() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        return sectionHeader
    }
}
