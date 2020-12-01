//
//  PoemView.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/24.
//  Copyright © 2020 Minestrone. All rights reserved.
//
import UIKit
import SnapKit
import RxSwift
import GoogleMobileAds
import Toast_Swift

class PoemView: UIViewController {
    
    //인터페이스 빌더와 객체를 연결
//    @IBOutlet var likeButton: UIView!
//    @IBOutlet var shareButton: UIView!
//    @IBOutlet var reportButton: UIView!
//    @IBOutlet var likeCount: UILabel!
//    @IBOutlet var poemView: UIView!
//    @IBOutlet weak var titleView: UIImageView!
//    @IBOutlet var likeHeart: UIImageView!
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    
    var adsToLoad = [GADBannerView]()
    var loadStateForAds = [GADBannerView: Bool]()
    
    let adUnitID = "ca-app-pub-4708624776405006/9865082859"
    let adViewHeight = CGFloat(100)
    let adInterval = 3
    
    let poemView = UIView()
    
    let titleBackgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title_3")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var nowPage:Int = 0
    private var poemItems:Int = 0
    private let ad = UIApplication.shared.delegate as? AppDelegate
    
    private var refreshControl = UIRefreshControl()
    
    private var currentPage = 0
    
    private var poemList : [AnyObject] = []
    private var poemListOb : Observable<[PoemModel]> = Observable.just([])
    
    private var selectedPoem : PoemModel? = nil
    
    let disposeBag = DisposeBag()
    
    let viewModel = PoemViewModel()
    
