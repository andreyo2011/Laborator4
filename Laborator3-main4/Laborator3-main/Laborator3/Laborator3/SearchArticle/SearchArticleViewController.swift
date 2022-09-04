//
//  SearchArticleViewController.swift
//  Laborator3
//
//  Created by user216460 on 9/4/22.
//

import UIKit

final class SearchArticleViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var model: [RatingEntity] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        //getAllModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllModels()
    }
    
    private func configure(){
        searchTextField?.addTarget(self, action: #selector(textFieldDdidChange), for: .editingChanged)
        //searchTextField?.delegate = self
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(SearchArticleTableViewCell.self, forCellReuseIdentifier: SearchArticleTableViewCell.cellId)
        
    }
    
    @objc
    private func textFieldDdidChange(){
        let searchString = searchTextField?.text ?? String()
        getAllModels(searchString: searchString)
        
    }
    
    private func navigate(item: Item){
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController")
        as? ArticleViewController else {return}
        viewController.item = item //inlocuiteste cele 2 de jos in urma modificarilor ArticleViewController
        //viewController.textView?.text = item.body
        //viewController.title = item.title
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func getAllModels(searchString: String = String()){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = RatingEntity.fetchRequest()
        //fetchRequest.predicate() sortari,filtrari etc
        if !searchString.isEmpty{
            fetchRequest.predicate = NSPredicate(format: "body CONTAINS %@", searchString)
        }
        do{
            model = try managedContext.fetch(fetchRequest)/*.filter{ entity in
                return entity.body?.contains(searchString) ?? false
                
                
            }*/
            
        }catch{
            print("here::",error.localizedDescription)
            
        }
        
    }
}


extension SearchArticleViewController: UITextFieldDelegate{
    
}

extension SearchArticleViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchArticleTableViewCell.cellId, for: indexPath)
                as? SearchArticleTableViewCell else { return UITableViewCell() }
        let cellModel = model[indexPath.row]
        cell.setup(ratingEntity: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = model[indexPath.row]
        let item = Item(title: model.name ?? String(),
                        date: "",
                        body: model.body ?? String()
                        )
        navigate(item: item)
        
    }
    
}
