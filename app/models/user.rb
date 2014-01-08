class User < ActiveRecord::Base
	before_save { self.email = email.downcase}
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
					  uniqueness: {case_sensitive: false}
    validates :password, length: { minimum: 6 }
	has_secure_password
  # has_many implements the user/micropost association.
  # The option :dependent: :destroy arranges for the dependent
  # microposts (i.e., the ones belonging to the given user)
  # to be destroyed when user itself is destroyed
  has_many :microposts, dependent: :destroy 

    def User.new_remember_token
    	SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
    end

    # Implementation for the micropost status feed
    def feed
      # This is preliminary. See "Following users" for the full implementation.
      # The question mark ensures that id is properly escaped 
      # before being included in the underlying SQL query, thereby
      # avoiding SQL injection.
      microposts
    end

    private

      def create_remember_token
      	self.remember_token = User.encrypt(User.new_remember_token)
      end

end
