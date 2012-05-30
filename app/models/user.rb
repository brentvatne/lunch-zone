require 'octokit'
require_relative "../../config/data_mapper"

module LunchZone
  class User
    include DataMapper::Resource

    property :id,                    Serial
    property :nickname,              String, :unique => true
    property :email,                 String, :unique => true
    property :partnerpedia_employee, Boolean
    property :token,                 String

    def self.find_or_create_from_omniauth(params)
      email = params['info']['email']
      user  = first(:email => email)

      if user
        update_employee_status(user)
      else
        create_from_omniauth(params)
      end
    end

    def self.update_employee_status(user)
      if is_visible_on_github_org?(user.nickname)
        user.partnerpedia_employee = true
      else
        user.partnerpedia_employee = false
      end

      user.save
      user
    end

    def self.create_from_omniauth(params)
      nickname = params['info']['nickname']
      token    = params['credentials']['token']
      email    = params['info']['email']

      user = create(
        :email => email,
        :nickname => nickname,
        :partnerpedia_employee => is_visible_on_github_org?(user),
        :token => token
      )
    end

    def self.is_visible_on_github_org?(nickname)
      members = Octokit.organization_members('Partnerpedia').map { |user|
        user['login']
      }

      members.include?(nickname)
    end

    def is_partnerpedia_employee?
      partnerpedia_employee
    end

    def gravatar_url
      # generate this from the email
    end
  end
end
