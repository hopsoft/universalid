# frozen_string_literal: true

module UniversalID::Extensions
  module StringRefinements
    refine String do
      def hostify
        CGI.escape split("::").map(&:dasherize).join("--")
      end

      def dehostify
        CGI.unescape gsub("--", "/").tr("-", "_").classify.gsub(/\AUniversalId/, "UniversalID")
      end
    end
  end
end
