# frozen_string_literal: true

class CsvMasterDataService
  def initialize(model, file = nil, key = nil)
    @model = model
    @file  = file
    @key   = key || 'id'
  end

  def import_csv
    import_data(Roo::Spreadsheet.open(@file))
  end

  private

  def data_encode(data)
    data.map do |col|
      col.to_s.encode('Windows-31J', invalid: :replace, undef: :replace)
    end
  end

  def data_master_csv
    @model.select(@model.csv_cols).each do |im|
      yield(im)
    end
  end

  def import_data(spreadsheet)
    inserted_data = []
    updated_data  = {}
    begin
      (2..spreadsheet.last_row).each do |idx|
        row = [spreadsheet.row(1), spreadsheet.row(idx)].transpose.to_h
        if row.dig(@key)
          updated_data[row.dig(@key)] = row.except(@key)
        else
          inserted_data << row
        end
      end
      create(inserted_data) && update(updated_data)
    rescue StandardError => e
      Rails.logger.error e.message
      false
    end
  end
  
  def create(inserted_data)
    ActiveRecord::Base.transaction do
      registered = @model.create!(inserted_data)
      raise ActiveRecord::Rollback unless registered
    end
    true
  rescue StandardError => e
    Rails.logger.error e.message
    false
  end

  def update(updated_data)
    ActiveRecord::Base.transaction do
      updated = @model.update(updated_data.keys, updated_data.values)
      raise ActiveRecord::Rollback unless updated
    end
    true
  rescue StandardError => e
    Rails.logger.error e.message
    false
  end
end