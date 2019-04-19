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
    
//    var startPoint: CGPoint = .zero
//    var endPoint: CGPoint = .zero
    
    var currentMove: ChipMove?
    
    var panGestureActiveChip: ChipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidLayoutSubviews() {
        game.new()
        buildGameField()
    }
    
    private func buildGameField() {
        
        currentMove = nil
        panGestureActiveChip = nil
        
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
        
        // multiple chips view touching prevention
        if panGestureActiveChip != nil, panGestureActiveChip != chipView {
            return
        }
        
        panGestureActiveChip = chipView
        
        if recognizer.state == .began {
            
            currentMove = game.chipsMove(from: chipView.chipModel.placeInMatrix)
            currentMove?.chipWidth = CGFloat(chipWidth)
            
            currentMove?.setViewsToMove(allViews: chipViews)
            
            currentMove?.setMovePoints(with: chipView)
            
            if currentMove?.moveDirection ?? .none == AvailableMoveDirection.none {
                panGestureActiveChip = nil
                currentMove = nil
                return
            }
            
        } else if recognizer.state == .ended {
            
            guard var move = currentMove
                else {
                    panGestureActiveChip = nil
                    currentMove = nil
                    return
            }
            
            move.endMove()
            
            if move.finalPoint == move.endPoint {
                game.moveChipToZero(move)
            }
            
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            switch move.moveDirection {
                            case .up:
                                for (viewIndex, view) in (move.chipViews).enumerated() {
                                    view.center = CGPoint(x: move.finalPoint.x,
                                                          y: move.finalPoint.y - CGFloat(self.chipWidth*viewIndex))
                                }
                            case .down:
                                for (viewIndex, view) in (move.chipViews).enumerated() {
                                    view.center = CGPoint(x: move.finalPoint.x,
                                                          y: move.finalPoint.y + CGFloat(self.chipWidth*viewIndex))
                                }
                            case .right:
                                for (viewIndex, view) in (move.chipViews).enumerated() {
                                    view.center = CGPoint(x: move.finalPoint.x + CGFloat(self.chipWidth*viewIndex),
                                                          y: move.finalPoint.y)
                                }
                            case .left:
                                for (viewIndex, view) in (move.chipViews).enumerated() {
                                    view.center = CGPoint(x: move.finalPoint.x - CGFloat(self.chipWidth*viewIndex),
                                                          y: move.finalPoint.y)
                                }
                            default:
                                break
                            }
                            
            },
                           completion: { _ in
                            self.currentMove = nil
                            self.panGestureActiveChip = nil
                            
            })
            
            
            if game.isDone {
                let alert = UIAlertController(title: "You are win!", message: "Congratulations!", preferredStyle: .alert)
                let okeyButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okeyButton)
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        let translation = recognizer.translation(in: self.view)
        
        guard let _ = currentMove?.chipViews else {
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            self.currentMove = nil
            self.panGestureActiveChip = nil
            return
        }
        
        currentMove?.move(with: translation)
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
}

