cask "dotnet-sdk6" do
  arch arm: "arm64", intel: "x64"

  on_intel do
    version "6.0.415,df136a69-ab21-4938-ae40-785862f52445,e220acaad09b018a0b0b622710694367"
    sha256 "1720b5ae2467c3f17266afac25b161ee30e27287307263a98b91defaffd8c7c1"
  end
  on_arm do
    version "6.0.415,db68b8a6-fd16-4a90-ad4c-9f349335785a,ad03eae1b78be886c0f15a49cc54d999"
    sha256 "a88174fd5b75499d97ec792f10baf7c3681fec6effde16635f493ebbf0899e25"
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
    "dotnet",
    "dotnet-sdk",
    "homebrew/cask-versions/dotnet-preview",
    "homebrew/cask-versions/dotnet-sdk-preview",
  ], formula: "dotnet"
  depends_on macos: ">= :mojave"

  pkg "dotnet-sdk-#{version.csv.first}-osx-#{arch}.pkg"
  binary "/usr/local/share/dotnet/dotnet"

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
