import UIKit
import SnapKit
import DesignPackage

final class ConfirmedPaymentVC: UIViewController {

    private let mainView = ConfirmedPaymentView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        mainView.continueButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        // Добавляем жест на pdfView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(downloadPDF))
        mainView.pdfView.addGestureRecognizer(tapGesture)
        mainView.pdfView.isUserInteractionEnabled = true
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func downloadPDF() {
        // Создаем моковый PDF файл
        let pdfData = createMockPDF()
        
        // Сохраняем в Documents
        let fileName = "order_invoice.pdf"
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
            do {
                try pdfData.write(to: url)
                showAlert("Файл скачан", "PDF сохранен в \(url.path)")
            } catch {
                showAlert("Ошибка", "Не удалось сохранить PDF")
            }
        }
    }
    
    private func createMockPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Mock PDF",
            kCGPDFContextAuthor: "ConfirmedPaymentVC"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 300, height: 400)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let text = "This is a mock invoice PDF"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            text.draw(at: CGPoint(x: 20, y: 20), withAttributes: attributes)
        }
        
        return data
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        okAction.setValue(UIColor.mainTitlesDark, forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}
