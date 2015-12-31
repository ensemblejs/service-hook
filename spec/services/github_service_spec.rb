require 'rails_helper'

RSpec.describe GithubService, type: :service do

  let(:webhook_params) {
    [
      'mal_reynolds/serenity',
      'web',
      {
        url: 'http://ensemblejs.com/notifications',
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    ]
  }

  before do
    @client = double('Octokit::Client')

    @correct_response = double('response')
    allow(@correct_response).to receive(:to_attrs).and_return({
                                                                id: 57,
                                                                ship_class: 'firefly',
                                                                active: true
                                                              })
    allow(@client).to receive(:user)
                        .and_return({login: 'mal_reynolds', avatar_url: 'serenity.com/mal.jpg'})
    allow(Octokit::Client).to receive(:new).and_return(@client)
  end

  it 'filters a correct response' do
    expect(@client).to receive(:create_hook)
                        .with(*webhook_params)
                        .and_return(@correct_response)

    expect(GithubService.create_webhook('2459', 'serenity'))
      .to eq( id: 57,
              errors: {})
  end

  it 'handles 404 not found' do
    expect(@client).to receive(:create_hook)
                        .with(*webhook_params)
                        .and_raise(Octokit::NotFound)
    expect(GithubService.create_webhook('2459', 'serenity'))
      .to eq(errors: {
                not_found_404: "Something about a 404, or even a proper translation dealy"
             })
  end

  it 'handles 422 unprocessable entity' do
    expect(@client).to receive(:create_hook)
                        .with(*webhook_params)
                        .and_raise(Octokit::UnprocessableEntity)
    expect(GithubService.create_webhook('2459', 'serenity'))
      .to eq(errors: {
                unprocessable_entity_422: "Something about a 422, or even a proper translation dealy"
             })
  end
end