    let todayTitle : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 32)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    override func viewWillLayoutSubviews() {
        navigationItem.setHidesBackButton(true, animated: false)
        
        //let moreIcon = UIImage(named: "more")
        
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItems = [add]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        poemList.removeAll()
        requestPoem()
    }
    
    private func bind() {
        viewModel.errorMessage.subscribe(onNext : {
            error in
            print("No Poem")
        }).disposed(by: disposeBag)
        
        viewModel.todayTitleSuccess.subscribe(onNext: {
            title in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                self.todayTitle.text = title
                self.todayTitle.addCharacterSpacing(kernValue: 30)
            }
        }).disposed(by: disposeBag)
        
        viewModel.poemInfoSuccess.subscribe(onNext : {
            poem in
            self.poemList.append(poem)
            if self.poemList.count % 3 == 0 {
                self.addBannerAds()
            }
            self.preloadNextAd()
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.likeSuccess.subscribe(onNext: {
            _ in
            self.updatePoem(poem: self.selectedPoem!)
        }).disposed(by: disposeBag)
        
        viewModel.reportSuccess.subscribe(onNext: {
            _ in
            print("Report Success")
        }).disposed(by: disposeBag)
        
        viewModel.poemUpdateSuccess.subscribe(onNext: {
            poem in
            self.poemList.enumerated().forEach {
                if let list = $1 as? PoemModel {
                    if list.poemId!.contains(poem.poemId!) {
                        self.poemList.remove(at: $0)
                        self.poemList.insert(poem, at: $0)
                        self.collectionView.reloadItems(at: [IndexPath.init(row: $0, section: 0)])
                        let cell = self.collectionView.cellForItem(at: IndexPath.init(row: $0, section: 0)) as! PoemCell
                        cell.configure(with: poem)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        add.rx.tap.bind { [self]
            _ in
            let targetVC = PoemAddView()
            self.navigationController?.pushViewController(targetVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - HorizontalCollectionView 초기화
    let collectionView: UICollectionView = {
        
        // 전체 레이아웃 초기화
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0

        // CollectionView 초기화
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    // 페이징 이후 좋아요 갯수와 좋아요 상태 변경
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if let indexPath = carouselCollectionView.indexPathsForVisibleItems.first {
//            self.currentPage = indexPath.row
//
//            likeCount.text = String(poems[currentPage].like)
//
//            if poems[self.currentPage].liked != false {
//                likeHeart.image = UIImage(systemName: "heart.fill")
//                likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
//            } else {
//                likeHeart.image = UIImage(systemName: "heart")
//                likeHeart.tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
//            }
//        }
    }
    
    // MARK: - 뷰 초기화
    func initView() {
        view.addSubview(poemView)
        
        poemView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
        collectionView.backgroundColor = .clear
        poemView.addSubview(titleBackgroundImage)
        poemView.addSubview(todayTitle)
        poemView.addSubview(collectionView)
        
        poemView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleBackgroundImage.snp.makeConstraints {
            $0.width.equalTo(poemView.snp.width)
            $0.top.leading.trailing.equalTo(poemView)
        }
        
        todayTitle.snp.makeConstraints {
            $0.centerY.equalTo(titleBackgroundImage)
            $0.leading.trailing.equalTo(poemView)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleBackgroundImage.snp.bottom).inset(30)
            $0.leading.trailing.equalTo(poemView)
            $0.bottom.equalTo(poemView)
        }
        
        bind()
        setCollectionView()
        setTitle()
    }

    
    
    private func requestPoem() {
        viewModel.requestPoems(wordCount: 3)
    }
    
    private func updatePoem(poem : PoemModel) {
        viewModel.updatePoemInfo(poemId: poem.poemId!, wordCount: poem.wordCount!)
    }
    
    private func preloadNextAd() {
        if !adsToLoad.isEmpty {
          let ad = adsToLoad.removeFirst()
          let adRequest = GADRequest()
          adRequest.testDevices = [kGADSimulatorID as! String]
          ad.load(adRequest)
        }
    }
    
    func addBannerAds() {
            collectionView.layoutIfNeeded()
        
              let adSize = GADAdSizeFromCGSize(
                CGSize(width: collectionView.frame.width, height: collectionView.frame.height))
              let adView = GADBannerView(adSize: adSize)
              adView.adUnitID = adUnitID
              adView.rootViewController = self
              adView.delegate = self

              poemList.append(adView)
              adsToLoad.append(adView)
              loadStateForAds[adView] = false
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PoemCell.self, forCellWithReuseIdentifier: PoemCell.identifier)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
//        poemListOb.bind(to: collectionView.rx.items(cellIdentifier: PoemCell.identifier,cellType: PoemCell.self)) { index,poem,cell in
//            cell.configure(with: poem)
//        }.disposed(by: disposeBag)
//
    }
    
    // 삼행시 주제 설정
    private func setTitle() {
        navigationController?.title = "삼행시"
        
        viewModel.requestTodayTitle(wordCount: 3)
    }
}

extension PoemView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if poemList.count == 0 {
            collectionView.setEmptyView()
        } else {
            collectionView.backgroundView = nil
        }
        return poemList.count
    }
    
    // CollectionViewCell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
//        return cell
        
        if let BannerView = poemList[indexPath.row] as? GADBannerView {
          let reusableAdCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BannerCell.identifier,
            for: indexPath)
            
            for subview in reusableAdCell.contentView.subviews {
              subview.removeFromSuperview()
            }

            reusableAdCell.addSubview(BannerView)
            // Center GADBannerView in the table cell's content view.
            BannerView.snp.makeConstraints {
                $0.top.leading.equalTo(reusableAdCell).offset(20)
                $0.trailing.equalTo(reusableAdCell).inset(20)
                $0.height.equalTo(reusableAdCell.snp.height).dividedBy(2)
            }
            reusableAdCell.backgroundColor = .clear
            BannerView.backgroundColor = .clear

            return reusableAdCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoemCell.identifier, for: indexPath) as! PoemCell
            
            let list = poemList[indexPath.row] as? PoemModel
                //TODO: 여기에 cell Configuration 하기
            cell.configure(with: list!)
            
            cell.likeButton.rx.tap.bind { _ in
                self.selectedPoem = list
                self.viewModel.requestLikePoem(poemId: list!.poemId!, wordCount: list!.wordCount!)
            }.disposed(by: disposeBag)
            
            cell.shareButton.rx.tap.bind { _ in
                if !(self.poemList.isEmpty) {
                    let text = "\(list!.word![0].word!) : \(list!.word![0].line!) \n \(list!.word![1].word!) \(list!.word![1].line!) \n \(list!.word![2].word!) : \(list!.word![2].line!) "
                    
                    let textToShare = [ text ]

                    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)

                    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]

                    self.present(activityViewController, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
                
            cell.reportButton.rx.tap.bind { _ in
                if list!.reported! {
                    self.view.makeToast("이미 신고했어요.", duration : 2)
                } else {
                    self.selectedPoem = list!
                    self.viewModel.requestReportPoem(poemId: list!.poemId!, wordCount: list!.wordCount!)
                }
            }.disposed(by: disposeBag)
                
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    func adViewDidReceiveAd(_ adView: GADBannerView) {
       // Mark banner ad as succesfully loaded.
       loadStateForAds[adView] = true
       // Load the next ad in the adsToLoad list.
       preloadNextAd()
     }

     func adView(
       _ adView: GADBannerView,
       didFailToReceiveAdWithError error: GADRequestError
     ) {
       print("Failed to receive ad: \(error.localizedDescription)")
       // Load the next ad in the adsToLoad list.
       preloadNextAd()
     }
}

class PoemWordTab : UIView {
    
    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.backgroundColor = nil
        pageControl.pageIndicatorTintColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(5)
            $0.bottom.trailing.equalTo(self).inset(5)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
