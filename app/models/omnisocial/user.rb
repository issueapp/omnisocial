module Omnisocial
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    field :remember_token

    references_one :login_account, :class_name => 'Omnisocial::LoginAccount', :dependent => :destroy
    delegate :login, :name, :picture_url, :account_url, :to => :login_account

    def from_twitter?
      login_account.kind_of? TwitterAccount
    end
  
    def from_facebook?
      login_account.kind_of? FacebookAccount
    end

    def remember
      update_attributes(:remember_token => ::BCrypt::Password.create("#{Time.now}-#{self.login_account.class.to_s}-#{self.login}")) unless new_record?
    end
  
    def forget
      update_attributes(:remember_token => nil) unless new_record?
    end
  end
end