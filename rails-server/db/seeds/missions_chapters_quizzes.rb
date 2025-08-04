missions_root = Rails.root.join('content/missions')

# All folders should be in format of Number- Chapter Name, where '- ' will separate chapter number with name
FOLDER_DELIMITER = '- '

class Folder
  def self.parse(str)
    separator_index = str.index(FOLDER_DELIMITER)
    number = str[0..(separator_index-1)].to_i
    name = str[(separator_index+2)..-1].strip
    [number, name]
  end
end


class ChapterLoader
  def self.parse(file_name)
    course_content = File.read(file_name)
    # This regex matches --- even if it has space after ---
    parts = course_content.split(/^---\s*$/)

    # Parts size should always be 3
    basic_details = YAML.safe_load(parts[1])
    content = parts[2..].join('---\n').strip

    basic_details['content'] = content

    basic_details
  end
end


# Deleting everything and starting from scratch
Quiz.delete_all
UserChapter.delete_all
Chapter.delete_all
Mission.delete_all

chapter_id_counter = 1

Dir.children(missions_root).sort.each do |mission_folder_name|
  mission_path = File.join(missions_root,mission_folder_name)

  # Create a Mission
  mission_number, mission_name = Folder.parse(mission_folder_name)
  puts "MISSION: #{mission_number} = #{mission_name}"
  # REVIEW: Check if we even need content portion for missions
  currentMission = Mission.find_or_create_by(id: mission_number)
  currentMission.update!(title: mission_name, content: mission_name )

  # Loop through all chapters and Folders: 
  Dir.children(mission_path).sort.each do |chapter_folder_name|
    chapter_path = File.join(mission_path, chapter_folder_name)

    chapter_number, chapter_name = Folder.parse(chapter_folder_name)
    puts "  CHAPTER: #{chapter_number} #{chapter_name}"

    # Getting course and quizzes
    course_file = File.join(chapter_path,'chapter.md')
    quiz_file = File.join(chapter_path, 'quiz.json')

    chapter_content = ChapterLoader.parse(course_file)
    quiz_content = File.read(quiz_file)
    quiz_content = JSON.parse(quiz_content)

    currentChapter = Chapter.find_or_create_by(id: chapter_id_counter, mission: currentMission)
    currentChapter.update!( title: chapter_content['title'] || chapter_name, duration_minutes: chapter_content['duration_minutes'] || 0, content: chapter_content['content'])


    quiz_content.each do |quiz|
      currentQuiz = Quiz.find_or_create_by(chapter: currentChapter)
      currentQuiz.update!(question: quiz['question'], question_type: quiz['question_type'], options: quiz['options'], correct_option_index: quiz['correct_option_index'], explanation: quiz['explanation'])
    end

    chapter_id_counter +=1
    


  end
end

