class Profile < ActiveRecord::Base

  belongs_to :user
  #acts_as_ferret

  ALL_FIELDS = %w(first_name last_name occupation gender birthdate city state zip_code)
  STRING_FIELDS = %w(first_name last_name occupation city state)
  VALID_GENDERS = ["Male", "Female"]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  ZIP_CODE_LENGTH = 5


  validates_length_of STRING_FIELDS, :maximum => DB_STRING_MAX_LENGTH
  validates_inclusion_of :gender, :in => VALID_GENDERS, :allow_nil => true,
                         :message => "must be Male or Female"
  validates_inclusion_of :birthdate, :in => VALID_DATES, :allow_nil => true,
                         :message => "is invalid"
  validates_format_of :zipcode, :with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/,
                      :message => "must be a 5 digit number"

  def full_name
    [first_name, last_name].join(" ")
  end

  def location
    if not zipcode.blank? and (city.blank? or state.blank?)
      lookup = GeoDatum.find_by_zipcode(zipcode)
      if lookup
        self.city = lookup.city.capitalize_each if city.blank?
        self.state = lookup.state if state.blank?
      end
    end
    [city, state, zipcode].join(" ")
  end

  def age
    return if birthdate.nil?
    today = Date.today
    if today.month >= birthdate.month and today.day >= birthdate.day
      today.year - birthdate.year
    else
      today.year - birthdate.year - 1
    end
  end

  def self.search_by_initial(initial, page)
    paginate(:per_page => 7, :page => page,
             :conditions => ["last_name like ?", initial+'%'],
             :order => "last_name, first_name")
  end

  def self.find_by_age_and_sex_and_location(params)
    where = []
    # Set up age restrictions
    unless params[:min_age].blank?
      where << "ADDDATE(birthdate, INTERVAL :min_age YEAR) < CURDATE()"
    end
    unless params[:max_age].blank?
      where << "ADDDATE(birthdate, INTERVAL :max_age+1 YEAR) > CURDATE()"
    end
    # Set up Gender restrictions
    where << "gender = :gender" unless params[:gender].blank?
    #Set up the distance restrictions
    zip_code = params[:zip_code]
    unless zip_code.blank? and params[:miles].blank?
      location = GeoDatum.find_by_zip_code(zip_code)
      distance = sql_distance_away(location)
      where << "#{distance} <= :miles"
    end
    if where.empty?
      []
    else
      paginate(:per_page => 7, :page => params[:page],
               :joins => "LEFT JOIN geo_data on geo_data.zip_code = specs.zip_code",
               :conditions => [where.join(" AND "), params],
               :order => "last_name, first_name")
    end
  end

  private

  def self.sql_distance_away(point)
    h = "POWER(SIN((RADIANS(latitude - #{point.latitude}))/2.0), 2) + " +
        "COS(RADIANS(#{point.latitude})) * COS(RADIANS(latitude)) * " +
        "POWER(SIN((RADIANS(longitude - #{point.longitude}))/2.0), 2)"
    r = 3956 #Earth's radius in miles
    "2 * #{r} * ASIN(SQRT(#{h}))"
  end




end
