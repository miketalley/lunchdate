class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  STATES = %w[AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY]
  GENDER = ['Male', 'Female']
  SEXUAL_ORIENTATION = ['Straight', 'Lesbian', 'Gay', 'Bisexual', 'Pansexual', 'Transgender', 'Transsexual', 'Queer', 'Questioning', 'Intersex', 'Intersexual', 'Asexual', 'Prefer Not to Share']
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   has_many :matches
   has_many :lunch_dates
   has_many :lunch_dates, through: :matches
   has_many :interests

   def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

end
