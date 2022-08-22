shared_examples_for 'API Authorizable' do
  context 'unauthorized returns status 401' do
    it 'unless access_token' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
      expect(response.body).to be_empty
    end

    it 'if invalid access_token' do
      do_request(method, api_path, params: { access_token: '123123' }, headers: headers)

      expect(response.status).to eq 401
      expect(response.body).to be_empty
    end
  end
end

shared_examples_for 'Status OK' do
  it 'returns status OK' do
    request
    expect(response).to be_successful
  end
end

shared_examples_for 'Public fields returnable' do
  it 'returns all public fields' do
    request
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'Private fields not returnable' do
  it 'dosn\'t return private fields' do
    fields.each do |attr|
      expect(resource_response).to_not have_key(attr)
    end
  end