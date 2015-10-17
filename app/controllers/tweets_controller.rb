class TweetsController < ApplicationController
  before_filter :authenticate_user!

  def search
     options = params.symbolize_keys.select{|k,v| [:q,:result_type,:page,:max_id].include?(k)}
     @resultset = Tweet.search(options) unless options[:q].blank? 
   
  end

end
