//
//  TrackersViewController.swift
//  Tracker
//
//  Created by alexander on 09.03.2025.
//

import UIKit

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol, TrackerTypeDelegate, TrackerCollectionViewCellDelegate {
    var presenter: TrackersPresenter?

    enum Sizes {
        static let contentInsets: CGFloat = 16
        static let spacing: CGFloat = 9
    }

    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.contentInset = UIEdgeInsets(top: 24, left: Sizes.contentInsets, bottom: 24, right: Sizes.contentInsets)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collectionView
    }()

    private lazy var emptyScreenView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        let emptyScreenImage = UIImageView()
        emptyScreenImage.image = UIImage(named: "Star")
        emptyScreenImage.translatesAutoresizingMaskIntoConstraints = false


        let emptyScreenText = UILabel()
        emptyScreenText.translatesAutoresizingMaskIntoConstraints = false
        emptyScreenText.text = "Что будем отслеживать?"
        emptyScreenText.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        view.addSubview(emptyScreenImage)
        view.addSubview(emptyScreenText)

        NSLayoutConstraint.activate([
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyScreenText.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyScreenText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        return view
    }()

    private lazy var datePickerButton: UIBarButtonItem = {

        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setDateForTrackers), for: .valueChanged)

        let dateButton = UIBarButtonItem(customView: datePicker)

        return dateButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupCategories()
        view.backgroundColor = .ypWhite
        setupNavbar()
        addSubviews()
        constraintSubviews()
    }

    private func addSubviews() {
        view.addSubview(trackersCollectionView)
        view.addSubview(emptyScreenView)
    }

    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            emptyScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupNavbar() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushTrackerTypeViewController))
        leftButton.tintColor = .ypBlack
        navigationBar.topItem?.setLeftBarButton(leftButton, animated: true)

        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationBar.topItem?.searchController = searchController

        navigationBar.topItem?.setRightBarButton(datePickerButton, animated: true)
    }

    private func setupEmptyScreen() {
        emptyScreenView.isHidden = presenter?.categories.count ?? 0 > 0
        trackersCollectionView.isHidden = presenter?.categories.count == 0
    }

    @objc
    private func pushTrackerTypeViewController() {
        let vc = TrackerTypeViewController()
        let presenter = TrackerTypePresenter()

        vc.presenter = presenter
        presenter.view = vc

        presenter.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .formSheet
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }

    @objc
    private func setDateForTrackers(_ sender: UIDatePicker) {
        presenter?.currentDate = sender.date
        trackersCollectionView.reloadData()
    }

    func didSelectType(_ type: TrackerType) {
        // TODO NewHabitVC()
    }

    func didCreateTracker(_ tracker: Tracker, at category: TrackerCategory) {
        presenter?.addTracker(tracker, at: category)
        trackersCollectionView.reloadData()
    }

    func didComlete(_ complete: Bool, tracker: Tracker) {
        presenter?.completeTracker(complete, tracker: tracker)
    }
}

extension TrackersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        setupEmptyScreen()
        return presenter?.categories.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.categories[section].trackers.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCollectionViewCell,
              let presenter
        else { return UICollectionViewCell() }

        let tracker = presenter.categories[indexPath.section].trackers[indexPath.row]

        cell.tracker = tracker
        cell.delegate = self
        cell.comletedTracker = presenter.isCompletedTracker(tracker)
        cell.daysCounter = presenter.countRecordsTracker(tracker)
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id = "header"

        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        view.title.text = presenter?.categories[indexPath.section].title
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - Sizes.contentInsets * 2 - Sizes.spacing) / 2 , height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return Sizes.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 0, bottom: 16, right: 0)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search = searchText
        trackersCollectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.search = ""
        trackersCollectionView.reloadData()
    }
}
