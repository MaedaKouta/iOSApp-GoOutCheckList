import Foundation
import RxCocoa
import RxSwift
import RxRelay
import RxRealm
import RealmSwift

// MARK: - Protocol
// MARK: Inputs
public protocol CategoryTableViewModelInputs {
    var tableViewItemSeletedObservable: Observable<IndexPath> { get }
}

// MARK: Outputs
public protocol CategoryTableViewModelOutputs {
    var categoryDataBehaviorRelay: BehaviorRelay<List<Category>> { get }
    var tableViewItemSeletedPublishRelay: PublishRelay<IndexPath> { get }
    var addCategoryPublishRelay: PublishRelay<Void> { get }
    var isContainDataPublishRelay: PublishRelay<Bool> { get }
}

// MARK: InputOutputType
public protocol CategoryTableViewModelType {
  var inputs: CategoryTableViewModelInputs { get }
  var outputs: CategoryTableViewModelOutputs { get }
}

// MARK: - ViewModel
class CategoryTableViewModel: CategoryTableViewModelInputs, CategoryTableViewModelOutputs, CategoryTableViewModelType {

    // MARK: Inputs
    internal var tableViewItemSeletedObservable: Observable<IndexPath>

    // MARK: Outputs
    public var categoryDataBehaviorRelay = BehaviorRelay<List<Category>>(value: List<Category>())
    public var tableViewItemSeletedPublishRelay = PublishRelay<IndexPath>()
    public var addCategoryPublishRelay = PublishRelay<Void>()
    public var isContainDataPublishRelay = PublishRelay<Bool>()

    // MARK: InputOutputType
    public var inputs: CategoryTableViewModelInputs { return self }
    public var outputs: CategoryTableViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let realm = RealmManager().realm
    private let disposeBag = DisposeBag()
    private var categoryListObjext = RealmManager().realm.objects(CategoryList.self).first?.list

    // MARK: - Initialize
    /*
     categoryDataBehaviorRelayはCategoryTableViewの要素
     CategoryTableViewModelで初期値設定・管理をする
     */
    init(tableViewItemSeletedObservable: Observable<IndexPath>) {
        self.tableViewItemSeletedObservable = tableViewItemSeletedObservable

        if self.categoryListObjext != nil {
            categoryListObjext = realm.objects(CategoryList.self).first?.list
            self.categoryDataBehaviorRelay
                .accept(categoryListObjext!)
        }

        setupBindings()
        setupNotifications()
    }

    // MARK: Updatas
    func updateCategoryList() {
        categoryListObjext = realm.objects(CategoryList.self).first?.list

        self.categoryDataBehaviorRelay
            .accept(categoryListObjext ?? List<Category>())
        self.addCategoryPublishRelay.accept(())
    }

    // MARK: - Setups
    private func setupBindings() {
        tableViewItemSeletedObservable.asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                self?.outputs.tableViewItemSeletedPublishRelay.accept(indexPath)
            }).disposed(by: disposeBag)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCategoryViewCall(notification:)),
            name: NSNotification.Name.CategoryViewFromRegisterViewNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromEditViewCall(notification:)),
            name: NSNotification.Name.CategoryViewFromEditOverwriteNotification,
            object: nil)
    }

    // MARK: - Functions
    /*
     RegisterCategoryViewControllerから呼ばれる通知
        遷移先（RegisterCategoryViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc private func fromRegisteCategoryViewCall(notification: Notification) {
        if let categoryItem = notification.object as? Category {
            categoryListObjext = realm.objects(CategoryList.self).first?.list

            // RealmのcategoryListObjextが空だった場合に追加もさせる
            try! self.realm.write() {
                if self.categoryListObjext == nil {
                    let categoryList = CategoryList()
                    categoryList.list.append(categoryItem)
                    self.realm.add(categoryList)
                    self.categoryListObjext = self.realm.objects(CategoryList.self).first?.list
                } else {
                    self.categoryListObjext!.append(categoryItem)
                }

                self.categoryDataBehaviorRelay
                    .accept(categoryListObjext!)
            }

            self.addCategoryPublishRelay.accept(())

        }
    }

    @objc private func fromEditViewCall(notification: Notification) {
        guard let index = notification.userInfo!["index"] as? Int,
              let categoryListObjext = realm.objects(CategoryList.self).first?.list,
              let categoryItem = notification.object as? Category else {
            return
        }

        try! self.realm.write() {
            self.categoryListObjext![index].name = categoryItem.name
            self.categoryListObjext![index].assetsImageName = categoryItem.assetsImageName
            self.categoryDataBehaviorRelay
                .accept(categoryListObjext)
        }

        self.addCategoryPublishRelay.accept(())
    }
}
