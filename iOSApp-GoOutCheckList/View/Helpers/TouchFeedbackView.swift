import Foundation
import UIKit

class TouchFeedbackView: UIView {
    // タップ開始時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.touchStartAnimation()
    }

    // タップキャンセル時の処理
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.touchEndAnimation()
    }

    // タップ終了時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.touchEndAnimation()
    }

    // ビューを凹んだように見せるアニメーション
    private func touchStartAnimation() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
            // 少しだけビューを小さく縮めて、奥に行ったような「凹み」を演出する
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        },
                       completion: nil
        )
    }

    // 凹みを元に戻すアニメーション
    private func touchEndAnimation() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
            // 元の倍率に戻す
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        },
                       completion: nil
        )
    }
}
