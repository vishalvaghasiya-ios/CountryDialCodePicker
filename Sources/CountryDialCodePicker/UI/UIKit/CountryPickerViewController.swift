import UIKit
import SwiftUI

public final class CountryPickerViewController: UIViewController {
    public weak var delegate: CountryPickerDelegate?

    private let config: CountryPickerConfig
    private var onSelectClosure: ((CountrySelection) -> Void)?
    private var onCancelClosure: (() -> Void)?

    public init(
        config: CountryPickerConfig = .init(),
        onSelect: ((CountrySelection) -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.config = config
        self.onSelectClosure = onSelect
        self.onCancelClosure = onCancel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let picker = CountryPicker.view(config: config, onSelect: { [weak self] selection in
            self?.delegate?.countryPicker(didSelect: selection)
            self?.onSelectClosure?(selection)
        }, onCancel: { [weak self] in
            self?.delegate?.countryPickerDidCancel()
            self?.onCancelClosure?()
        })

        let host = UIHostingController(rootView: picker)
        addChild(host)
        view.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
    }
}
