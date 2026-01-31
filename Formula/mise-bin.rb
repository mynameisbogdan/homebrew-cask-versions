class MiseBin < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  version "2026.1.11"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "bzip2"

  on_macos do
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-x64.tar.xz"
      sha256 "18f777b233ffbab02b7a7aa51d77a16973d101ca282003c4f0c93523d7d30966"
    end

    on_arm do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-arm64.tar.xz"
      sha256 "c9f7b39d135f6f7205a2c36f1c6af1eb2b6c587c305163fbee7dc1a863b98c49"
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
