module JsonapiCompliable
  class Scoping::Filter < Scoping::Base
    include Scoping::Filterable

    def apply
      each_filter do |filter, value|
        @scope = filter_scope(filter, value)
      end

      @scope
    end

    def filter_scope(filter, value)
      if custom_scope = filter.values.first[:filter]
        custom_scope.call(@scope, value)
      else
        resource.adapter.filter(@scope, filter.keys.first, value)
      end
    end

    private

    def each_filter
      filter_param.each_pair do |param_name, param_value|
        filter = find_filter!(param_name.to_sym)
        value  = param_value
        value  = value.split(',') if value.is_a?(String) && value.include?(',')
        yield filter, value
      end
    end
  end
end
