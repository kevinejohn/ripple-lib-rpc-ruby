module Ripple
  module Model
    class Path
      attr_accessor :source_amount
      attr_accessor :paths_computed

      def initialize(path_response)
        self.source_amount = Ripple::Model::Amount.new(path_response.source_amount)
        self.paths_computed = path_response.paths_computed
      end
    end
  end
end
