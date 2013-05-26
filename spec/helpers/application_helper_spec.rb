require "spec_helper"

describe ApplicationHelper do
  
  describe "#sortable" do 
    it "not ordered columns must to return default 'asc' direction without a image" do
      helper.stub(:sort_column).and_return("_another_column_")
      helper.stub(:sort_direction).and_return("asc")
      helper.stub(:url_options).and_return({:_path_segments=>{:action=>"index", :controller=>"books"}})
      helper.sortable('title').should eql('<a href="/books?direction=asc&amp;sort=title">Title </a>')
    end

    it "ordered columns with 'asc' must to return a direction 'desc' with a up image" do
      helper.stub(:sort_column).and_return("title")
      helper.stub(:sort_direction).and_return("asc")
      helper.stub(:url_options).and_return({:_path_segments=>{:action=>"index", :controller=>"books"}})
      helper.sortable('title').should eql('<a href="/books?direction=desc&amp;sort=title">Title <i class="icon-chevron-up"></i></a>')
    end

    it "ordered columns with 'desc' must to return a direction 'asc' with a down image" do
      helper.stub(:sort_column).and_return("title")
      helper.stub(:sort_direction).and_return("desc")
      helper.stub(:url_options).and_return({:_path_segments=>{:action=>"index", :controller=>"books"}})
      helper.sortable('title').should eql('<a href="/books?direction=asc&amp;sort=title">Title <i class="icon-chevron-down"></i></a>')
    end

  end    
end