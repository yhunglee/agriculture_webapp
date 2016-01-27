require 'rails_helper'

describe API::V1::SpecifiedVegetables do
  context 'When send a request for three parameters about date, name and/or trade location for specified vegetabls using path: GET /specified_vegetables/query' do
    it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated item name:金針筍 and a delegated day:20131031 in one request.' do
	    get "/specified_vegetables/query?transaction_date=20131031\&name=%E9%87%91%E9%87%9D%E7%AD%8D"
	    expect(response).to be_success
	    expect(json.first["name"]).to eq("金針筍")
    end

    it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated day:20131031 in one request' do
	    pending
	    #get "/specified_vegetables/query?transaction_date=20131031"
	    #expect(response.status).to eq(200)
	    #expect(JSON.parse(response.body)).to eq [] 
    end 

    if 'should return a JSON-format response of transaction prices of vegetables if we use a delegated day:20131031, a delegated item name:金針筍 and a delegated trade location:三重市 in one request ' then
	    pending
    end
  end
end
