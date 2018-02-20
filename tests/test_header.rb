require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "fog/dnsimple"

ENV["FOG_MOCK"] ||= "true"

require_relative "helpers/mock_helper"

module TestModelHelpers

  # Generates a unique identifier with a random differentiator.
  # Useful when rapidly re-running tests, so we don"t have to wait
  # serveral minutes for deleted objects to disappear from the API
  # E.g. "fog-test-1234"
  def uniq_id(base_name = "fog-test")
    # random_differentiator
    suffix = rand(65_536).to_s(16).rjust(4, "0")
    [base_name, suffix].join("-")
  end

  def model_tests(collection, params = {}, mocks_implemented = true)
    @instance = collection.new(params)

    # flunk if Fog.mocking? && !mocks_implemented
    assert @instance.save, "Model#save"

    yield if block_given?

    # flunk if Fog.mocking? && !mocks_implemented
    assert @instance.destroy, "Model#destroy"
  end
end


module TestCollectionHelpers

  # Generates a unique identifier with a random differentiator.
  # Useful when rapidly re-running tests, so we don"t have to wait
  # serveral minutes for deleted objects to disappear from the API
  # E.g. "fog-test-1234"
  def uniq_id(base_name = "fog-test")
    # random_differentiator
    suffix = rand(65_536).to_s(16).rjust(4, "0")
    [base_name, suffix].join("-")
  end

  def collection_tests(collection, params = {}, mocks_implemented = true)
    # pending if Fog.mocking? && !mocks_implemented
    collection.new(params)

    # pending if Fog.mocking? && !mocks_implemented
    @instance = collection.create(params)

    # pending if Fog.mocking? && !mocks_implemented
    collection.all

    @identity = @instance.identity # if !Fog.mocking? || mocks_implemented

    # pending if Fog.mocking? && !mocks_implemented
    collection.get(@identity)

    # pending if Fog.mocking? && !mocks_implemented
    methods = %w(all? any? find detect collect map find_index flat_map
               collect_concat group_by none? one?)

    methods.each do |enum_method|
      next unless collection.respond_to?(enum_method)
      block_called = false
      collection.send(enum_method) { block_called = true }
      assert block_called, "Collection##{enum_method}"
    end

    %w(max_by min_by).each do |enum_method|
      next unless collection.respond_to?(enum_method)
      block_called = false
      collection.send(enum_method) do
        block_called = true
        0
      end
      assert block_called, "Collection##{enum_method}"
    end

    yield if block_given?

    @instance.destroy # if !Fog.mocking? || mocks_implemented

    # pending if Fog.mocking? && !mocks_implemented
    assert_nil collection.get(@identity)
  end

end