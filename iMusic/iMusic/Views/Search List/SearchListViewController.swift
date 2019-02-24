//
//  SearchListViewController.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import Foundation

class SearchListViewController: BaseViewController {
    
    public var presenter: SearchListPresenterDelegate?
    
    private let customTitleView: CustomTitleView = CustomTitleView()
    private let searchView: SearchView = SearchView()
    private let sortButton: UIButton = UIButton(type: .custom)
    private var sortButtonWidthConstraint: NSLayoutConstraint?
    private let noResultsLabel: UILabel = UILabel()
    private let searchListContainerView: UIView = UIView()
    private var searchListCollectionView: UICollectionView?
    private let suggestionsView = SuggestionsView()
    private var suggestionsViewBottomConstraint: NSLayoutConstraint?
    
    private var datasource: SearchListDatasource?
    private var numberOfCellsInARow: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupViews()
        configureNavigationBar()
        presenter?.viewDidLoad()
    }
    
}

// MARK: - Setup views
extension SearchListViewController {
    
    /**
     * Setup views
     */
    private func setupViews() {
        view.backgroundColor = .black()
        edgesForExtendedLayout = []
        
        configureSubviews()
        addSubviews()
    }
    
    /**
     * Configure subviews
     */
    private func configureSubviews() {
        searchView.delegate = self
        
        sortButton.setTitle("Sort", for: .normal)
        sortButton.titleLabel?.font = UIFont.mediumWithSize(size: 15.0)
        sortButton.setTitleColor(.white(), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        
        suggestionsView.isHidden = true
        suggestionsView.delegate = self
        
        noResultsLabel.font = UIFont.mediumWithSize(size: 14.0)
        noResultsLabel.textColor = .white()
        noResultsLabel.text = "No results. Please try again"
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        searchListCollectionView = UICollectionView(frame: searchListContainerView.bounds, collectionViewLayout: flowLayout)
        searchListCollectionView?.backgroundColor = .clear
        searchListCollectionView?.isUserInteractionEnabled = true
        searchListCollectionView?.showsVerticalScrollIndicator = false
        searchListCollectionView?.delegate = self
        registerCells()
        setupDatasource()
    }
    
    /**
     * Configure navigation bar
     */
    private func configureNavigationBar() {
        customTitleView.titleColor = .white()
        customTitleView.setTitle("iMusic")
        customTitleView.subtitleColor = .white()
        customTitleView.setSubtitle("using iTunes© API")
        navigationItem.titleView = customTitleView
    }
    
    /**
     * Register all the cells for the collection view
     */
    private func registerCells() {
        searchListCollectionView?.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
    }
    
    /**
     * Setup the data source
     */
    private func setupDatasource() {
        if let searchListCollectionView = searchListCollectionView {
            datasource = SearchListDatasource()
            searchListCollectionView.dataSource = datasource
        }
    }
    
    /**
     * Get track cell size
     */
    private func getTrackCellSide() -> CGFloat {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let cellContainerWidth: CGFloat = screenWidth - Layout.CollectionViewCell.centerSpacing*(CGFloat(numberOfCellsInARow-1)) - Layout.CollectionViewCell.edgeSpacingLeft*CGFloat(numberOfCellsInARow)
        return cellContainerWidth / CGFloat(numberOfCellsInARow)
    }
    
    /**
     * Add observers to the view
     */
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - Layout & constraints
extension SearchListViewController {
    
    /**
     * Internal struct for layout
     */
    private struct Layout {
        
        struct CollectionViewCell {
            static let centerSpacing: CGFloat = 16.0
            static let edgeSpacingTop: CGFloat = 24.0
            static let edgeSpacingLeft: CGFloat = 16.0
            static let edgeSpacingBottom: CGFloat = 24.0
            static let edgeSpacingRight: CGFloat = 16.0
        }
        
        struct NoResultsLabel {
            static let height: CGFloat = 17.0
        }
        
        struct SortButton {
            static let leading: CGFloat = 5.0
            static let trailing: CGFloat = 16.0
            static let width: CGFloat = 80.0
            static let top: CGFloat = 7.5
            static let height: CGFloat = 31.0
        }
        
        struct SearchListContainerView {
            static let top: CGFloat = 10.0
        }
        
    }
    
    /**
     * Internal struct for animation
     */
    private struct Animation {
        
        static let animationDuration: TimeInterval = 0.25
        
    }
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        view.addSubview(searchView)
        view.addSubview(sortButton)
        view.addSubview(searchListContainerView)
        view.addSubview(suggestionsView)
        searchListContainerView.addSubview(noResultsLabel)
        
        let noResultsLabelCenterX = NSLayoutConstraint(item: noResultsLabel, attribute: .centerX, relatedBy: .equal, toItem: searchListContainerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        searchListContainerView.addConstraint(noResultsLabelCenterX)
        let noResultsLabelCenterY = NSLayoutConstraint(item: noResultsLabel, attribute: .centerY, relatedBy: .equal, toItem: searchListContainerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        searchListContainerView.addConstraint(noResultsLabelCenterY)
        searchListContainerView.addConstraintsWithFormat("H:|[v0]|", views: noResultsLabel)
        searchListContainerView.addConstraintsWithFormat("V:[v0(\(Layout.NoResultsLabel.height))]", views: noResultsLabel)
        
        view.addConstraintsWithFormat("H:|[v0]-\(Layout.SortButton.leading)-[v1(\(Layout.SortButton.width))]-\(Layout.SortButton.trailing)-|", views: searchView, sortButton)
        view.addConstraintsWithFormat("V:|[v0(\(searchView.height))]", views: searchView)
        
        view.addConstraintsWithFormat("V:|-\(Layout.SortButton.top)-[v0(\(Layout.SortButton.height))]", views: sortButton)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: searchListContainerView)
        view.addConstraintsWithFormat("V:[v0]-\(Layout.SearchListContainerView.top)-[v1]|", views: searchView, searchListContainerView)
        
        if let searchListCollectionView = searchListCollectionView {
            searchListContainerView.addSubview(searchListCollectionView)
            searchListContainerView.addConstraintsWithFormat("H:|[v0]|", views: searchListCollectionView)
            searchListContainerView.addConstraintsWithFormat("V:|[v0]|", views: searchListCollectionView)
        }
        
        view.addConstraintsWithFormat("H:|[v0]|", views: suggestionsView)
        view.addConstraintsWithFormat("V:[v0][v1]", views: searchView, suggestionsView)
        let suggestionsViewBottomConstraint = NSLayoutConstraint(item: suggestionsView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(suggestionsViewBottomConstraint)
        self.suggestionsViewBottomConstraint = suggestionsViewBottomConstraint
    }
    
    /**
     * Show suggestions
     *
     * - parameters:
     *      -show: show / hide the suggestions
     *      -height: the height for the suggestions content
     *      -animated: show / hide suggestions with animation or not
     */
    private func showSuggestions(show: Bool, height: CGFloat, animated: Bool) {
        let animateDuration = animated ? Animation.animationDuration : 0;
        suggestionsViewBottomConstraint?.constant = height
        suggestionsView.isHidden = !show
        UIView.animate(withDuration: animateDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - User actions
extension SearchListViewController {
    
    @objc private func sortButtonPressed() {
        showSortOptions()
    }
    
    
    private func showSortOptions() {
        let alertController = UIAlertController(
            title: "Sort results options",
            message: nil,
            preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "By song length", style: .default, handler: { [weak self] (action) in
            guard let `self` = self else { return }
            self.sortResultsBy(.length)
        }))
        
        alertController.addAction(UIAlertAction(title: "By genre", style: .default, handler: { [weak self] (action) in
            guard let `self` = self else { return }
            self.sortResultsBy(.genre)
        }))
        
        alertController.addAction(UIAlertAction(title: "By price", style: .default, handler: { [weak self] (action) in
            guard let `self` = self else { return }
            self.sortResultsBy(.price)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Sort options
extension SearchListViewController {
    
    private func sortResultsBy(_ type: SortType) {
        presenter?.sortTracksBy(type)
    }
    
}

// MARK: - Keyboard actions
extension SearchListViewController {
    
    /**
     * Control the keyboard will appear action
     *
     * - parameters:
     *      -notification: notification from the keyboard
     */
    @objc private func keyboardWillBeAppear(notification: NSNotification) {
        guard let info:[AnyHashable:Any] = notification.userInfo,
            let keyboardSize:CGSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        presenter?.getSuggestions()
        showSuggestions(show: true, height: -keyboardSize.height, animated: true)
    }
    
    /**
     * Control the keyboard will be hidden action
     *
     * - parameters:
     *      -notification: notification from the keyboard
     */
    @objc private func keyboardWillBeHidden(notification: NSNotification) {
        showSuggestions(show: false, height: 0.0, animated: true)
    }
    
}

// MARK: - SuggestionsViewDelegate
extension SearchListViewController: SuggestionsViewDelegate {
    
    func suggestionSelectedAt(index: Int) {
        showSuggestions(show: false, height: 0.0, animated: false)
        searchView.hideKeyboard()
        presenter?.suggestionSelectedAt(index)
    }
    
}

// MARK: - UICollectionViewDelegate (with UICollectionViewDelegateFlowLayout)
extension SearchListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = getTrackCellSide()
        
        return CGSize(width: side, height: TrackCollectionViewCell.getHeight(for: side))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Layout.CollectionViewCell.edgeSpacingTop, left: Layout.CollectionViewCell.edgeSpacingLeft, bottom: Layout.CollectionViewCell.edgeSpacingBottom, right: Layout.CollectionViewCell.edgeSpacingRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.CollectionViewCell.centerSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.CollectionViewCell.centerSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.trackSelectedAt(indexPath.row)
    }
    
}

// MARK: - SearchViewDelegate
extension SearchListViewController: SearchViewDelegate {
    
    /**
     * Method to catch the search action
     *
     * - parameters:
     *      -search: the search term
     */
    func searchButtonPressedWithSearch(_ search: String?) {
        presenter?.searchTrack(search)
    }
    
}

// MARK: - SearchListViewInjection
extension SearchListViewController: SearchListViewInjection {
    
    /**
     * Show progress
     *
     * - parameters:
     *      -show: show / hide the progress
     *      -status: the text to show in the progress
     */
    func showProgress(_ show: Bool, status: String) {
        showLoader(show, status: status)
    }
    
    /**
     * Show progress
     *
     * - parameters:
     *      -show: show / hide the progress
     */
    func showProgress(_ show: Bool) {
        showLoader(show)
    }
    
    /**
     * Show message (alert)
     *
     * - parameters:
     *      -title: title for the alert
     *      -message: message to show in the alert
     *      -actionTitle: text for the action
     */
    func showMessageWith(title: String, message: String, actionTitle: String) {
        showAlertWith(title: title, message: message, actionTitle: actionTitle)
    }
    
    /**
     * Load tracks
     *
     * - parameters:
     *      -viewModels: array for view model tracks
     *      -fromBeginning: boolean to determinate if we're loading the tracks from scratch
     */
    func loadTracks(_ viewModels: [TrackViewModel], fromBeginning: Bool) {
        if fromBeginning {
            searchListCollectionView?.setContentOffset(CGPoint.zero, animated: false)
        }
        
        datasource?.items = viewModels
        searchListCollectionView?.reloadData()
        
        searchListCollectionView?.isHidden = viewModels.isEmpty
        noResultsLabel.isHidden = !viewModels.isEmpty
    }
    
    /**
     * Load suggestions
     *
     * - parameters:
     *      -suggestions: array for view model suggestions
     */
    func loadSuggestions(_ suggestions: [SuggestionViewModel]) {
        suggestionsView.suggestions = suggestions
    }
    
}

