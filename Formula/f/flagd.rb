class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.6",
      revision: "961f9a6e131d0025ef6b9385d9d0ceb37744b0b9"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  # The upstream repository contains tags like `core/v1.2.3`,
  # `flagd-proxy/v1.2.3`, etc. but we're only interested in the `flagd/v1.2.3`
  # tags. Upstream only appears to mark the `core/v1.2.3` releases as "latest"
  # and there isn't usually a notable gap between tag and release, so we check
  # the Git tags.
  livecheck do
    url :stable
    regex(%r{^flagd/v?(\d+(?:[.-]\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2ef065289a7ebfc4f1d3523b27eb6d604903a812a021a645e0a016bc1b1efd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83ab4ad19a692105576397fd06e24affde082b835d424af887ed86928a5a9f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0a83747ddea7d6aad83852e8863c3bf216353452f92d65c3c45ef436e5d1e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d2fb3928fee36d97715a56ba0165edd17ca6df0fa10cfd1e8416a4c36eb3ae"
    sha256 cellar: :any_skip_relocation, ventura:       "04aeafa0d137a8fe338ef7b73d84fc7d08644a3c2ef197dcbffda7ca8e91ff74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00de6562b9c30bb4c660b597a736b78e2c9f157ff2e92b0a2c1b545d3668db23"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", "completion")
  end

  test do
    port = free_port
    json_url = "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: application/json" \
      localhost:#{port}/schema.v1.Service/ResolveBoolean
    BASH

    pid = spawn bin/"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
