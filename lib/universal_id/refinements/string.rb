# frozen_string_literal: true

module UniversalID::Refinements
  module String
    refine ::String do
      def hostify
        ::CGI.escape split("::").map(&:dasherize).join("--")
      end

      def dehostify
        ::CGI.unescape gsub("--", "/").tr("-", "_").classify.gsub(/\AUniversalId/, "UniversalID")
      end
    end
  end
end
