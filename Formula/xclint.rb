class Xclint < Formula
  desc "Xcode project linting"
  homepage "https://github.com/mattmassicotte/XCLint"
  url "https://github.com/mattmassicotte/XCLint.git", branch: "main"
  head "https://github.com/mattmassicotte/XCLint", branch: "main"
  version "0.1.0"

  depends_on :xcode => ["15.0", :build]

  def install
    system "xcrun", "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclint"
  end
end
