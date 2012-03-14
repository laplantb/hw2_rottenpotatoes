class MoviesController < ApplicationController

  def initialize()
     @all_ratings = []
      Movie.find_by_sql("SELECT rating from movies group by rating").each do |movie|
         @all_ratings << movie.rating
      end
      super
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def redirect_index(   )
    @sortkey = "id"
    @filter_ratings = {}
    redirect = false
    if params.has_key?(:sort)
        @sortkey = params[:sort]
        session[:sort] = params[:sort]
    elsif session.has_key?(:sort)
        @sortkey = session[:sort]
        redirect = true
    end

    if params.has_key?(:ratings)
       @filter_ratings = params[:ratings]
       session[:ratings] = params[:ratings]
    elsif session.has_key?(:ratings)
       @filter_ratings = session[:ratings]
       redirect =  true
    end

     return redirect, if redirect and @sortkey != "id" and !@filter_ratings.empty?  then  movies_path( :sort => @sortkey, :ratings => @filter_ratings ) elsif
                         redirect and @sortkey != "id"  then  movies_path( :sort => @sortkey ) elsif
                         redirect  then movies_path( :ratings => @filter_ratings ) end
   
      
  end
  

  def index
    
    redirect, path = redirect_index()
    if redirect
      redirect_to(path) and return
    end

    
    if not @filter_ratings.empty?
       @movies = Movie.find(:all,:order => @sortkey, :conditions => [ "rating IN (?)", @filter_ratings.keys()] )
    else
       @movies = Movie.find(:all,:order => @sortkey )
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
