import Foundation
import FloatingPanel

/*
 カテゴリの登録の際に出現するセミモーダルのレイアウトファイル。
 FloatingPanelのレイアウトで、4/3と1/2の２種類のセミモーダルを実装している。
 */
class RegisterCategoryDetailFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
    ]

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full, .half: return 0.3
        default: return 0.0
        }
    }
}

class RegisterCheckElementFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
    ]

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full, .half: return 0.3
        default: return 0.0
        }
    }
}
