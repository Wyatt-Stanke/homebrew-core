class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.5.2.tgz"
  sha256 "6c7c9a0effca4df93ebd1e0a5c85b3a9b40bb46bf7f415e482441476a9925fd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90686492fc8fa5c049b78cb0087bd6a8a582bf395b188008f3b3e1c3e06dec6f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~JAVASCRIPT
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath/"bar"

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
