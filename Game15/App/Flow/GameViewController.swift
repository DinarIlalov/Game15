//
//  ViewController.swift
//  Game15
//
//  Created by Dinar Ilalov on 10/04/2019.
//  Copyright © 2019 Dinar Ilalov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameFieldView: BoxView!
    private var chipViews: [ChipView] = []
    
    private var game = Game()
    
    private let fieldBorderWidth: Int = 8
    private var fieldWidth: CGFloat = 0
    private var chipWidth: Int = 0
    
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidLayoutSubviews() {
        game.new()
        buildGameField()
    }
    
    private func buildGameField() {
        
        chipViews.forEach { $0.removeFromSuperview() }
        chipViews.removeAll()
        
        fieldWidth = gameFieldView.bounds.width - 2*CGFloat(fieldBorderWidth)
        
        chipWidth = Int(fieldWidth/CGFloat(Game.gameGridCount))
        
        for chip in game.chips {
            
            if chip.number == 0 {
                continue
            }
            let chipView = ChipView(frame: CGRect(x: chip.placeInMatrix.columnIndex*chipWidth + fieldBorderWidth,
                                                  y: chip.placeInMatrix.rowIndex*chipWidth + fieldBorderWidth,
                                                  width: chipWidth-1,
                                                  height: chipWidth-1))
            
            chipView.chipModel = chip
                
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleChipPan(recognizer:)))
            chipView.addGestureRecognizer(panGestureRecognizer)
            
            self.gameFieldView.addSubview(chipView)
            
            chipViews.append(chipView)
            
        }
    }
    
    // MARK: - Actions
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        game.new()
        buildGameField()
    }
    
    @objc func handleChipPan(recognizer: UIPanGestureRecognizer) {
        guard let chipView = recognizer.view as? ChipView else { return }
        
        let availableMoveDirection = game.canMoveChip(chipView.chipModel)
        
        if availableMoveDirection == .none {
            return
        }
        
        if recognizer.state == .began {
            startPoint = chipView.center
            switch availableMoveDirection {
            case .down:
                endPoint = CGPoint(x: startPoint.x, y: startPoint.y + CGFloat(chipWidth))
            case .up:
                endPoint = CGPoint(x: startPoint.x, y: startPoint.y - CGFloat(chipWidth))
            case .right:
                endPoint = CGPoint(x: startPoint.x + CGFloat(chipWidth), y: startPoint.y)
            case .left:
                endPoint = CGPoint(x: startPoint.x - CGFloat(chipWidth), y: startPoint.y)
            default:
                return
            }
        }
        
        let translation = recognizer.translation(in: self.view)
        
        if availableMoveDirection == .down {
            if chipView.center.y + translation.y > endPoint.y {
                chipView.center = endPoint
            } else if chipView.center.y + translation.y < startPoint.y {
                chipView.center = startPoint
            } else {
                chipView.center = CGPoint(x: chipView.center.x,
                                          y: chipView.center.y + translation.y)
            }
        } else if availableMoveDirection == .up {
            if chipView.center.y - translation.y < endPoint.y {
                chipView.center = endPoint
            } else if chipView.center.y + translation.y > startPoint.y {
                chipView.center = startPoint
            } else {
                chipView.center = CGPoint(x: chipView.center.x,
                                          y: chipView.center.y + translation.y)
            }
        } else if availableMoveDirection == .right {
            if chipView.center.x + translation.x > endPoint.x {
                chipView.center = endPoint
            } else if chipView.center.x + translation.x < startPoint.x {
                chipView.center = startPoint
            } else {
                chipView.center = CGPoint(x: chipView.center.x + translation.x,
                                          y: chipView.center.y)
            }
        } else if availableMoveDirection == .left {
            if chipView.center.x - translation.x < endPoint.x {
                chipView.center = endPoint
            } else if chipView.center.x + translation.x > startPoint.x {
                chipView.center = startPoint
            } else {
                chipView.center = CGPoint(x: chipView.center.x + translation.x,
                                          y: chipView.center.y)
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            
            var finalPoint: CGPoint
            switch availableMoveDirection {
            case .down:
                if chipView.center.y > endPoint.y - CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
                
            case .up:
                if chipView.center.y < endPoint.y + CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
            case .right:
                if chipView.center.x > endPoint.x - CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
            case .left:
                if chipView.center.x < endPoint.x + CGFloat(chipWidth)/2 {
                    finalPoint = endPoint
                } else {
                    finalPoint = startPoint
                }
            default:
                return
            }

            if finalPoint == endPoint {
                game.moveChipToZero(chipView.chipModel)
            }
            
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: { chipView.center = finalPoint },
                           completion: nil)

            if game.isDone {
                let alert = UIAlertController(title: "You are win!", message: "Congratulations!", preferredStyle: .alert)
                let okeyButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okeyButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            startPoint = .zero
            endPoint = .zero
        }
    }
}

