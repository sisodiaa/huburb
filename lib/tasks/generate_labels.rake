namespace :utils do
  desc "Create label image for all alphabets and stor them in assets directory"
  task :generate_labels do
    ('A'..'Z').each do |c|
      system("convert -background DarkSalmon -fill white -font Corbel -size 200x200  -pointsize 108 -gravity center label:#{c} ./app/assets/images/label_#{c}.png")
      puts "Label created for #{c}"
    end
  end
end
