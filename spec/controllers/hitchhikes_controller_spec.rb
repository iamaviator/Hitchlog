require 'spec_helper'

describe HitchhikesController, 'routes' do
  it { should route(:get, '/hitchhikes').to(:action => 'index') }
end

describe HitchhikesController, 'GET to hitchhikes.json' do
  it "should return valid json" do
    @hitchhike = Factory.create(:hitchhike)
    get :index, :format => 'json'
    response.should be_success
    json = JSON.parse(response.body)
    json['from'].should == @hitchhike.from
    json['to'].should == @hitchhike.to
    json['distance'].should == @hitchhike.distance
    # json['photo']['small'].should == @hitchhike.photo.url(:cropped)
    # json['photo']['large'].should == @hitchhike.photo.url(:large)
  end
end
