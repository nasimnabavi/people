require 'csv'

task update_join_time: :environment do
  path = Rails.root.join("users_#{Rails.env}.csv")

  csv_text = File.read(path)
  csv = CSV.parse(csv_text, :headers => true)

  csv.each do |row|
    if user = User.find_by_email(row[0])
      join_time = row[1] ? Time.zone.parse(row[1]) : Time.zone.now
      user.update_attributes(team_join_time: join_time)
    end
  end
end

