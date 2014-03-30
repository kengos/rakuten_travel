require 'spec_helper'

describe Api::VacantApi do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:hotel) { create(:hotel, no: '509') }
  let(:api) { described_class.new(Settings.application_id) }
  # describe '#request' do
  #   let(:checkin) { 10.day.since }
  #   let(:vcr_name) { 'models/api/vacant_api/' + hotel.no + '_' + checkin.strftime('%Y%m%d') }
  #   subject(:response) {
  #     VCR.use_cassette(vcr_name) do
  #       api.request(hotel, checkin)
  #     end
  #   }

  #   it { response }
  # end

  describe '#build_plan' do
    let(:params) {
      {
       "planId" => 10000,
       "planName" => "宿泊プラン【朝食付】",
       "pointRate" => 10,
       "withDinnerFlag" => 0,
       "withBreakfastFlag" => 1,
       "payment" => "1",
       "planContents" => 'foo'
      }
    }
    let(:room) { create(:room, hotel: hotel) }
    it { expect { api.build_plan(hotel, room, params) }.to change(Plan, :count).by(1) }

    context 'attributes' do
      subject(:plan) { api.build_plan(hotel, room, params) }
      it do
        expect(plan.hotel_id).to eq hotel.id
        expect(plan.room_id).to eq room.id
        expect(plan.name).to eq '宿泊プラン【朝食付】'
        expect(plan.code).to eq 10000
        expect(plan.point_rate).to eq 10
        expect(plan.with_dinner).to eq false
        expect(plan.with_breakfast).to eq true
        expect(plan.payment_code).to eq 1
        expect(plan.description).to eq 'foo'
      end
    end
  end

  describe '#build_room' do
    context '喫煙' do
      let(:params) {
        {'roomClass' => 'sm', 'roomName' => '喫煙シングル'}
      }
      subject(:room) { api.build_room(hotel, params) }
      it do
        expect(room.hotel_id).to eq hotel.id
        expect(room.code).to eq 'sm'
        expect(room.name).to eq '喫煙シングル'
        expect(room.smoking).to eq true
      end
      context '同じものをいれても、SAVEはされない' do
        before { api.build_room(hotel, params) }
        it { expect{ api.build_room(hotel, params) }.to change(Room, :count).by(0) }
        it { expect(api.build_room(hotel, params)).to be_kind_of Room }
      end
    end

    context '禁煙' do
      let(:params) {
        {'roomClass' => 'sm', 'roomName' => '禁煙シングル'}
      }
      subject(:room) { api.build_room(hotel, params) }
      it do
        expect(room.hotel_id).to eq hotel.id
        expect(room.code).to eq 'sm'
        expect(room.name).to eq '禁煙シングル'
        expect(room.smoking).to eq false
      end
    end
  end
end
