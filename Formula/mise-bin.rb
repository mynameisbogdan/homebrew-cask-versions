class MiseBin < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  version "2026.8.10"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "bzip2"

  on_macos do
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-x64.tar.xz"
      sha256 "cda2095e2e71a2f046c2c6628d7e21e08a79933aa1a04fd3114e9284b72db423"
    end

    on_arm do
      url "https://github.com/jdx/mise/releases/download/v#{version}/mise-v#{version}-macos-arm64.tar.xz"
      sha256 "a8190378f6c0b394c54068405260282dcff2af14a153b327198cf4c44364e1b1"
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
