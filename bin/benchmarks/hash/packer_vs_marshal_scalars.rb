# frozen_string_literal: true

scalars = {
  big_decimal: BigDecimal("123.45"),
  complex: Complex(1, 2),
  date: Date.today,
  date_time: DateTime.now,
  false_class: false,
  float: 123.45,
  integer: 123,
  nil_class: nil,
  range: 1..100,
  rational: Rational(3, 4),
  regexp: /abc/,
  string: "hello",
  symbol: :symbol,
  time: Time.now,
  true_class: true
}

runner = Runner.new "Hash with Scalar Values (binary)", <<-DESC
   Serializes a Ruby Hash that contains scalar values (primitives)
   then deserializes the payload.

   Benchmark:
   - serialize: UniversalID::Packer.pack subject
   - deserialize: UniversalID::Packer.unpack payload

   Control:
   - serialize: Marshal.dump subject
   - deserialize: Marshal.load subject

   SEE: bin/#{__FILE__.split("/bin/").last}
DESC

runner.subject = scalars

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
