import AVFoundation

/// Service used to check authorization status of the capture device.
final class VideoPermissionService {
  enum Error: Swift.Error {
    case notAuthorizedToUseCamera
  }

    // MARK: - Authorization

    /// Checks authorization status of the capture device.
    @MainActor
    func checkPersmission(completion: @MainActor @escaping (Error?) -> Void) {
      switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized:
        completion(nil)
      case .notDetermined:
        askForPermissions(completion)
      default:
        completion(Error.notAuthorizedToUseCamera)
      }
    }

    /// Asks for permission to use video.
    @MainActor
    private func askForPermissions(_ completion: @MainActor @escaping (Error?) -> Void) {
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
