cask "dotnet-sdk6" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "6.0.424,c88c088d-fdf3-46f2-bacb-64ea20d20d65,b751a812209385384ec32a3d84124200"
    sha256 "e508a0f124b5c4cd7454621a60f35e716723f03686c9b85c4cfc7679ba0b5c16"
  end
  on_intel do
    version "6.0.424,0161ccc5-bb74-4d5f-b153-fb9ed1f31531,a3e393ab61522f4b8050cfd2692ad1d6"
    sha256 "5e37fe1747490b30adc90fd59dce2a00caf635a447a8fb2952a8ba0a3469f903"
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
