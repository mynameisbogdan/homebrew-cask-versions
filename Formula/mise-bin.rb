class MiseBin < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  version "2026.6.10"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "bzip2"

  on_macos do
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-x64.tar.xz"
      sha256 "34603b875c42fb0b71e721dfd61d94a44059aa0e8b575f104e03b670ecbf12fd"
    end

    on_arm do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-arm64.tar.xz"
      sha256 "8a799390a1480a79b9f4361a8582c9b417f3f04607b3f06fdaee959ae2a9956d"
    end
  end

  conflicts_with "mise", because: "both install a 'mise' executable"

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/mise"
    man1.install Dir[libexec/"man/man1/mise.1"]
    lib.mkpath
    touch lib/".disable-self-update"
  end

  def caveats
    <<~EOS
      This formula installs a prebuilt macOS binary of mise.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise version")
  end
end
