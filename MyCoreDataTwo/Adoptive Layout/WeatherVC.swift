//
//  WeatherVC.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 19/03/25.
//

import UIKit

class WeatherVC: UIViewController {

    @IBOutlet weak var imgWeatherIcon: UIImageView!
    private let lblWeather = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Weather App"
        setupLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        sizeClassChange()
    }

    private func setupLayout() {
        
        lblWeather.text = "SUN"
        lblWeather.textAlignment = .center
        
        lblWeather.translatesAutoresizingMaskIntoConstraints = false
        imgWeatherIcon.addSubview(lblWeather)
        
        
        NSLayoutConstraint.activate([
            lblWeather.heightAnchor.constraint(equalToConstant: 30),
            lblWeather.leadingAnchor.constraint(equalTo: imgWeatherIcon.leadingAnchor, constant: 10),
            lblWeather.trailingAnchor.constraint(equalTo: imgWeatherIcon.trailingAnchor, constant: -10),
            lblWeather.centerYAnchor.constraint(equalTo: imgWeatherIcon.centerYAnchor)
        ])
        
        sizeClassChange()
    }
   
    private func sizeClassChange() {
        
        if traitCollection.verticalSizeClass == .compact {
            //then we are going to remove the weather label
            
            lblWeather.isHidden = true
            print("weather label removed")
            
        } else {
            
            lblWeather.isHidden = false
            print("weather label added")
        }
    }

}

    
class Users: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        true
    }
    
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        age = coder.decodeInteger(forKey: "age")
    }
    
}

func set() {
    let newUser = Users(name: "Gobi", age: 30)
    
    var userData: Data?
    do {
        userData = try NSKeyedArchiver.archivedData(withRootObject: newUser, requiringSecureCoding: true)
        print("nskey archive success")
    } catch {
        print("Err in nskey archive")
    }
    
    do {
        guard let userData = userData else {return}
        let result = try NSKeyedUnarchiver.unarchivedObject(ofClass: Users.self, from: userData)
        print("result", result)
    } catch {
        print("Err in nskey unarchive")
    }
}
