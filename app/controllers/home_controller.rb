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
        x.resDay.include?(searchquery) ||
        x.teamName.downcase().include?(searchquery)
        )
      
      @searchResult << x
      
      end
    end
=begin
    tuple = Rsvinfo.new
                  tuple.userId = y["userId"]
                  tuple.userName = y["userName"]
                  tuple.groupName = y["groupName"]
                  tuple.teamName = y["teamName"]
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
  
  
    def mypage
    searchquery = current_user.real_team
    searchquery = searchquery.downcase()
    
    
    @searchResult = []
    
    Rsvinfo.all.each do |x|
      
      if ( x.userId.downcase().include?(searchquery) ||
        x.userName.downcase().include?(searchquery) ||
        x.groupName.downcase().include?(searchquery) ||
        x.resDay.include?(searchquery) ||
        x.teamName.downcase().include?(searchquery)
        )
      
      @searchResult << x
      
      end
    end
=begin
    tuple = Rsvinfo.new
                  tuple.userId = y["userId"]
                  tuple.userName = y["userName"]
                  tuple.groupName = y["groupName"]
                  tuple.teamName = y["teamName"]
                  tuple.resDay = y["resDay"]
                  tuple.hourStr = y["hourStr"]
                  tuple.preNum = y["preNum"]
                  tuple.totalNum = y["totalNum"]
                  tuple.monthCnt = y["monthCnt"]
                  tuple.regDate = y["regDate"]
                  tuple.status = y["status"]
                  tuple.save
=end

  @s = '%02d' % Time.new.month
  end
  
  
  
  
  def main_page
   
     #@yeyak = Rsvinfo.all
     
     @records = Post.order(updated_at: :desc)  #updated_at ? created_at ?
     
     #first_day = Rsvinfo.all.first #DB table 첫번째 row
     #@last_day = Rsvinfo.all.last.resDay.split('-')[2] # DB table 에서 마지막 row의 resDay에서 'day' 부분을 가져옴
     
     
     @now = Time.new.localtime("+09:00") #현재시간 구하기
     
     a = Time.new.localtime("+09:00").to_s.split(' ')[0]
     @t = a.split('-') #t => ex) ["2016", "07", "01"]
     #@t[2] = "01"
     
     @yeyak = Rsvinfo.where("resDay='" + a +"'")
     @notice = RsvDate.first.timeStr
     

     
  end
  
  def comment_write
    
    tuple = Comment.new(useremail:params[:commentuseremail], username:params[:commentusername], userteam:params[:commentuserteam], content:params[:commentcontent], post_id:params[:commentpostid])
    tuple.save
  
  end
  
  def calendar
    @event = Rsvinfo.all
  end
  
  def write
    
    new_post = Post.new
    
    new_post.title = params[:title]
    new_post.writer_info = params[:writer_info]
    new_post.writer_team = params[:writer_team]
    new_post.writer_contact = params[:writer_contact]
    new_post.writer_time = params[:writer_time]
    
    tempStr = params[:writer_time]
    splitedStr = tempStr.split(' ')
    
    resDate = splitedStr[0]
    resTime = splitedStr[2].to_s
    resTimehour = resTime.split(':')[0]
    
    if(splitedStr[1] == "오후")
      resTimehour = resTimehour.to_i + 12
    end
      resTimehour = resTimehour.to_s
    if resTime.length < 2
      resTimehour = "0" + resTime
    end
    
    new_post.content = params[:content]
    new_post.optionsRadios = params[:optionsRadios]


    Rsvinfo.all.each do |x|
      
      if ((x.getRes_startTime == resTimehour) && (x.resDay == resDate))
        new_post.rsvinfo_id = x.id
      end
      
    end
    
    new_post.save
    
    redirect_to "/home/board_view"
  end
  
  def destroy
    @one_post = Post.find(params[:post_id])
    @one_post.destroy
    redirect_to "/home/board_view"
  end
  
  def update_view
    @one_post = Post.find(params[:post_id])
  end
  
  def update
    @one_post = Post.find(params[:post_id])
    @one_post.title= params[:title]
    @one_post.writer_info = params[:writer_info]
    @one_post.writer_team = params[:writer_team]
    @one_post.writer_contact = params[:writer_contact]
    @one_post.writer_time = params[:writer_time]
    @one_post.content = params[:content]
    @one_post.optionsRadios =params[:optionsRadios]
    @one_post.save
    redirect_to "/home/board_view"
  end
  
  def board_view
    @post= Post.all.order("id desc")
  end
  
  def post_view
    postid = params[:postid]
    @post = Post.find(postid)
    
  end

  def showDB
    @tuple = Rsvinfo.all
  end
  
  def updateDB
    @teamNames = Rsvinfo.teamNames
    @teamNames.delete('ku')
    Rsvinfo.updateTeamNames @teamNames
  end
end
