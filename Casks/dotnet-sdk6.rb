cask "dotnet-sdk6" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "6.0.423,8a43cb29-3cfd-41e2-8c80-46ec7ae7192d,3e460e7f35b80aefb18b0d1a90849981"
    sha256 "e231893bdb90b948b35710abd1be71bb5b876a639dd79a9c2159ac7a226b1122"
  end
  on_intel do
    version "6.0.423,7985c7ce-12d1-4180-9e95-3cf81790e958,633824a3c4228754b45106040302a5b2"
    sha256 "19f0298720aa2504af2375f150015d98ed391548666253fdfafd3a90782aaaef"
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
