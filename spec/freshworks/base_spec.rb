require 'spec_helper'

describe Freshworks::Base do
  let(:valid_message) { true }
  let(:api_key) { '5000' }
  let(:account) { Struct.new(:id, :name) { def serialize; {id: id, name: name}; end } }

  before do
    allow(Freshworks.configuration).to receive(:account_api_key).and_return(api_key)
  end

  describe 'endpoint_path' do
    it 'should raise a NotImplementedError' do
      expect { Freshworks::Base.endpoint_path }.to raise_error(NotImplementedError)
    end
  end

  describe 'json_data' do
    it 'should properly package json data' do
      body = {a: 1, b: 2}
      expect(Freshworks::Base.json_data body).to eq({ body: body, headers: {'Content-Type': 'application/json'} })
    end
  end

  describe 'endpoint' do
    it 'should handle nil params' do
      params = ['one', nil, 'two', nil, 'three']
      endpoint_path = '/'
      final_params = [endpoint_path, 'one', 'two', 'three', Freshworks.api_key_uri]

      allow(Freshworks::Base).to receive(:endpoint_path).and_return([endpoint_path])
      expect(Freshworks).to receive(:full_endpoint_uri).with(Freshworks::Base::BASE_URI, Freshworks::Base::VERSION_URI, final_params)

      Freshworks::Base.endpoint(params)
    end

    it 'should handle nested params' do
      params = [['one', 'two'], 'three']
      endpoint_path = '/'
      final_params = [endpoint_path, 'one', 'two', 'three', Freshworks.api_key_uri]

      allow(Freshworks::Base).to receive(:endpoint_path).and_return([endpoint_path])
      expect(Freshworks).to receive(:full_endpoint_uri).with(Freshworks::Base::BASE_URI, Freshworks::Base::VERSION_URI, final_params)

      Freshworks::Base.endpoint(params)
    end
  end
end