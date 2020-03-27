require 'spec_helper'

describe Freshworks::Metric do
  let(:valid_message) { true }
  let(:api_key) { '5000' }
  let(:metric) { Struct.new(:id, :name) { def serialize; {id: id, name: name}; end } }

  before do
    allow(Freshworks.configuration).to receive(:account_api_key).and_return(api_key)
  end

  describe 'retrieve' do
    it 'sends the proper request' do
      name = 'ted'
      request_url = "https://api-us.freshsuccess.com/api/v2/metrics/#{name}/?api_key=#{api_key}"
      data = {}
      method = :get

      expect(HTTParty).to receive(method).with(request_url, data).and_return(valid_message)
      expect(Freshworks::Response).to receive(:new)

      Freshworks::Metric.retrieve(name)
    end
  end

  describe 'bulk_insert_modify' do
    it 'sends the proper request' do
      metrics = [metric.new(1, 'ted'), metric.new(2, 'ned')]
      request_url = "https://api-us.freshsuccess.com/api/v2/metrics/?api_key=#{api_key}"
      data = { body: '{"records": [{:id=>1, :name=>"ted"}, {:id=>2, :name=>"ned"}]}',
               headers: {'Content-Type': 'application/json'} }
      method = :post

      expect(HTTParty).to receive(method).with(request_url, data).and_return(valid_message)
      expect(Freshworks::Response).to receive(:new)

      Freshworks::Metric.bulk_insert_modify(metrics)
    end
  end

  describe 'modify' do
    it 'sends the proper request' do
      name = 'ted'
      met = metric.new(1, name)
      request_url = "https://api-us.freshsuccess.com/api/v2/metrics/#{name}/?api_key=#{api_key}"
      data = { body: '{"id":1,"name":"ted"}',
               headers: {'Content-Type': 'application/json'} }
      method = :put

      expect(HTTParty).to receive(method).with(request_url, data).and_return(valid_message)
      expect(Freshworks::Response).to receive(:new)

      Freshworks::Metric.modify(name, met)
    end
  end

  describe 'delete' do
    it 'sends the proper request' do
      name = 'ted'
      request_url = "https://api-us.freshsuccess.com/api/v2/metrics/#{name}/?api_key=#{api_key}"
      data = {}
      method = :delete

      expect(HTTParty).to receive(method).with(request_url, data).and_return(valid_message)
      expect(Freshworks::Response).to receive(:new)

      Freshworks::Metric.delete(name)
    end
  end
end
