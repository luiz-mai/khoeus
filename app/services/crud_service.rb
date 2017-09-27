class CrudService

  def initialize(model, entity = nil)
    @model = model.classify.constantize
    @entity = entity if entity
  end

  def list
    @model.all
  end

  def create(params)
    @entity = @model.create(params)
    @entity.save ? @entity : false
  end

  def retrieve(id)
    @entity = @model.find_by(id: id)
  end

  def update(params)
    @entity.update_attributes(params)
  end

  def delete
    @entity.destroy
  end


end