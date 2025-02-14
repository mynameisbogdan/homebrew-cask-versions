cask "dotnet-sdk8" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "8.0.406,b54de232-c38f-40ba-8ae7-51080435c258,5482d86b044fc3ec602685acde2993f8"
    sha256 "ba24b1867f8ec375cb0c125acbc1343938ee59efc243c6d96aa726a5cf23d1cf"
  end
  on_intel do
    version "8.0.406,d300f28c-e59b-43ec-bb57-b6e0320a86b2,a1f346317df06c5d8b8bf9785c9090e9"
    sha256 "57dd68791875751aabe65d4c8612b29597ab2c218a7d85c4aa4dd4da7f7bf06d"
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
