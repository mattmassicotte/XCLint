class Xclint < Formula
  desc "Xcode project linting"
  homepage "https://github.com/mattmassicotte/XCLint"
  url "https://github.com/mattmassicotte/XCLint.git", branch: "main"
  head "https://github.com/mattmassicotte/XCLint", branch: "main"
  version "0.1.0"

  depends_on :xcode => ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    system "install", "-d", "#{prefix}/bin"
    system "install", ".build/release/xclint", "#{prefix}/bin"
  end
end
