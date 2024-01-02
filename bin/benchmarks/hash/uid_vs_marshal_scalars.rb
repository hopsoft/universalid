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

runner = Runner.new subject: scalars, desc: <<-DESC
   Builds a UID for a Ruby Hash that contains Scalar (i.e. primitive) values,
   then parses the UID and decodes the payload.

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
runner.run_dump("URI::UID.build + to_s") do
  URI::UID.build(subject).to_s
end

# deserialize ................................................................................................
runner.run_load("URI::UID.parse + decode") do
  URI::UID.parse(payload).decode
end
