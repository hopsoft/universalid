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

NamedStructUID = Struct.new(*scalars.keys)

composites = {
  array: scalars.values,
  hash: scalars,
  open_struct: OpenStruct.new(scalars),
  set: Set.new(scalars.values),
  struct: NamedStructUID.new(*scalars.values)
}

5.times do |i|
  composites[:nested_array] ||= []
  composites[:nested_array] << composites.deep_dup
  composites[:"nested_hash_#{i}"] = composites.deep_dup
end

# ............................................................................................................

runner = Runner.new subject: composites, desc: <<-DESC
   Builds a UID for a Ruby Hash that contains Composite (i.e. compound) values
   then parses and decodes the payload.

   Benchmark:
   - serialize: URI::UID.build(subject).to_s
   - deserialize: URI::UID.parse(payload).decode

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
runner.run_dump("UniversalID::Encoder.encode") do
  UniversalID::Encoder.encode subject
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Encoder.decode") do
  UniversalID::Encoder.decode payload
end
