class MainController < Ramaze::Controller
  map '/'
  layout 'layout'
  
  def index
    @routes = Model::Route.order(:id).all
  end
  
  def show(id)
    @route = Model::Route[id]
    redirect "/" if @route.nil?
    @title = @route.name
  end
  
  # Basically the same as show but with a different view, and title.
  def map(id)
    @route = Model::Route[id]
    redirect "/" if @route.nil?
    @title = "#{@route.name} - Map"
  end
  
  private
  
  def title
    if @title.nil?
      return "CodiacTranspo - Routes"
    else
      return "CodiacTranspo - #{@title}"
    end
  end
  
end
