class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://docs.astral.sh/uv/"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.6.6.tar.gz"
  sha256 "413512f0fb94e030c704c3c1317b456e6b0dbfd328574222a93d23ddc2591bda"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce17240bad84e5a3d1af3dddd83ff10ad3b807b5bfe620ab14fd18297adee3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "359cf1c73078114d55f80862247927aa4c71ff13c7a44a0a307a2a97275de0d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eeced421a6bbb1af1a55f7cd0dbcba0eb00b56b71f42d3f5d5db55fcf2b815d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3338299d7878c6a67a973b8489f689e4fa27391e8d6920cc521c20182dc1d161"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b3c64735bcdbb071b7cdc20f9b97cd78061fffb45883722f974044d56224ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28203b124273bfbeb0eec01451a27035923c31ccad5d11a7b4a13f7e29e4ad4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
