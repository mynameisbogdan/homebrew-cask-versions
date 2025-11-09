cask "virtualbox-extension-pack6" do
  version "6.1.50"
  sha256 "07515348efb4f574007888afbf58bf60290530e52506ed8142b10e1745828e85"

  url "https://download.virtualbox.org/virtualbox/#{version}/Oracle_VM_VirtualBox_Extension_Pack-#{version}.vbox-extpack"
  name "Oracle VirtualBox Extension Pack"
  desc "Extend the functionality of VirtualBox"
  homepage "https://www.virtualbox.org/"

  livecheck do
    url "https://www.virtualbox.org/wiki/Download_Old_Builds_6_1"
    strategy :page_match do |page|
      match = page.match(/href=.*?Oracle_VM_VirtualBox_Extension_Pack-(\d+(?:\.\d+)+).vbox-extpack/)
      next if match.blank?

      "#{match[1]}"
    end
  end

  conflicts_with cask: [
    "virtualbox-extension-pack",
    "virtualbox-extension-pack-beta",
  ]
  container type: :naked

  stage_only true

  postflight do
    system_command "/usr/local/bin/VBoxManage",
                   args:  [
                     "extpack", "install",
                     "--replace", "#{staged_path}/Oracle_VM_VirtualBox_Extension_Pack-#{version}.vbox-extpack"
                   ],
                   input: "y",
                   sudo:  true
  end

  uninstall_postflight do
    next unless File.exist?("/usr/local/bin/VBoxManage")

    system_command "/usr/local/bin/VBoxManage",
                   args: [
                     "extpack", "uninstall",
                     "Oracle VM VirtualBox Extension Pack"
                   ],
                   sudo: true
  end

  caveats do
    license "https://www.virtualbox.org/wiki/VirtualBox_PUEL"
  end
end
