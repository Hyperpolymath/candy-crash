class Category < ApplicationRecord
  # Associations
  has_many :courses, dependent: :destroy
  has_many :questions, dependent: :nullify

  # Callbacks
  before_save :generate_slug

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :slug, uniqueness: true, allow_blank: true

  # Scopes
  default_scope { order(position: :asc) }

  private

  def generate_slug
    self.slug = name.parameterize if name_changed?
  end
end
