cask "dotnet-sdk6" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "6.0.428,a718526a-7a96-438a-a1d2-341a586e6d9d,5a37e4c29489b6359ce1f857094f40d5"
    sha256 "a613c068212533d6b034cd614daf63633abcfe6697bc016d76a4ece1ce577c7f"
  end
  on_intel do
    version "6.0.428,303066f8-6fab-444d-95d2-9b37e3dc7460,17e0b71dc4120eee44e86e595d29f73d"
    sha256 "17bd1338041f37b242379b78a92ed9a9529c79894f13e47ae1ecf890a339d3b2"
  end

  url "https://download.visualstudio.microsoft.com/download/pr/#{version.csv.second}/#{version.csv.third}/dotnet-sdk-#{version.csv.first}-osx-#{arch}.pkg"
  name ".NET SDK"
  desc "Developer platform"
  homepage "https://www.microsoft.com/net/core#macos"

  # This identifies releases with the same major/minor version as the current
  # cask version. New major/minor releases occur annually in November and the
  # check will automatically update its behavior when the cask is updated.
  livecheck do
    url "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/#{version.major_minor}/releases.json"
    regex(%r{/download/pr/([^/]+)/([^/]+)/dotnet-sdk-v?(\d+(?:\.\d+)+)-osx-#{arch}\.pkg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[2]},#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: [
    "dotnet-sdk",
    "dotnet-runtime",
    "dotnet-sdk@preview",
    "dotnet-runtime@preview"
  ]

  pkg "dotnet-sdk-#{version.csv.first}-osx-#{arch}.pkg"
  # binary "/usr/local/share/dotnet/dotnet"

  uninstall pkgutil: [
              "com.microsoft.dotnet.*",
              "com.microsoft.netstandard.pack.targeting.*",
            ],
            delete:  [
              "/etc/paths.d/dotnet",
              "/etc/paths.d/dotnet-cli-tools",
            ]

  zap trash: [
    "~/.dotnet",
    "~/.nuget",
  ]
end
