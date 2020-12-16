//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by Marek Repinski on 2020-12-15.
//

import UIKit

class TicTacToeViewController: UIViewController {
    var noOfPlayers = 0
    let blankImg = UIImage(named: "blank")
    let xImg = UIImage(named: "x")
    let oImg = UIImage(named: "o")
    @IBOutlet weak var img11: UIImageView!
    @IBOutlet weak var img12: UIImageView!
    @IBOutlet weak var img13: UIImageView!
    @IBOutlet weak var img21: UIImageView!
    @IBOutlet weak var img22: UIImageView!
    @IBOutlet weak var img23: UIImageView!
    @IBOutlet weak var img31: UIImageView!
    @IBOutlet weak var img32: UIImageView!
    @IBOutlet weak var img33: UIImageView!
    var cordMap = [[UIImageView]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cordMap = [[img11, img12, img13], [img21, img22, img23], [img31, img32, img33]]
        clearPlayField()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapp11(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img11.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 0)
        }
    }
    
    @IBAction func tapp12(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img12.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 1)
        }
    }
    
    @IBAction func tapp13(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img13.image!, isEqualTo: blankImg!) {
            imageTapped(y: 0, x: 2)
        }
    }
    
    @IBAction func tapp21(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img21.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 0)
        }
    }
    
    @IBAction func tapp22(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img22.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 1)
        }
    }
    
    @IBAction func tapp23(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img23.image!, isEqualTo: blankImg!) {
            imageTapped(y: 1, x: 2)
        }
    }
    
    @IBAction func tapp31(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img31.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 0)
        }
    }
    
    @IBAction func tapp32(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img32.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 1)
        }
    }
    
    @IBAction func tapp33(_ sender: UITapGestureRecognizer) {
        if imageCompare(image1: img33.image!, isEqualTo: blankImg!) {
            imageTapped(y: 2, x: 2)
        }
    }
    
    func imageCompare(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    func imageTapped(y: Int, x: Int){
        if (y + x) % 2 == 0 {
            cordMap[y][x].image = xImg
        } else {
            cordMap[y][x].image = oImg
        }
    }
    
    func clearPlayField(){
        for y in 0...2 {
            for x in 0...2 {
                cordMap[y][x].image = blankImg
            }
        }
    }
}
