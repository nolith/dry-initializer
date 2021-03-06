describe "missed default values" do
  subject do
    class Test::Foo
      extend Dry::Initializer::Mixin

      param :foo, default: proc { :FOO }
      param :bar
    end
  end

  it "raises SyntaxError" do
    expect { subject }.to raise_error SyntaxError, /bar/
  end
end
