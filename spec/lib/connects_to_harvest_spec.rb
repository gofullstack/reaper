require 'invoicing/connects_to_harvest'

shared_examples_for 'a handled harvest exception' do

  it 'should handle the exception' do
    expect {
      Invoicing::ConnectsToHarvest.connect(params) do
        exception.call
      end
    }.to throw_symbol(:warden, :action => expected_action.to_s)
  end

end

describe Invoicing::ConnectsToHarvest do

  subject { Invoicing::ConnectsToHarvest }

  let(:params) {
    {
      'subdomain' => 'api',
      'access_token' => 'Nag+ipXLI8XS+jjBlDc0/0CNwWmRTEotIgUh2zZ2fcbqnmTdnUl76y5BvqQdkAev1DNBEbKU58XikdIJ1nK4TQ=='
    }
  }

  describe '.connect' do

    context 'given params with subdomain, access_token' do

      context 'by default' do

        it 'should connect using SSL' do
          Harvest.should_receive(:oauth_client).with(
            params['subdomain'],
            params['access_token'],
            { :ssl => true }
          ).and_return true

          subject.connect(params) do |harvest|
            nil
          end
        end

      end

    end

    context 'when Harvest raises' do

      before :each do
        Harvest.should_receive(:oauth_client).with(
          params['subdomain'],
          params['access_token'],
          { :ssl => true }
        ).and_return true
      end

      context 'when Harvest raises BadRequest' do

        let(:exception) { lambda { raise Harvest::BadRequest, '' } }
        let(:expected_action) { 400 }

        it_should_behave_like 'a handled harvest exception'

      end

      context 'when Harvest raises AuthenticationFailed' do

        let(:exception) { lambda { raise Harvest::AuthenticationFailed, '' } }
        let(:expected_action) { 401 }

        it_should_behave_like 'a handled harvest exception'

      end

      context 'when Harvest raises NotFound' do

        let(:exception) { lambda { raise Harvest::NotFound, '' } }
        let(:expected_action) { 404 }

        it_should_behave_like 'a handled harvest exception'

      end

      context 'when Harvest raises ServerError' do

        let(:exception) { lambda { raise Harvest::ServerError, '' } }
        let(:expected_action) { 500 }

        it_should_behave_like 'a handled harvest exception'

      end

      context 'when Harvest raises Unavailable' do

        let(:exception) { lambda { raise Harvest::Unavailable, '' } }
        let(:expected_action) { 502 }

        it_should_behave_like 'a handled harvest exception'

      end

      context 'when Harvest raises RateLimited' do

        let(:exception) { lambda { raise Harvest::RateLimited, '' } }
        let(:expected_action) { 503 }

        it_should_behave_like 'a handled harvest exception'

      end

      context 'when Harvest raises InformHarvest' do

        let(:exception) { lambda { raise Harvest::InformHarvest, '' } }
        let(:expected_action) { 'oh_no' }

        it_should_behave_like 'a handled harvest exception'

      end

    end

  end

end
