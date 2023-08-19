//
//  SingleMediaPicker.swift
//  
//
//  Created by Vasil Zarubanau on 20/08/2023.
//

import Foundation
import PhotosUI

public struct MediaPickerModel {
	public let id: String
	public let url: URL
}

@MainActor
public protocol MediaPickerProtocol {
  func pickImage(on viewController: UIViewController, animated: Bool) async -> MediaPickerModel?
  func pickVideo(on viewController: UIViewController, animated: Bool) async -> MediaPickerModel?
}

public final class SingleMediaPicker {

  private var pickerContinuation: CheckedContinuation<MediaPickerModel?, Never>?
	private let destinationDirectory: URL
	private let fileManager: FileManager

	public init(fileManager: FileManager, destinationDirectory: URL) {
		self.fileManager = fileManager
		self.destinationDirectory = destinationDirectory
	}

  public func pickImage(on viewController: UIViewController, animated: Bool) async -> MediaPickerModel? {
    await pick(on: viewController, filter: .images, animated: animated)
  }

  public func pickVideo(on viewController: UIViewController, animated: Bool) async -> MediaPickerModel? {
    await pick(on: viewController, filter: .videos, animated: animated)
  }
}

// MARK: private methods

private extension SingleMediaPicker {
  @MainActor
  func pick(on viewController: UIViewController, filter: PHPickerFilter, animated: Bool) async -> MediaPickerModel? {
    await withCheckedContinuation({ @MainActor [weak self] continuation in
      self?.pickerContinuation = continuation

      var configuration = PHPickerConfiguration(photoLibrary: .shared())
      configuration.preferredAssetRepresentationMode = .current
      configuration.selectionLimit = 1
      configuration.filter = filter

      let picker = PHPickerViewController(configuration: configuration)
      picker.delegate = self
      viewController.present(picker, animated: animated)
    })
  }

  func retrieveAsset(from result: PHPickerResult) async -> MediaPickerModel? {
		guard let id = result.assetIdentifier else { return nil }

		return try? await withCheckedThrowingContinuation({ continuation in
			_ = result.itemProvider.loadFileRepresentation(for: UTType.image) { [weak self] url, _, error in
				if let error {
					continuation.resume(throwing: error)
					return
				}
				guard let self, let url else {
					continuation.resume(returning: nil)
					return
				}

				do {
					let targetURL = self.destinationDirectory.appendingPathComponent(url.lastPathComponent)

					if self.fileManager.fileExists(atPath: targetURL.path) {
						try self.fileManager.removeItem(at: targetURL)
					}

					try self.fileManager.copyItem(at: url, to: targetURL)

					let model = MediaPickerModel(
						id: id,
						url: targetURL
					)
					continuation.resume(returning: model)
				} catch {
					continuation.resume(throwing: error)
				}
			}
		})
  }
}

// MARK: - PHPickerViewControllerDelegate

extension SingleMediaPicker: PHPickerViewControllerDelegate {
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		Task {
			func dismiss(with path: MediaPickerModel?) async {
				await MainActor.run {
					picker.dismiss(animated: true, completion: { [pickerContinuation] in
						pickerContinuation?.resume(returning: path)
					})
				}
			}

			guard let result = results.first, let assetModel = await retrieveAsset(from: result) else {
				await dismiss(with: nil)
				return
			}

			await dismiss(with: assetModel)
		}
  }
}
