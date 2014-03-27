module RakutenTravelApi
  module VacantHotelSearch
    class Client < ::RakutenTravelApi::Base::Client
      REQUEST_PATH = "/services/api/Travel/VacantHotelSearch/20131024".freeze
      attr_reader :response
      def initialize(application_id, affiliate_id = nil)
        super(REQUEST_PATH, application_id, affiliate_id)
      end

      def init_params(application_id, affiliate_id)
        @params = ::RakutenTravelApi::VacantHotelSearch::RequestParams.new(application_id, affiliate_id)
        @params.add_params(
          checkin_date: 30.days.since.strftime('%Y-%m-%d'),
          checkout_date: 31.days.since.strftime('%Y-%m-%d'),
        )
      end

      def request
        yield @params if block_given?
        @response = ::RakutenTravelApi::VacantHotelSearch::Response.new(get_request)
      end

      def next
        nil unless next?
        @params.add_param(:page, @response.current_page + 1)
        request
      end

      def next?
        return false if @response.nil?
        return false unless @response.success?
        return @response.next?
      end
    end

  end
end