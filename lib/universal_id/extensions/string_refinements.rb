# frozen_string_literal: true

module UniversalID::Extensions
  module StringRefinements
    refine String do
      def componentize
        CGI.escape split("::").map(&:underscore).join("-")
      end

      def decomponentize
        CGI.unescape(self).tr("-", "/").classify.gsub(/\AUniversalId/, "UniversalID")
      end
    end
  end
end
