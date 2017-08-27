class Log < ApplicationRecord
  attr_accessor :subject_name
  after_create :set_name

  belongs_to :user
  belongs_to :classroom, optional: true


  validates :action, presence: true


  private

    def set_name
      if self.subject && self.subject_id
        subject = self.subject.constantize.find_by(id: self.subject_id)
        if subject.has_attribute?(:name)
          self.subject_name = subject.name
        elsif subject.has_attribute?(:title)
          self.subject_name = subject.title
        end
      end
    end

end
