# require needed files

require './test/sets/store_contexts'
require './test/sets/employee_contexts'
require './test/sets/assignment_contexts'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::StoreContexts
  include Contexts::EmployeeContexts
  include Contexts::AssignmentContexts
  
 def create_contexts
    create_employees
    create_stores
    create_assignments
    
  end
  
  def destroy_contexts
    destroy_employees
    destroy_stores
    destroy_assignments
    
  end
  

end