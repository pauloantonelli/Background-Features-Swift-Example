//
//  AppDelegate.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 13/10/22.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .long
        return format
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BGTaskScheduler.shared.register(forTaskWithIdentifier: AppConstant.backgroundTaskIdentifier, using: nil) { task in
            self.fetchData()
            task.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
        }
        self.scheduleAppRefresh()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func scheduleAppRefresh() -> Void {
        let request = BGAppRefreshTaskRequest(identifier: AppConstant.backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("background refresh scheduled")
        } catch {
            print("Couldn't schedule app refresh \(error.localizedDescription)")
        }
    }
    
    func fetchData() -> Void {
        // to simulate a refresh, just update the last refresh date
        // to current date/time
        let formatedDate: String = self.dateFormatter.string(from: Date())
        UserDefaults.standard.set(formatedDate, forKey: UserDefaultsKeys.lastRefreshDateKey)
        print("refresh occurred \(formatedDate)")
    }
}
