class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d065de300a1764077c31900e24e4843d5706eb397d787db0b3312d64c94f15a9"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  depends_on "go@1.18" => :build # quic-go cannot be built with go 1.19
  depends_on "make" => :build

  def install
    system "make", "build"
    bin.install "ipget"
  end

  test do
    system "#{bin}/ipget", "--version"
    # IPFS-provided example CID
    system "#{bin}/ipget", "ipfs://bafybeihkoviema7g3gxyt6la7vd5ho32ictqbilu3wnlo3rs7ewhnp7lly/"
  end
end
