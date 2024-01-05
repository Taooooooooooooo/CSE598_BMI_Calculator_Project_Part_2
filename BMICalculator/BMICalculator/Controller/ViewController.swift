//
//  ViewController.swift
//  BMICalculator
//
//Created by Tao Chen on 11/18/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!

    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var riskLabel: UILabel!

    var links = [String]()

    // Additional links array
    var moreLinks = [
        "https://www.cdc.gov/healthyweight/assessing/bmi/index.html",
        "https://www.nhlbi.nih.gov/health/educational/lose_wt/index.htm",
        "https://www.ucsfhealth.org/education/body_mass_index_tool/"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        mainView.addGestureRecognizer(tap)

        self.heightTextField.delegate = self
        self.weightTextField.delegate = self
    }

    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func calculateBMI(_ sender: UIButton) {
        self.view.endEditing(true)

        guard let heightText = heightTextField.text, let weightText = weightTextField.text,
            let height = Float(heightText), let weight = Float(weightText) else {
                // Handle invalid height or weight input
                print("Error: Please enter valid height and weight.")
                return
        }

        // Calculate BMI
        let bmi = weight / pow(height / 100, 2)

        // Handle BMI logic, e.g., determine BMI range, set UI, etc.
        let bmiRes = String(format: "%.1f", bmi)
        let risk = getRiskCategory(bmi: bmi)

        // Store links
        self.links = moreLinks

        DispatchQueue.main.async {
            self.bmiLabel.text = bmiRes
            self.riskLabel.text = risk
            self.riskLabel.textColor = self.getColor(bmi: bmi)
        }
    }

    func getRiskCategory(bmi: Float) -> String {
        // Determine risk category based on BMI value
        if bmi < 18.5 {
            return "Underweight"
        } else if bmi < 25 {
            return "Normal weight"
        } else if bmi < 30 {
            return "Overweight"
        } else {
            return "Obese"
        }
    }

    func getColor(bmi: Float) -> UIColor {
        // Determine color based on BMI value
        if bmi < 18.5 {
            return UIColor.blue
        } else if bmi < 25 {
            return UIColor.green
        } else if bmi < 30 {
            return UIColor.purple
        } else {
            return UIColor.red
        }
    }

    @IBAction func educate(_ sender: UIButton) {
        self.view.endEditing(true)

        if self.links.count > 0 {
            let numLinks = self.links.count
            guard let url = URL(string: self.links[Int.random(in: 0..<numLinks)]) else { return }
            UIApplication.shared.open(url)
        } else {
            self.riskLabel.text = "Calculate BMI first"
            self.riskLabel.textColor = UIColor.yellow
        }
    }
}

