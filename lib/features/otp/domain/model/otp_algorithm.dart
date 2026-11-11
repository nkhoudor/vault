/// The hash function a service uses to compute its codes.
enum OtpAlgorithm {
  sha1,
  sha256,
  sha512;

  /// The algorithm an otpauth link calls [name], ignoring case, or null when the app does not have it.
  static OtpAlgorithm? tryParse(String name) => values.asNameMap()[name.toLowerCase()];
}
