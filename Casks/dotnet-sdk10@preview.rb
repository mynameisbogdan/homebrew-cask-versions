cask "dotnet-sdk10@preview" do
  arch arm: "arm64", intel: "x64"

  version "10.0.100-rc.2.25502.107"
  sha256 arm:   "cda7f488455749cfb33ede260d0a25715bd7b3588f67a3514107d76634e19c27",
         intel: "6e89ba33aa1bbaaaf3b108195e14e3ac317de9675788f3e58ab1c7b1a8c851b1"

  url "https://builds.dotnet.microsoft.com/dotnet/Sdk/#{version}/dotnet-sdk-#{version}-osx-#{arch}.pkg"
  name ".NET SDK 10"
  desc "Developer platform"
  homepage "https://dotnet.microsoft.com/en-us/"

  livecheck do
    url "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{version.major_minor}/releases.json"
    strategy :json do |json|
      json["releases"]&.map do |release|
        release.dig("sdk", "version")
      end
    end
  end

  conflicts_with cask: [
    "dotnet-runtime",
    "dotnet-runtime@preview",
    "dotnet-sdk",
    "dotnet-sdk@8",
    "dotnet-sdk@preview",
    "dotnet-sdk10",
  ]
  depends_on macos: ">= :ventura"

  pkg "dotnet-sdk-#{version.csv.first}-osx-#{arch}.pkg"
  # binary "/usr/local/share/dotnet/dotnet"

  uninstall pkgutil: [
    "com.microsoft.dotnet.*#{version.major_minor}*#{arch}",
    "com.microsoft.dotnet.sharedhost*#{arch}",
    "com.microsoft.netstandard.pack.targeting.*",
  ]

  zap pkgutil: "com.microsoft.dotnet.*",
      delete:  [
        "/etc/paths.d/dotnet",
        "/etc/paths.d/dotnet-cli-tools",
      ],
      trash:   [
        "~/.dotnet",
        "~/.nuget",
      ]
end
