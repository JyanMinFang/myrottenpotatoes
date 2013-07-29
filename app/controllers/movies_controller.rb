class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.allratings()

    if params[:ratings].nil? && params["sort"].nil? && (session[:indexfilter].nil? == false)
      flash.keep
      redirect_to movies_path + "?" + session[:indexfilter]
    end

    whereClause = params[:ratings].nil? ? {} : {rating: params[:ratings].keys}
    @movies = params["sort"].nil? ? Movie.where(whereClause) : Movie.where(whereClause).order(params["sort"])

    @sort = params["sort"]

    @sort_title = { "sort"=> "title" }
    @sort_release_date = { "sort"=> "release_date" }
    unless params[:ratings].nil?
      params[:ratings].each do |key, val|
        @sort_title["ratings[" + key + "]"] = val
        @sort_release_date["ratings[" + key + "]"] = val
      end
    end
    session[:indexfilter] = request.query_string.length > 0 ? request.query_string : nil
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
