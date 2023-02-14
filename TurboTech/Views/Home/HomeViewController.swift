//
//  HomeViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Network
import Kingfisher

class HomeViewController: UIViewController {
    
    var activityIndicatorView = UIActivityIndicatorView();

    @IBOutlet weak var imageSliderCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var homeMenyCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var homeMenuCollectionView: UICollectionView!
    
    @IBOutlet weak var menuView: UIView!
    
    private var menuList = [
        Menu(id: 0, title: "product".localized, imageUrl: "internet_package"),
        Menu(id: 1, title: "payment".localized, imageUrl: "get_cash"),
        Menu(id: 2, title: "help desk".localized, imageUrl: "ustomer_support"),
        Menu(id: 3, title: "speed test".localized, imageUrl: "speed"),
        Menu(id: 4, title: "scan qr".localized, imageUrl: "qr_black"),
        Menu(id: 5, title: "location".localized, imageUrl: "Map")
    ]
    //[Menu]()
    private lazy var homeViewModel = HomeViewModel()
    private var imageList = [HomeImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InternetConnection.shared.checkConnection(self){ status in
            print(status)
        }
        self.showActivityIndicatory(actInd: activityIndicatorView, uiView: self.view)
//        self.navigationItem.title = "turbotech".localized
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func fetchData(){
        let loginViewModel = LoginViewModel()
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "isLogin") && AppDelegate.user == nil {
                loginViewModel.fetchCurrentUser { (sucess) in
                    if sucess {
                        self.addRightButton()
                    }
                }
            }
            
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            
            self.homeViewModel.fetchSliderImage { (image) in
                self.imageList = image
                self.imageSliderCollectionView.reloadData()
            }
            
            self.removeActivityIndicatory(actId: self.activityIndicatorView, uiView: self.view)
        }
    }
    
    @objc func changeImage(){
        if imageNum < imageList.count {
            let index = IndexPath.init(item: imageNum, section: 0)
            self.imageSliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageController.currentPage = imageNum
            imageNum += 1
        } else {
            imageNum = 0
            let index = IndexPath.init(item: imageNum, section: 0)
            self.imageSliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageController.currentPage = imageNum
            imageNum = 1
        }
    }
    
    private var timer = Timer()
    private var imageNum = 0
    private let imageStr = ["1","2","3","4","5"]
    
    private func setUpNavigation(){
        let height: CGFloat = 0 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)

    }
    
    private func addRightButton(){
        
        let rNavView = UIView(frame: CGRect(x: 0, y: 0, width: 90,height: 40))
        
        let notificationBtn = UIButton(frame: CGRect(x: 0,y: 0, width: 40, height: 40))
        notificationBtn.setImage(UIImage(named: "bell.fill"), for: .normal)
        notificationBtn.tintColor = .white
        notificationBtn.contentVerticalAlignment = .fill
        notificationBtn.contentHorizontalAlignment = .fill
        notificationBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        notificationBtn.addTarget(self, action: #selector(self.didTapOnRightButton), for: .touchUpInside)
        
        let profileImageView = UIImageView(frame: CGRect(x: 50, y: 2, width: 36, height: 36))
        let image = UIImage(named: "user-circle")
        profileImageView.image = image
        if UserDefaults.standard.bool(forKey: "isLogin") && AppDelegate.user != nil {
            let url = URL(string: AppDelegate.user!.imageUrl)
            profileImageView.kf.setImage(with: url, placeholder: image)
        } else {
            profileImageView.image = image
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = SIZE.RADIOUS_IMAGE
        profileImageView.layer.masksToBounds = true
        rNavView.addSubview(profileImageView)
        rNavView.addSubview(notificationBtn)

        let rightBarButton = UIBarButtonItem(customView: rNavView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func addLeftButton(){
        let lNavVIew = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        titleLabel.textAlignment = .left
        titleLabel.text = "turbotech".localized
        titleLabel.font = UIFont.systemFont(ofSize: NAV.HOME_NAV_TITLE_SIZE, weight: .semibold)
        titleLabel.textColor = NAV.HOME_NAV_COLOR_WHITE
        lNavVIew.addSubview(titleLabel)
        let leftBarButton = UIBarButtonItem(customView: lNavVIew)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc
    func didTapOnRightButton(){
        if LanguageManager.shared.language == "km" {
            LanguageManager.shared.language = "en"
        }
        else {
            LanguageManager.shared.language = "km"
        }
        localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localized();
        fetchData()
        self.homeMenuCollectionView.reloadData()
    }
    
    func localized(){
        self.tabBarItem = UITabBarItem(title: "home".localized, image: UIImage(named: "house.fill"), selectedImage: UIImage(named: "house.fill"))
        registerCollectionViewCell()
        menuList = [
            Menu(id: 0, title: "product".localized, imageUrl: "product"),
            Menu(id: 1, title: "payment".localized, imageUrl: "payment"),
            Menu(id: 2, title: "help desk".localized, imageUrl: "help-desk"),
            Menu(id: 3, title: "speed test".localized, imageUrl: "speed-test"),
            Menu(id: 4, title: "scan qr".localized, imageUrl: "qr"),
            Menu(id: 5, title: "location".localized, imageUrl: "pin")
        ]
        homeMenuCollectionView.reloadData()
        addLeftButton()
        addRightButton()
        self.tabBarController?.tabBar.items![0].title = "home".localized
        self.tabBarController?.tabBar.items![1].title = "location".localized
        self.tabBarController?.tabBar.items![2].title = UserDefaults.standard.bool(forKey: "isLogin") ? "ticket".localized : "message".localized
        self.tabBarController?.tabBar.items![3].title = "profile".localized
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "home".localized, style: .plain, target: self, action: nil)
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == imageSliderCollectionView ? imageList.count : menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageSliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                let url = URL(string: LanguageManager.shared.language == "en" ? imageList[indexPath.row].imageEn : imageList[indexPath.row].imageKh)
                vc.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
            }
            return cell
        } else {
            let cell = homeMenuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCellID", for: indexPath) as! MenuCollectionViewCell
            cell.customCell(menu: menuList[indexPath.item])
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            return cell
        }
    }
    
    func registerCollectionViewCell()  {
        homeMenuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCellID")
        homeMenuCollectionView.delegate = self
        homeMenuCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
        imageSliderCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionView == imageSliderCollectionView ? 0.0 : 0.8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        collectionView == imageSliderCollectionView ? 0.0 : 0.4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageSliderCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            let itemPerRow : CGFloat = 2
            let itemPerColumn : CGFloat = 3
            let lineSpacing: CGFloat = 0.8
            let itemSpacing: CGFloat = 0.4
            let size = self.menuView.frame.size

            let width = (size.width - (itemPerRow * itemSpacing)) / itemPerRow
            let height = (size.height - (itemPerColumn * lineSpacing)) / itemPerColumn
            return CGSize(width: width, height: height)
        }
    }
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.homeMenuCollectionView)
        let indexPath = self.homeMenuCollectionView.indexPathForItem(at: location)
        if let index = indexPath {
            switch index.item {
            case 0:
                let productVC = storyboard?.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
                productVC.modalPresentationStyle = .fullScreen
                productVC.setNavigationTitle(title: "product".localized)
                productVC.setTypeId(id: 0)
                self.navigationController?.pushViewController(productVC, animated: true)
            case 1:
                print("Payment")
                let main = UIStoryboard(name: "Main", bundle: nil)
                let vc = main.instantiateViewController(withIdentifier: "ComingSoonViewControllerID") as! ComingSoonViewController
                vc.navigationItem.title = "Payment"
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let productVC = storyboard?.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
                productVC.modalPresentationStyle = .fullScreen
                productVC.setNavigationTitle(title: "help desk".localized)
                productVC.setTypeId(id: 2)
                self.navigationController?.pushViewController(productVC, animated: true)
            case 3:
                let speedTestVC = storyboard?.instantiateViewController(withIdentifier: "SpeedTestViewControllerID") as! SpeedTestViewController
                speedTestVC.navigationItem.title = "speed test".localized
                self.navigationController?.pushViewController(speedTestVC, animated: true)
            case 4:
                print("Scan QR")
                let main = UIStoryboard(name: "Main", bundle: nil)
                let vc = main.instantiateViewController(withIdentifier: "ComingSoonViewControllerID") as! ComingSoonViewController
                vc.navigationItem.title = "Scan QR"
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                let locationVC = storyboard?.instantiateViewController(withIdentifier: "UserLocationViewControllerID") as! UserLocationViewController
                locationVC.modalPresentationStyle = .fullScreen
                locationVC.navigationItem.title = "location".localized
                self.navigationController?.pushViewController(locationVC, animated: true)
                
            default:
                print("")
            }
        }
    } 
    
}
