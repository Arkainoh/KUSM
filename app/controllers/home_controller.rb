require 'nokogiri'
require 'open-uri'
require 'json'

class HomeController < ApplicationController
  def index
    unless user_signed_in?
      redirect_to "/users/sign_in"
    else
      redirect_to "/home/main_page"
    end
  end
  
  def search_result
    searchquery = params[:searchquery]
    searchquery = searchquery.downcase()
    
    if searchquery == ""
          redirect_to "/home/main_page" #if user doesn't provide anything, do nothing
      return -1
    end
    
    @searchResult = []
    
    Rsvinfo.all.each do |x|
      
      if ( x.userId.downcase().include?(searchquery) ||
        x.userName.downcase().include?(searchquery) ||
        x.groupName.downcase().include?(searchquery) ||
        x.resDay.include?(searchquery)
        )
      
      @searchResult << x
      
      end
    end
=begin
    tuple = Rsvinfo.new
                  tuple.userId = y["userId"]
                  tuple.userName = y["userName"]
                  tuple.groupName = y["groupName"]
                  tuple.resDay = y["resDay"]
                  tuple.hourStr = y["hourStr"]
                  tuple.preNum = y["preNum"]
                  tuple.totalNum = y["totalNum"]
                  tuple.monthCnt = y["monthCnt"]
                  tuple.regDate = y["regDate"]
                  tuple.status = y["status"]
                  tuple.save
=end
  end
  
  def main_page
    
     @yeyak = Rsvinfo.all
     
     first_day = Rsvinfo.all.first #DB table 첫번째 row
     @last_day = Rsvinfo.all.last.resDay.split('-')[2] # DB table 에서 마지막 row의 resDay에서 'day' 부분을 가져옴
     
     @t = first_day.resDay.split('-') #t => ex) ["2016", "07", "01"]
     @now = Time.new.localtime("+09:00") #현재시간 구하기
  end
  
  def test1
    @event = Rsvinfo.all
  end
  
  def write
    
    new_post = Post.new
    
    new_post.title = params[:title]
    new_post.writer_info = params[:writer_info]
    new_post.writer_team = params[:writer_team]
    new_post.writer_contact = params[:writer_contact]
    new_post.writer_time = params[:writer_time]
    new_post.content = params[:content]
    new_post.save

    
    
    redirect_to "/home/board_view"
  end
  
  def board_view
    @post= Post.all
    
  end
  

  def showDB
    @tuple = Rsvinfo.all
  end
  
  def updateDB
   # @groupNames = []
    #Rsvinfo.all.each do |x|
     # @groupNames << x.groupName
    #end
    @groupNames = Rsvinfo.select("groupName")
    #@groupNames = @groupNames.to_a
    
    @groupNames.uniq!
    
    @groupNames.each do |x|
      x.groupName.delete!('0-9')
    end
    
    #중복 제거하기!
  end

  
end
