require 'csv'
class CsvImportation
  attr_accessor :fields
  
  def populate_fields(row, field_names)
    self.fields = Hash.new
    row.each_with_index do |field, index|
      if !field.nil?
        field.strip!
        self.fields[field_names[index]] = field if !field.empty?
      end
    end
  end

  def do_csv_import(filename)
    field_names = nil
    CSV.open(filename, 'r', "\t") do |row|
      if field_names.nil?
        field_names = row.collect{|c| c.blank? ? c : c.strip }
        next
      end
      self.populate_fields(row, field_names)
      yield
    end
  end
end
