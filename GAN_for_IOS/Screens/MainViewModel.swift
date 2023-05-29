import Foundation
import CoreML
import CoreImage

final class MainViewModel {
    private var predictImage: CIImage?
    func analyzeImage(imageBuffer: CVImageBuffer) -> CIImage? {
        do {
            let config = MLModelConfiguration()
            let model = try model_coreml(configuration: config)
            let input = model_coremlInput(input_1: imageBuffer)
            let output = try model.prediction(input: input)
            predictImage = CIImage(cvPixelBuffer: output.var_385)
        } catch {
            print(error.localizedDescription)
        }
        return predictImage
    }
}
