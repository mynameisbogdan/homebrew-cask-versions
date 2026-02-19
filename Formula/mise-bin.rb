class MiseBin < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  version "2026.2.17"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "bzip2"

  on_macos do
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-x64.tar.xz"
      sha256 "40ed1dc2ec84626be829e6778922a786805f4471e5867e2738b98885e0d6e08d"
    end

    on_arm do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-arm64.tar.xz"
      sha256 "5cf016df47c8e7c6d022a2b5a4d7bb3b6e1664fc2aaf9ab0ba58063aa8e24d43"
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
