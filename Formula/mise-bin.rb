class MiseBin < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  version "2026.9.15"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "bzip2"

  on_macos do
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-x64.tar.xz"
      sha256 "cf593b6f65e4693749f8f7681b9e6e4c94d23fabac36881f7629af6675e2bc49"
    end

    on_arm do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-arm64.tar.xz"
      sha256 "66754cc2241baf22df9ce65e8dbc89cdb7c1f17ddbec653637f3c5dc1aea0ace"
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
