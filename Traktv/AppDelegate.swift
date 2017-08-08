import UIKit
import Localize_Swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DataRepository.dependencyContainer.register(.singleton) { APIDataManager() as DataManagerType }
        Router.start(self)
        // Override point for customization after application launch.
        let url = URL(string:"testapp://auth?code=36d7ef1177951b3240decea122646f248c94cc3539bd8e7b248c3e3a62f8c74b")!
        if let query = url.query {
            let dictionary = query.components(separatedBy: "&")
                .map {
                    return $0.components(separatedBy: "=")

                }
                
                .reduce([:], { accumulator, tuple -> [String:String] in
                    
                return accumulator + [tuple.first ?? "" : tuple.last ?? ""]
            })
            print (dictionary)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let url = URL(string:"testapp://auth?code=36d7ef1177951b3240decea122646f248c94cc3539bd8e7b248c3e3a62f8c74b")!
        return true
    }

}

