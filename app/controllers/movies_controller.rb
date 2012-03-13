class MoviesController < ApplicationController

  def initialize()
     @all_ratings = []
      Movie.find_by_sql("SELECT rating from movies group by rating").each do |movie|
         @all_ratings << movie.rating
      end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (! params.has_key?(:sort) )
        @sortkey = "id"
    else
        @sortkey = params[:sort]
    end
    @filter_ratings = {}
    if (params.has_key?(:ratings))
      @filter_ratings = params[:ratings]
      @movies = Movie.find(:all,:order => @sortkey, :conditions => [ "rating IN (?)", @filter_ratings.keys()])
    else
      @movies = Movie.find(:all,:order => @sortkey)
    end
  

    
   end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
