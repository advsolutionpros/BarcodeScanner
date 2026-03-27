import AVFoundation

/// Service used to check authorization status of the capture device.
final class VideoPermissionService {
  enum Error: Swift.Error {
    case notAuthorizedToUseCamera
  }

  // MARK: - Authorization

  /// Checks authorization status of the capture device.
  func checkPersmission(completion: @escaping @MainActor (Error?) -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      Task { @MainActor in
        completion(nil)
      }
    case .notDetermined:
      askForPermissions(completion)
    default:
      Task { @MainActor in
        completion(Error.notAuthorizedToUseCamera)
      }
    }
  }

  /// Asks for permission to use video.
  private func askForPermissions(_ completion: @escaping @MainActor (Error?) -> Void) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      Task { @MainActor in
        guard granted else {
          completion(Error.notAuthorizedToUseCamera)
          return
        }
        completion(nil)
      }
    }
  }
}

