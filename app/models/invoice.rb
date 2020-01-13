class Invoice < ApplicationRecord
  scope :has_supplier, -> { pluck(:supplier_name).uniq } 
end
