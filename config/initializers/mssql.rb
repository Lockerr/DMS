module ActiveRecord
  module ConnectionAdapters
    class SQLServerAdapter
      SUPPORTED_VERSIONS = [2000,2005,2008].freeze
    end
  end
end

module Arel
  module Nodes 
    module Visitors
      class SQLServer
        def visit_Arel_Nodes_Limit(o) 
          "TOP #{visit o.expr}"
        end
      end
    end
  end
end 