class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1009.0.tgz"
  sha256 "4f270420b28da52e5fec8b9d731f2d2c7e6c3347330520839759221618a2efc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2b32773daa62fb40be7db8ab1be2bf5a0a4b04ee77eb79ee6708ede863039ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
