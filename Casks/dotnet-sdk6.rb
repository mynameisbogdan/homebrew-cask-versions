cask "dotnet-sdk6" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "6.0.425,4bb697a0-9509-4a48-aace-adf5cdd9dae5,db8114ff1a9117627a19ef3b5e709a05"
    sha256 "50a127ab788626387236d0a7c8ff9ad208ce506f33409a3877812cf0504d6a9b"
  end
  on_intel do
    version "6.0.425,8010eb35-b580-4fe3-84a1-323aef5d6947,cd513767c7ece93a71c69703169dd1c5"
    sha256 "7994b86068fdc02666947697e0e396232f154832e777940853c3c1baebb80ec3"
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
