namespace :api do
  desc "Call GetAreaClass api and import area data into database"
  task get_area_class: :environment do
    Api::AreaApi.new(Settings.application_id).request.each_with_index do |area, i|
      if area.save
        puts "Adding ... " + area.long_name
      else
        puts "Skipping ... " + area.long_name
      end
    end
  end
end
