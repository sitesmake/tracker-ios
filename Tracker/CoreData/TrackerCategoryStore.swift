import Foundation

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let categoryDataSource: TrackerCategoryDataSourceProtocol

    init(categoryDataSource: TrackerCategoryDataSourceProtocol) {
        self.categoryDataSource = categoryDataSource
    }

    func getCategoryNames() -> [String] {
        return categoryDataSource.getCategoryNames()
    }

    func getCategoryWithName(_ name: String) -> TrackerCategory? {
        return categoryDataSource.getCategoryWithName(name)
    }

    func addCategory(name: String) throws {
        try categoryDataSource.addCategory(name: name)
    }
}
