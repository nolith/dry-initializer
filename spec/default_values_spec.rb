describe "default values" do
  before do
    class Test::Foo
      extend Dry::Initializer::Mixin

      param  :foo, default: proc { :FOO }
      param  :bar, default: proc { :BAR }
      option :baz, default: proc { :BAZ }
      option :qux, default: proc { foo }
      option :mox, default: proc { default_mox }

      private

      def default_mox
        :MOX
      end
    end
  end

  it "instantiate arguments" do
    subject = Test::Foo.new(1, 2, baz: 3, qux: 4)

    expect(subject.foo).to eql 1
    expect(subject.bar).to eql 2
    expect(subject.baz).to eql 3
    expect(subject.qux).to eql 4
  end

  it "applies default values" do
    subject = Test::Foo.new

    expect(subject.foo).to eql :FOO
    expect(subject.bar).to eql :BAR
    expect(subject.baz).to eql :BAZ
    expect(subject.qux).to eql :FOO
  end

  it "applies default values partially" do
    subject = Test::Foo.new 1, baz: 3

    expect(subject.foo).to eql 1
    expect(subject.bar).to eql :BAR
    expect(subject.baz).to eql 3
    expect(subject.qux).to eql 1
  end

  it "applies default values from private methods" do
    subject = Test::Foo.new
    expect(subject.mox).to eql :MOX
  end

  describe "when every param has a default and there are no options" do
    before do
      class Test::Bar
        extend Dry::Initializer::Mixin

        param  :foo, default: proc { :FOO }
        param  :bar, default: proc { :BAR }
      end
    end

    it "instantiate arguments" do
      subject = Test::Bar.new(1, 2)

      expect(subject.foo).to eql 1
      expect(subject.bar).to eql 2
    end

    it "applies default values" do
      subject = Test::Bar.new

      expect(subject.foo).to eql :FOO
      expect(subject.bar).to eql :BAR
    end

    it "instantiate arguments also if the last is an hash" do
      subject = Test::Bar.new(1, { baz: 2, qux: 3 }) #adding a {} will fix it

      expect(subject.foo).to eql 1
      expect(subject.bar).to eql({ baz: 2, qux: 3 })
    end
  end

  describe "when every param has a default and there are only optional options" do
    before do
      class Test::Bar
        extend Dry::Initializer::Mixin

        param  :foo, default: proc { :FOO }
        param  :bar, default: proc { :BAR }
        option :baz, optional: true
      end
    end

    it "instantiate arguments" do
      subject = Test::Bar.new(1, 2, baz: 3)

      expect(subject.foo).to eql 1
      expect(subject.bar).to eql 2
      expect(subject.baz).to eql 3
    end

    it "applies default values" do
      subject = Test::Bar.new

      expect(subject.foo).to eql :FOO
      expect(subject.bar).to eql :BAR
      expect(subject.baz).to eql Dry::Initializer::UNDEFINED
    end

    it "instantiate arguments also if the last is an hash" do
      subject = Test::Bar.new(1, { baz: 2, qux: 3 }) #adding a {} will fix it

      expect(subject.foo).to eql 1
      expect(subject.bar).to eql({ baz: 2, qux: 3 })
    end
  end
end
