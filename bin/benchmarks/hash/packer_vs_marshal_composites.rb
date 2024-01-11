# frozen_string_literal: true

scalars = {
  big_decimal: BigDecimal("123.45"),
  complex: Complex(1, 2),
  date: Date.today,
  datetime: DateTime.now,
  false_class: false,
  float: 123.45,
  integer: 123,
  nil_class: nil,
  # range: 1..100, # TODO: Marshal.load fails on the Range
  rational: Rational(3, 4),
  regexp: /abc/,
  string: "hello",
  symbol: :symbol,
  time: Time.now,
  true_class: true
}

NamedStructPacker = Struct.new(*scalars.keys)

composites = {
  array: scalars.values,
  hash: scalars,
  open_struct: OpenStruct.new(scalars),
  set: Set.new(scalars.values),
  struct: NamedStructPacker.new(*scalars.values)
}

3.times do |i|
  composites[:nested_array] ||= []
  composites[:nested_array] << composites.deep_dup
  composites[:"nested_hash_#{i}"] = composites.deep_dup
end

# ............................................................................................................

runner = Runner.new subject: composites, desc: <<-DESC
   Packs a deeply nested Ruby Hash that contains Composite (i.e. compound) values,
   then unpacks the payload.

   Benchmark:
   - serialize: UniversalID::Packer.pack subject
   - deserialize: UniversalID::Packer.unpack payload

   Control:
   - serialize: Marshal.dump subject
   - deserialize: Marshal.load payload
DESC

# serialize (control) ........................................................................................
runner.control_dump "Marshal.dump" do
  Marshal.dump subject
end

# deserialize (control) ......................................................................................
runner.control_load "Marshal.load" do
  Marshal.load control_payload
end

# serialize ..................................................................................................
runner.run_dump("UniversalID::Packer.pack") do
  UniversalID::Packer.pack subject
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  UniversalID::Packer.unpack payload
end
