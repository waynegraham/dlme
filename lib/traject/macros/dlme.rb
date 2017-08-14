module Macros
  module DLME
    def transform_values(context, hash)
      hash.transform_values do |lambdas|
        accumulator = []
        Array(lambdas).each do |lambda|
          lambda.call(context.source_record, accumulator, context)
        end
        accumulator
      end
    end
  end
end
