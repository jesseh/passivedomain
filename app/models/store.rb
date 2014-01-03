module Store

  attr_reader :active_record_class, :model_class

  def initialize(active_record_class, model_class=nil)
    @active_record_class = active_record_class
    @model_class = model_class
  end

  def find_by_id(id)
    model_from_record(active_record_class.find_by_id(id))
  end

  def find_by_name(name)
    model_from_record(active_record_class.find_by_name(name))
  end

  def find_all
    active_record_class.all.map { |record| model_from_record(record) }
  end

  def create(form)
    if form.valid?
      model_from_record(active_record_class.create!(form.attributes))
    else
      form
    end
  end

  private

  def model_from_record(record)
    if model_class
      model_instance = model_class.new
      update_model(model_instance, record)
      model_instance
    else
      record
    end
  end

  def update_model(instance, record)
    raise "initialize_record method must be over-ridden by an including class."
  end


end
