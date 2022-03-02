//
//  HipsterPickDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import UIKit

class HipsterPickDetailViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: HipsterPickDetailViewModel) {
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        
    }
    
}
