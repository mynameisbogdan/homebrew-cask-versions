cask "dotnet-sdk8" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "8.0.407,d798274b-2bfe-48d7-8f0f-70b15a0198f0,b2d3de9536ce33aea258211b8ba55c20"
    sha256 "6cad4e5449a37df79cbd278e0ce2c6b380c3449a708c77d811ba9b1a4383ea0b"
  end
  on_intel do
    version "8.0.407,36cd1a79-ccbe-4e86-b2ea-d4b45aecae1d,baee9ad982dc7c8058ec825978bf2400"
    sha256 "b09e6c16650da962e98e761c6134c31a04ea92591a40a58ec6dc211edb464e49"
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
    "dotnet",
    "dotnet-sdk@preview",
    "dotnet@preview"
  ], formula: "dotnet"
  depends_on macos: ">= :mojave"

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
