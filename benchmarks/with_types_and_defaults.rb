Bundler.require(:benchmarks)

class PlainRubyTest
  attr_reader :foo, :bar

  def initialize(foo: "FOO", bar: "BAR")
    @foo = foo
    @bar = bar
    fail TypeError unless String === @foo
    fail TypeError unless String === @bar
  end
end

require "dry-initializer"
require "dry/initializer/types"
class DryTest
  extend Dry::Initializer::Mixin
  extend Dry::Initializer::Types

  option :foo, type: String, default: proc { "FOO" }
  option :bar, type: String, default: proc { "BAR" }
end

require "virtus"
class VirtusTest
  include Virtus.model

  attribute :foo, String, default: "FOO"
  attribute :bar, String, default: "BAR"
end

puts "Benchmark for instantiation with type constraints and default values"

Benchmark.ips do |x|
  x.config time: 15, warmup: 10

  x.report("plain Ruby") do
    PlainRubyTest.new
  end

  x.report("dry-initializer") do
    DryTest.new
  end

  x.report("virtus") do
    VirtusTest.new
  end

  x.compare!
end
