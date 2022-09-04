//
//  ArticleViewController.swift
//  Laborator3
//
//  Created by user216460 on 9/1/22.
//

import UIKit
import WebKit
import CoreData

final class ArticleViewController: UIViewController{
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    
    @IBOutlet weak var startButton1: UIButton!
    @IBOutlet weak var startButton2: UIButton!
    @IBOutlet weak var startButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var startButton5: UIButton!
    var item: Item?
    var rating: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure(){
        guard let item = item else {
            return
        }

        //textView.text = item.body
        title = item.title //title de navigationViewController
        webView?.loadHTMLString(item.body, baseURL: nil)
        configureStart()
        
        //Schimbat mai tarziu
        /*ratingTextField.delegate = self
        ratingTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)*/
        
    }
    private func configureStart(){
        startButton1.tag = 1
        startButton2.tag = 2
        startButton3.tag = 3
        starButton4.tag = 4
        startButton5.tag = 5
    }
    
    @IBAction func didRateArticle(_ sender: UIButton) {
        rating = sender.tag
        addRating()
    }
    
    @objc
    private func textDidChange(){
        guard let ratingString = ratingTextField.text,
              let rating = Int(ratingString) else {return}
        self.rating = rating
        
        
        //print("here::",self.rating)
    }
    
    private func addRating(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "RatingEntity", in: managedContext),
        let item = item else {return}
        let ratingEntity = RatingEntity(entity: entity, insertInto: managedContext)
        
        ratingEntity.rating = Int64(rating)
        //ratingEntity.nume = item?.ItemName
        ratingEntity.body = item.body
        print("here::",item,rating)
        
        do{
            try managedContext.save()
    
            print("here::saved")
        }catch{
            print("here::",error.localizedDescription)
        }
    }
}
//Schimbat mai arziu
/*extension ArticleViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("here::",string)
        if Int(string) != nil {
            return true
        }
        return false
    }


}*/
