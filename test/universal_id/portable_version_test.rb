# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::PortableVersionTest < ActiveSupport::TestCase
  def test_empty
    version = UniversalID::PortableVersion.new("")
    assert_equal "default@", version.to_s
    assert_equal "default@", version.id
  end

  def test_empty_gid
    param = UniversalID::PortableVersion.new("").to_gid_param
    assert_equal "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi9kZWZhdWx0JTQw", param
    assert_equal "default@", GlobalID.parse(param).find.id
  end

  def test_empty_sgid
    param = UniversalID::PortableVersion.new("").to_sgid_param
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSI-Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi9kZWZhdWx0JTQwBjsAVEkiDHB1cnBvc2UGOwBUSSIMZGVmYXVsdAY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--2f6f32f7645006719b210f191398db8a70ca010d", param
    assert_equal "default@", SignedGlobalID.parse(param).find.id
  end

  def test_invalid
    version = UniversalID::PortableVersion.new("invalid version string")
    assert_equal "default@0", version.to_s
    assert_equal "default@0", version.id
  end

  def test_invalid_gid
    param = UniversalID::PortableVersion.new("invalid version string").to_gid_param
    assert_equal "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi9kZWZhdWx0JTQwMA", param
    assert_equal "default@0", GlobalID.parse(param).find.id
  end

  def test_invalid_sgid
    param = UniversalID::PortableVersion.new("invalid version string").to_sgid_param
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSI_Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi9kZWZhdWx0JTQwMAY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--6cca5da57d0d3f8a881879208b8b689a3b935630", param
    assert_equal "default@0", SignedGlobalID.parse(param).find.id
  end

  def test_default
    version = UniversalID::PortableVersion.new("1.0.0")
    assert_equal "default@1.0.0", version.to_s
    assert_equal "default@1.0.0", version.id
  end

  def test_default_gid
    param = UniversalID::PortableVersion.new("1.0.0").to_gid_param
    assert_equal "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi9kZWZhdWx0JTQwMS4wLjA", param
    assert_equal "default@1.0.0", GlobalID.parse(param).find.id
  end

  def test_default_sgid
    param = UniversalID::PortableVersion.new("1.0.0").to_sgid_param
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSJDZ2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi9kZWZhdWx0JTQwMS4wLjAGOwBUSSIMcHVycG9zZQY7AFRJIgxkZWZhdWx0BjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--3433d659f309a8417cead74f5d40c408aa6dc8b3", param
    assert_equal "default@1.0.0", SignedGlobalID.parse(param).find.id
  end

  def test_scope
    version = UniversalID::PortableVersion.new("1.0.0", scope: "Test Example")
    assert_equal "test-example@1.0.0", version.to_s
    assert_equal "test-example@1.0.0", version.id
  end

  def test_scope_gid
    param = UniversalID::PortableVersion.new("1.0.0", scope: "Test Example").to_gid_param
    assert_equal "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi90ZXN0LWV4YW1wbGUlNDAxLjAuMA", param
    assert_equal "test-example@1.0.0", GlobalID.parse(param).find.id
  end

  def test_scope_sgid
    param = UniversalID::PortableVersion.new("1.0.0", scope: "Test Example").to_sgid_param
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSJIZ2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlVmVyc2lvbi90ZXN0LWV4YW1wbGUlNDAxLjAuMAY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--606a1e68b605a3da0a449c80ad39403b1646ac2b", param
    assert_equal "test-example@1.0.0", SignedGlobalID.parse(param).find.id
  end
end
