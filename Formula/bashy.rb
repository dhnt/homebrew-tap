class Bashy < Formula
  desc "Bashy userland and outpost service"
  homepage "https://dhnt.io"
  version "0.32.0"
  license all_of: ["BSD-3-Clause", "MIT"]
  on_macos do
    on_arm do
      url "https://github.com/qiangli/bashy/releases/download/v0.32.0/bashy-darwin-arm64.tar.gz"
      sha256 "c5f5ce324654050acc348260c0cc318e47933380f936486e8c6bfe53e3ce197d"
    end
    on_intel do
      url "https://github.com/qiangli/bashy/releases/download/v0.32.0/bashy-darwin-amd64.tar.gz"
      sha256 "94244df67d187e648ca319ef69574afc00d0dc29b457dea20cc3638e396d26b8"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/qiangli/bashy/releases/download/v0.32.0/bashy-linux-arm64.tar.gz"
      sha256 "e1f168a9d826e813beea0bee67042fb3aed6d5cc7ce50ebf72dbb11efa40e020"
    end
    on_intel do
      url "https://github.com/qiangli/bashy/releases/download/v0.32.0/bashy-linux-amd64.tar.gz"
      sha256 "523866fc651c09646ecbe96b793836d80c08308a3636a3b7328da3353ea78823"
    end
  end
  def install
    bin.install "bashy", "outpost"
    # bash and sh stay off PATH so they never shadow Homebrew bash or /bin/sh.
    libexec.install "bash", "sh"
  end
  service do
    run [opt_bin/"outpost", "supervisord"]
    keep_alive true
  end
  test do
    require "json"
    shell = shell_output("#{bin}/bashy --version 2>&1")[/bashy-(v?[0-9]+\.[0-9]+\.[0-9]+(?:-dev)?)/, 1]
    service = JSON.parse(shell_output("#{bin}/outpost version --json")).fetch("version")
    refute_nil shell
    assert_equal shell.delete_prefix("v").delete_suffix("-dev"), service.delete_prefix("v").delete_suffix("-dev")
  end
end
