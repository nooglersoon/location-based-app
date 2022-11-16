import UIKit
class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = .white
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
        // Create Tab one
        let tabOne = VisualizationViewController()
        let tabOneBarItem = UITabBarItem(title: "Visualization", image: UIImage(systemName: "mappin.square.fill"), selectedImage: UIImage(systemName: "mappin.square.fill"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = GeocodingViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Geocoding", image: UIImage(systemName: "mappin.circle.fill"), selectedImage: UIImage(systemName: "mappin.circle.fill"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Create Tab three
        let tabThree = AnalysisViewController()
        let tabTwoBarItem3 = UITabBarItem(title: "Analysis", image: UIImage(systemName: "map.circle.fill"), selectedImage: UIImage(systemName: "map.circle.fill"))
        
        tabThree.tabBarItem = tabTwoBarItem3
        
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
