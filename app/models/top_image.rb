class TopImage < ApplicationRecord
  belongs_to :user
  # validates :title, presence: true
  # validates :top_icon, presence: true
  mount_uploader :top_icon, TopIconUploader
  serialize :top_icon, JSON

  def self.update_top_image_chooses top_image_chooseds
    TopImage.where("top_choosed_number > ?", 0).update_all(top_choosed_number: 0)
    top_image_chooseds.each do |choosed|
      TopImage.find(choosed[:id]).update_attribute(:top_choosed_number, choosed[:top_choosed_number])
    end
  end

  def self.check_top_chooseds_valid top_image_chooseds
    errors = {}
    ids = top_image_chooseds.map {|choosed| choosed[:id]}.reject {|id| id.blank?}
    errors[:length] = "All id must be present" if ids.size < 5
    top_image_ids = TopImage.where(id: ids).pluck(:id)
    ids.each do |id|
      errors[id] = "Id #{id} is not exist" if top_image_ids.exclude?(id.to_i)
    end
    errors
  end
end
